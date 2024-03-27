import java.io.IOException;

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

import java.util.List;

import com.grocery.store.SearchItem;

@WebServlet("/search")
public class Search extends HttpServlet {
	
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
			
			String searchInput = request.getParameter("search");
			List<SearchItem> searchItems = SearchItem.getSearchItems(searchInput);
			
			session.setAttribute("searched", "yes");
			session.setAttribute("searchItems", searchItems);
			
			response.sendRedirect("Buyer.jsp?user=" + username + "&ID=" + userID);
		}
		
	}
	
}