import java.io.IOException;

import javax.servlet.ServletException; 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest; 
import javax.servlet.http.HttpServletResponse;

import com.grocery.store.Image;

import javax.servlet.annotation.WebServlet;

@WebServlet("/fetchImage")
public class FetchImage extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { 
		doPost(request, response); 
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		int itemID = Integer.parseInt(request.getParameter("itemID"));
		
		String image = Image.getImage(itemID);
		
		response.setContentType("text/plain");
		response.getWriter().write(image);
		
		System.out.println("Hello");
		
	}

}