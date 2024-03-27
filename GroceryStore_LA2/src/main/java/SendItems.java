import java.io.FileInputStream; 
import java.io.IOException;
import java.sql.Connection; 
import java.sql.DriverManager; 
import java.sql.PreparedStatement;
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

@WebServlet("/sendToAmazon")
public class SendItems extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	private static Properties getConnectionData() {
	
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(SendItems.class.getName());
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
		
			HttpSession session = request.getSession(false);
			if(session.getAttribute("id") == null || session.getAttribute("user") == null) {
				response.sendRedirect("SignIn.jsp");
				return;
			}
			
			synchronized(session) {
					
				int newStock = Integer.parseInt(request.getParameter("newStock"));
				int itemID = Integer.parseInt(request.getParameter("itemID"));
				String itemName = request.getParameter("itemName");
				String seller = request.getParameter("seller");
				
				String template = "UPDATE Item SET Stock = Stock - ? WHERE ItemID = ?";
				PreparedStatement inserter = conn.prepareStatement(template);
				inserter.setInt(1, newStock);
				inserter.setInt(2, itemID);
				inserter.executeUpdate();
				
				template = "INSERT INTO Amazon VALUES(?, ?, ?)";
				inserter = conn.prepareStatement(template);
				inserter.setString(1, itemName);
				inserter.setInt(2, newStock);
				inserter.setString(3, seller);
				inserter.executeUpdate();
				
				response.sendRedirect("Shopkeeper.jsp");
				
			}
			
		} catch (SQLException sqle) { 
			Logger lgr = Logger.getLogger(SendItems.class.getName()); 
			lgr.log(Level.SEVERE, sqle.getMessage(), ""); 
		}
		
	}

}