import java.io.FileInputStream; 
import java.io.IOException;
import java.sql.Connection; 
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
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

@WebServlet("/updateCart")
public class UpdateCart extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static Properties getConnectionData() {
	
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(UpdateCart.class.getName());
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
//				int userID = (int)session.getAttribute("id");
//				String username = (String)session.getAttribute("user");
				
				int buyerID = Integer.parseInt(request.getParameter("buyerID"));
				int itemID = Integer.parseInt(request.getParameter("itemID"));
				int quantity = Integer.parseInt(request.getParameter("quantity"));
				
				String template = "UPDATE Cart SET Quantity = ? WHERE BuyerID = ? AND ItemID = ?";
				PreparedStatement inserter = conn.prepareStatement(template);
				
				inserter.setInt(2, buyerID);
				inserter.setInt(3, itemID);
				
				String clickedButton = request.getParameter("action");
				
				if(clickedButton.equals("Decrease")) {
					if(quantity > 1) {
						inserter.setInt(1, quantity - 1);
						inserter.executeUpdate();
					}
				}
				else if(clickedButton.equals("Increase")) {
					inserter.setInt(1, quantity + 1);
					inserter.executeUpdate();
				}
				else if(clickedButton.equals("Delete")) {
					template = "DELETE FROM Cart WHERE BuyerID = ? AND ItemID = ?";
					inserter = conn.prepareStatement(template);
					
					inserter.setInt(1, buyerID);
					inserter.setInt(2, itemID);
					
					inserter.executeUpdate();
					
					@SuppressWarnings("unchecked")
					List<Integer> cartItems = (List<Integer>)session.getAttribute("cartItems"); ///////////////
					
					for(int i = 0; i < cartItems.size(); i++) {
						if(cartItems.get(i) == itemID) {
							cartItems.remove(i);
							break;
						}
					}
				}
				
				response.sendRedirect("Cart.jsp");
			}
			
		} catch (SQLException sqle) { 
			Logger lgr = Logger.getLogger(UpdateCart.class.getName()); 
			lgr.log(Level.SEVERE, sqle.getMessage(), ""); 
		} catch (NullPointerException npe) {
			response.sendError(440, "Session expired! Please Log In again.");
		}
		
	}

}