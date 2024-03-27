<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Sign In | Blue Groceries</title>
		<style>
			body{
				background-image: url("Images/signin.jpg");
				background-size: cover;
			}
			h1{
				text-align: center;
				color: orangered;
				font-size: 50px;
				margin-left: -300px;
				margin-top: 100px;
			}
			form{
				text-align: center;
				margin-left: -300px;
			}
			div.SignIn{
				display: flex;
				flex-direction: row;
				justify-content: center;
				margin: 50px;
			}
			div.left, div.right{
				margin: 20px;
				font-size: 30px;
			}
			input{
				font-size: 30px;
				border: 3px solid;
				background-color: greenyellow;
				color: black;
			}
			#signIn{
				background-color: gold;
				color: black;
				margin-bottom: 195px;
			}
			a{
				color: black;
				font-size: 25px;
			}
			/* #username{
				text-transform: lowercase;
			} */
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>
	
	<script>
		showAlert = (message) => {
			alert(message);
		}
	</script>
	
	<body>
	
		<%@ page import="java.io.FileInputStream" %>
		<%@ page import="java.io.IOException" %>
		<%@ page import="java.io.PrintWriter" %>
		<%@ page import="java.sql.Connection" %>
		<%@ page import="java.sql.DriverManager" %>
		<%@ page import="java.sql.Statement" %>
		<%@ page import="java.sql.ResultSet" %>
		<%@ page import="java.sql.SQLException" %>
		<%@ page import="java.util.Properties" %>
		
		<%!
			private static Properties getConnectionData() {
		        
		    	Properties props = new Properties();
	
		        String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		        try (FileInputStream fis = new FileInputStream(fileName)) {
		            props.load(fis);
		        } catch (IOException ioe) {
		            // Logger lgr = Logger.getLogger(ServletQuery.class.getName());
		            // lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		        }
	
		        return props;
		    }
		%>
		
		<%
			Properties props = getConnectionData();
	        
	        // try {
	        	Class.forName("com.mysql.cj.jdbc.Driver");
	        // } catch(ClassNotFoundException cnfe) {
	        //	   System.out.println(cnfe);
	        // }
	
	        String url = props.getProperty("db.url");
	        String user = props.getProperty("db.user");
	        String password = props.getProperty("db.password");
	        
	        String query = "SELECT UserID, Firstname, Email, Password, UserType FROM User";
	        
	        try(Connection conn = DriverManager.getConnection(url, user, password)) {
				
	        	String email = request.getParameter("username");
	        	String passwod = request.getParameter("password");
	        	
	        	Statement st = conn.createStatement();
	        	ResultSet rs = st.executeQuery(query);
	        	boolean userExists = false;
	        	
	        	while(rs.next()) {
	        		if(rs.getString("Email").equals(email) && rs.getString("Password").equals(passwod)) {
	        			userExists = true;
	        			String username = rs.getString("Firstname");
        				int identifier = rs.getInt("UserID");
        				String userType = rs.getString("UserType");
        				
        				session = request.getSession(true);
        				synchronized(session){
        					session.setAttribute("user", username);
        					session.setAttribute("id", identifier);
        					session.setAttribute("role", userType);
        					session.setMaxInactiveInterval(60*60);
        				}
        				
	        			if(rs.getString("UserType").equals("Buyer")) {
		        			response.sendRedirect("Buyer.jsp?user=" + rs.getString("Firstname") + "&ID=" + rs.getInt("UserID"));
		        			break;
	        			}
	        			else if(rs.getString("UserType").equals("Shopkeeper")) {
	        				response.sendRedirect("Shopkeeper.jsp?user=" + rs.getString("Firstname") +"&ID=" + rs.getInt("UserID"));
		        			break;
	        			}
	        			else if(rs.getString("UserType").equals("Amazon")) {
	        				response.sendRedirect("amazon.jsp");
	        				break;
	        			}
	        		}
	        	}
	        	
	        	if(!userExists && email != null && password != null) {
	        		out.println("<script>showAlert('User not found. Please check your credentials!');</script>");
	        	}
	        	
	        } catch(SQLException sqle) {
	        	sqle.printStackTrace();
	        }
		%>

		<%@ include file="Header.html" %>
	
		<h1> DIVE IN TO SHOP &#x1F609;</h1>
		
		<form id="signinForm" method="post" action="SignIn.jsp">
			<div class="SignIn">
				<div class="left">
					<label for="username"> Email: </label> <br> <br>
					<label for="password"> Password: </label>
				</div>
				<div class="right">
					<input type="email" name="username" id="username" required> <br> <br>
					<input type="password" name="password" id="password" minlength="8" required>
				</div>
			</div>
			
			<input type="submit" name="signIn" id="signIn" value="Sign In"> <br>
			
			<a href="index.html"> &#x1F448; Go Back </a> <br> <br>
		</form>
		
		<%@ include file="Footer.html" %>
		
	</body>
	
</html>