import java.io.IOException;

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

import java.util.List;

import com.grocery.store.StoreItems;

@WebServlet("/displayStore")
public class DisplayStore extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
		doPost(request, response); 
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		if(session == null) {
			response.sendRedirect("SignIn.jsp");
			return;
		}
		
		synchronized(session) {
			int userID = (int)session.getAttribute("id");
			String username = (String)session.getAttribute("user");
			
			int shopkeeperID = Integer.parseInt(request.getParameter("store"));
			List<StoreItems> storeItems = StoreItems.getStoreItems(shopkeeperID);
			
			session.setAttribute("storeSpecific", "yes");
			session.setAttribute("storeItems", storeItems);
			
			response.sendRedirect("Buyer.jsp?user=" + username + "&ID=" + userID);
		}
		
	}
	
}