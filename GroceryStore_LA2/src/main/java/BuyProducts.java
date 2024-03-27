import java.io.FileInputStream; 
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties; 
import java.util.logging.Level; 
import java.util.logging.Logger;

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

import com.grocery.store.NoStockException;

@WebServlet("/buyProducts")
public class BuyProducts extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static Properties getConnectionData() {
	
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(BuyProducts.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
	
		return props; 
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
		doPost(request, response); 
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		Properties props = getConnectionData();
	
		try { 
			Class.forName("com.mysql.cj.jdbc.Driver"); 
		} catch(ClassNotFoundException cnfe) { 
			System.out.println(cnfe); 
		}
		
		String url = props.getProperty("db.url"); 
		String user = props.getProperty("db.user"); 
		String password = props.getProperty("db.password");
		
		try (Connection conn = DriverManager.getConnection(url, user, password);) {
		
			HttpSession session = request.getSession();
			if(session.getAttribute("id") == null || session.getAttribute("user") == null) {
				response.sendRedirect("SignIn.jsp");
				return;
			}
			
			synchronized(session) {
				
				if(session.getAttribute("cartItems") != null) {
				
					int userID = (int) session.getAttribute("id");
	            
		            String template = "SELECT BuyerID FROM Buyer WHERE UserID = ?";
		            PreparedStatement inserter = conn.prepareStatement(template);
		            
		            inserter.setInt(1, userID);
		            
		            ResultSet rs = inserter.executeQuery();
		            rs.next();
		            
		            int buyerID = rs.getInt("BuyerID");
		            
		            
		            template = "SELECT Item.ShopkeeperID, Cart.ItemID, Item.Stock, Cart.Quantity, Cart.Quantity * Item.Price AS Cost FROM Item, Cart WHERE Cart.BuyerID = ? AND Cart.ItemID = Item.ItemID";
		            inserter = conn.prepareStatement(template);
		            
		            inserter.setInt(1, buyerID);
		            
		            rs = inserter.executeQuery();
		            
		            
		            conn.setAutoCommit(false);
		            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
		            
		            try {
			            template = "INSERT INTO OrderedItem (BuyerID, ShopkeeperID, ItemID, Quantity, Cost, OrderDate) VALUES (?, ?, ?, ?, ?, ?)";
			            inserter = conn.prepareStatement(template);
			            
			            String template2 = "UPDATE Item SET Stock = ? WHERE ItemID = ?";
			            PreparedStatement inserter2 = conn.prepareStatement(template2);
			            
			            String template3 = "DELETE FROM Cart WHERE ItemID = ? AND BuyerID = ?";
			            PreparedStatement inserter3 = conn.prepareStatement(template3);
			            
			            while(rs.next()) {
		
			            	long milliseconds = System.currentTimeMillis();
			            	Date orderDate = new Date(milliseconds);
			            	
			            	inserter.setInt(1, buyerID);
			            	inserter.setInt(2, rs.getInt("ShopkeeperID"));
			            	inserter.setInt(3, rs.getInt("ItemID"));
			            	inserter.setInt(4, rs.getInt("Quantity"));
			            	inserter.setDouble(5, rs.getInt("Cost"));
			            	inserter.setDate(6, orderDate);
			            	
			            	int updatedStock = rs.getInt("Stock") - rs.getInt("Quantity");
			            	if(updatedStock < 0) {
			            		throw new NoStockException();
			            	}
			            	inserter2.setInt(1, updatedStock);
			            	inserter2.setInt(2, rs.getInt("ItemID"));
			            	
			            	inserter3.setInt(1, rs.getInt("ItemID"));
			            	inserter3.setInt(2, buyerID);
			            	
			            	inserter.executeUpdate();
			            	inserter2.executeUpdate();
			            	inserter3.executeUpdate();
			            	
			            }
			            
			            conn.commit();
			            
			            response.sendRedirect("Purchases.jsp");
		       
		            } catch(SQLException sqle) {
		            	conn.rollback();
		            } catch(NoStockException nse) {
		            	conn.rollback();
		            	session.setAttribute("noStock", "yes");
		            	response.sendRedirect("Cart.jsp");
		            } finally {
		            	conn.setAutoCommit(true);
		            }
		            
				}
				else {
					response.sendRedirect("Cart.jsp");
				}
	            
			}
			
		} catch (SQLException sqle) { 
			Logger lgr = Logger.getLogger(BuyProducts.class.getName()); 
			lgr.log(Level.SEVERE, sqle.getMessage(), ""); 
		} catch (NullPointerException npe) {
			response.sendError(440, "Session expired! Please Log In again.");
		}
		
	}

}