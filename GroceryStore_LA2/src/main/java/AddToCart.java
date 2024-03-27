import java.io.FileInputStream; 
import java.io.IOException;
import java.sql.Connection; 
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties; 
import java.util.logging.Level; 
import java.util.logging.Logger;
import java.lang.NullPointerException;

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

@WebServlet("/addToCart")
public class AddToCart extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static Properties getConnectionData() {
	
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(AddToCart.class.getName());
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
			if(session == null) {
				response.sendRedirect("SignIn.jsp");
				return;
			}
			int userID;
			String username;
			synchronized(session) {
				userID = (int)session.getAttribute("id");
				username = (String)session.getAttribute("user");
				
				@SuppressWarnings("unchecked")
				List<Integer> cartItems = (List<Integer>)session.getAttribute("cartItems");
				
				if(cartItems == null) {
					cartItems = new ArrayList<Integer>();
				}
				
				String newItem = request.getParameter("itemID");
//				System.out.println(newItem);
				int quantity = Integer.parseInt(request.getParameter("quantity"));
//				System.out.println(quantity);
				
				if(newItem != null && !newItem.trim().equals("")) {
					int newItemID = Integer.parseInt(newItem);
					
					boolean itemExists = false;
					for(int i = 0; i < cartItems.size(); i++) {
						if(cartItems.get(i) == newItemID) {
							cartItems.set(i, newItemID);
							itemExists = true;
							break;
						}
					}
					
					if(!itemExists) {
						cartItems.add(newItemID);						
						String template = "SELECT BuyerID FROM Buyer WHERE UserID = ?";
						PreparedStatement inserter = conn.prepareStatement(template);
						
						inserter.setInt(1, userID);
						
						ResultSet rs = inserter.executeQuery();
						rs.next();
						int buyerID = rs.getInt("BuyerID");
						
						template = "INSERT INTO Cart (BuyerID, ItemID, Quantity) VALUES (?, ?, ?)";
						inserter = conn.prepareStatement(template);
						
						inserter.setInt(1, buyerID);
						inserter.setInt(2, newItemID);
						inserter.setInt(3, quantity);
						
						inserter.executeUpdate();
					}
					else if(itemExists) {
						String template = "SELECT BuyerID FROM Buyer WHERE UserID = ?";
						PreparedStatement inserter = conn.prepareStatement(template);
						
						inserter.setInt(1, userID);
						
						ResultSet rs = inserter.executeQuery();
						rs.next();
						int buyerID = rs.getInt("BuyerID");
						
						template = "SELECT Quantity FROM Cart WHERE ItemID = ? AND BuyerID = ?";
						inserter = conn.prepareStatement(template);
						
						inserter.setInt(1, newItemID);
						inserter.setInt(2, buyerID);
						
						rs = inserter.executeQuery();
						rs.next();
						int oldQuantity = rs.getInt("Quantity");
						
						template = "UPDATE Cart SET Quantity = ? WHERE ItemID = ? AND BuyerID = ?";
						inserter = conn.prepareStatement(template);
						
						inserter.setInt(1, oldQuantity + quantity);
						inserter.setInt(2, newItemID);
						inserter.setInt(3, buyerID);
						
						inserter.executeUpdate();
					}
					
					session.setAttribute("cartItems", cartItems);
					
				}
				
				session.setAttribute("cartItems", cartItems);
				
//				if(result > 0) {
//					out.println("<h1> Item added to cart </h1>");
//				}
//				else {
//					out.println("<h1> Error: Item is not added to the cart! </h1>");
//				}
				
				response.sendRedirect("Buyer.jsp?user=" + username + "&ID=" + userID);
				
			}
			
		} catch (SQLException sqle) { 
			Logger lgr = Logger.getLogger(AddToCart.class.getName()); 
			lgr.log(Level.SEVERE, sqle.getMessage(), ""); 
		} catch (NullPointerException npe) {
			response.sendError(440, "Session expired! Please Log In again.");
		}
		
	}

}