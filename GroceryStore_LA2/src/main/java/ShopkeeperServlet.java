import java.io.FileInputStream; 
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties; 
import java.util.logging.Level; 
import java.util.logging.Logger;

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import com.grocery.store.ReportData;

@WebServlet("/shopkeeperServlet")
@MultipartConfig(maxFileSize = 16177216)
public class ShopkeeperServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static Properties getConnectionData() {
	
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(ShopkeeperServlet.class.getName());
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
		
//		PrintWriter out = response.getWriter();
		
		try (Connection conn = DriverManager.getConnection(url, user, password);) {
		
			HttpSession session = request.getSession(false);
			if(session.getAttribute("id") == null || session.getAttribute("user") == null) {
				response.sendRedirect("SignIn.jsp");
				return;
			}
			
			int userID;
			String username;
			synchronized(session) {
				userID = (int)session.getAttribute("id");
				username = (String)session.getAttribute("user");		
				PreparedStatement inserter = conn.prepareStatement("SELECT ShopkeeperID FROM Shopkeeper WHERE UserID = ?");
				inserter.setInt(1, userID);
				ResultSet rs = inserter.executeQuery();
				rs.next();
	
				int shopkeeperID = rs.getInt("ShopkeeperID");
				
				String selectedOption = request.getParameter("selectedOption");
				
				if(selectedOption.equals("Create Item")) {

					String itemName = request.getParameter("itemName");
					String category = request.getParameter("itemCategory");
					double price = Double.parseDouble(request.getParameter("itemPrice"));
					String unitQuantity = request.getParameter("itemUnitQuantity");
					int stock = Integer.parseInt(request.getParameter("itemStock"));
					String description = request.getParameter("itemDescription");
					Part image = request.getPart("itemImage");
					
					String template1 = "INSERT INTO Item (ItemName, ShopkeeperID, Category, Price, UnitQuantity, Stock, Description, Image) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
					PreparedStatement inserter1 = conn.prepareStatement(template1);
					
					inserter1.setString(1, itemName);
					inserter1.setInt(2, shopkeeperID);
					inserter1.setString(3, category);
					inserter1.setDouble(4, price);
					inserter1.setString(5, unitQuantity);
					inserter1.setInt(6, stock);
					inserter1.setString(7, description);
					InputStream is = image.getInputStream();
					inserter1.setBlob(8, is);
					
					inserter1.executeUpdate();
					
//					if(result > 0) {
//						out.println("<script> document.getElementById('message').innerHTML = 'Item created successfully!' </script>");
//					}
//					else {
//						out.println("<script> document.getElementById('message').innerHTML = 'Item is not created due to some error!!' </script>");
//					}
					
				}
				else if(selectedOption.equals("Update Items")) {
					
					int newStock = Integer.parseInt(request.getParameter("newStock"));
					int itemID = Integer.parseInt(request.getParameter("itemID"));
					
					String template2 = "UPDATE Item SET Stock = ? WHERE ItemID = ?";
					PreparedStatement inserter2 = conn.prepareStatement(template2);
					
					inserter2.setInt(1, newStock);
					inserter2.setInt(2, itemID);
					
					inserter2.executeUpdate();
					
				}
				else if(selectedOption.equals("Produce Report")) {
					
					List<ReportData> reportData = new ArrayList<>();

					if(request.getParameter("buyers") != null) {
						
						int buyerID = Integer.parseInt(request.getParameter("buyers"));
						
						String template3 = "SELECT Item.ItemName, OrderedItem.Quantity, OrderedItem.Cost, OrderedItem.OrderDate FROM Item, OrderedItem WHERE Item.ItemID = OrderedItem.ItemID AND OrderedItem.BuyerID = ? AND OrderedItem.ShopkeeperID = ?";
						PreparedStatement inserter3 = conn.prepareStatement(template3);
						
						inserter3.setInt(1, buyerID);
						inserter3.setInt(2, shopkeeperID);
						
						rs = inserter3.executeQuery();
						
						
						while(rs.next()) {
							ReportData reportDataItem = new ReportData();
						    reportDataItem.setItemName(rs.getString("ItemName"));
						    reportDataItem.setQuantity(rs.getInt("Quantity"));
						    reportDataItem.setCost(rs.getDouble("Cost"));
						    reportDataItem.setOrderDate(rs.getDate("OrderDate"));
						    
						    reportData.add(reportDataItem);
						}
						
					}
					else {
						
						Date fromDate = java.sql.Date.valueOf(request.getParameter("fromDate"));
						Date toDate = java.sql.Date.valueOf(request.getParameter("toDate"));
						
						String template3 = "SELECT Item.ItemName, OrderedItem.Quantity, OrderedItem.Cost, OrderedItem.OrderDate FROM Item, OrderedItem WHERE Item.ItemID = OrderedItem.ItemID AND OrderedItem.ShopkeeperID = ? AND OrderedItem.OrderDate >= ? AND OrderedItem.OrderDate <= ?";
						PreparedStatement inserter3 = conn.prepareStatement(template3);
						
						inserter3.setInt(1, shopkeeperID);
						inserter3.setDate(2, fromDate);
						inserter3.setDate(3, toDate);
						
						rs = inserter3.executeQuery();
						
						while(rs.next()) {
							ReportData reportDataItem = new ReportData();
						    reportDataItem.setItemName(rs.getString("ItemName"));
						    reportDataItem.setQuantity(rs.getInt("Quantity"));
						    reportDataItem.setCost(rs.getDouble("Cost"));
						    reportDataItem.setOrderDate(rs.getDate("OrderDate"));
						    
						    reportData.add(reportDataItem);
						}
						
					}
					
					session.setAttribute("reportData", reportData);
					
				}
				
				response.sendRedirect("Shopkeeper.jsp?user=" + username + "&ID=" + userID);
				
			}
			
		} catch (SQLException sqle) { 
			Logger lgr = Logger.getLogger(ShopkeeperServlet.class.getName()); 
			lgr.log(Level.SEVERE, sqle.getMessage(), ""); 
		} 
//		catch (NullPointerException npe) {
//			response.sendError(440, "Session expired! Please Log In again.");
//		}
		
	}

}