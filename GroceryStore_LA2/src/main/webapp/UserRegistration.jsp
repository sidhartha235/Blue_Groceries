<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>User Registration | Blue Groceries</title>
		<style>
			body{
				background-image: url("Images/signup.jpg");
				background-size: cover;
			}
			h1{
				text-align: center;
				color: orangered;
				font-size: 50px;
				margin-top: 50px;
				margin-bottom: 50px;
			}
			div *{
				font-size: 30px;
				text-align: center;
			}
			input, select{
				background-color: greenyellow;
				color: black;
			}
			div.userForm{
				display: flex;
				flex-direction: row;
				justify-content: center;
				width: 900px;
				margin-left: 25vw;
				margin-bottom: 100px;
			}
			div.leftUserForm, div.rightUserForm{
				margin: 10px;
				padding: 50px;
				font-size: 40px;
			}
			#signUp{
				background-color: gold;
				color: black;
			}
			label{
				color: gold;
			}
			.search{
				color: black; 
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>
	
	<body>
		
		<%@ page import="java.io.FileInputStream" %>
		<%@ page import="java.io.IOException" %>
		<%@ page import="java.io.PrintWriter" %>
		<%@ page import="java.sql.Connection" %>
		<%@ page import="java.sql.DriverManager" %>
		<%@ page import="java.sql.Statement" %>
		<%@ page import="java.sql.PreparedStatement" %>
		<%@ page import="java.sql.ResultSet" %>
		<%@ page import="java.sql.SQLException" %>
		<%@ page import="java.util.Properties" %>
		<%@ page import="java.util.logging.Level" %>
		<%@ page import="java.util.logging.Logger" %>
		
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
				
		<%@ include file="Header.html" %>
	
		<h1> Sign Up </h1>
		
		<form name="userForm" id="userForm" method="post" action="UserRegistration.jsp">
			<div class="userForm">
				<div class="leftUserForm">
					<label for="firstname"> First name: </label> <br>
					<label for="lastname"> Last name: </label> <br>
					<label for="male"> Gender: </label> <br>
					<label for="userType"> User Type: </label> <br>
					<label for="email"> Email: </label> <br>
					<label for="password"> Password: </label> <br>
				</div>
				
				<div class="rightUserForm">
					<input type="text" name="firstname" id="firstname" placeholder="first name" required> <br>
					<input type="text" name="lastname" id="lastname" placeholder="last name" required> <br>
					<input type="radio" name="gender" id="male" value="M" required>
					<label for="male"> Male </label> &nbsp; &nbsp; &nbsp;
					<input type="radio" name="gender" id="female" value="F">
					<label for="female"> Female </label> &nbsp; &nbsp; &nbsp;
					<input type="radio" name="gender" id="other" value="O">
					<label for="other"> Other </label> <br>
					<select name="userType" id="userType" required>
						<option disabled selected value=""> --select-- </option>
						<option id="buyerOption" value="Buyer"> Buyer </option>
						<option id="shopkeeperOption" value="Shopkeeper"> Shopkeeper </option>
					</select> <br>
					<input type="email" name="email" id="email" placeholder="example@mail" required> <br>
					<input type="password" name="password" id="password" placeholder="password" minlength="8" required> <br> <br>
					<input type="submit" name="signUp" id="signUp" value="Sign Up" style="margin: 10 auto; display: block;">
				</div>
			</div>
		</form>
		
		<%@ include file="Footer.html" %>
		
		
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
	        
	        String template = "INSERT INTO User (Firstname, Lastname, Gender, Email, Password, UserType) VALUES (?, ?, ?, ?, ?, ?)";
	        
	        try(Connection conn = DriverManager.getConnection(url, user, password)) {
				
	        	String firstname = request.getParameter("firstname");
	        	String lastname = request.getParameter("lastname");
	        	String gender = request.getParameter("gender");
	        	String email = request.getParameter("email");
	        	String passwod = request.getParameter("password");
	        	String userType = request.getParameter("userType");
	        	
	        	PreparedStatement inserter = conn.prepareStatement(template);
	        	
	        	inserter.setString(1, firstname);
	        	inserter.setString(2, lastname);
	        	inserter.setString(3, gender);
	        	inserter.setString(4, email);
	        	inserter.setString(5, passwod);
	        	inserter.setString(6, userType);
	        	
	        	inserter.executeUpdate();
	        	
	        	out.println("<h2 style='color: orangered;'>You have registered successfully!<h2>");
	        	Thread.sleep(1000);
	        	
	        	Statement st = conn.createStatement();
	        	PreparedStatement selectUser = conn.prepareStatement("SELECT UserID FROM User WHERE Email = ?");
	        	selectUser.setString(1, email);
	        	ResultSet rs = selectUser.executeQuery();

	        	rs.next();
	        	
	        	out.println(userType);
	        	Thread.sleep(3000);
	        	if(userType.equals("Buyer")) {
	        		out.println(userType + "1");
	        		response.sendRedirect("AdditionalBuyerInfo.jsp?user=" + firstname + "&userID=" + rs.getInt("UserID"));
	        	}
	        	else if(userType.equals("Shopkeeper")) {
	        		out.println(userType + "2");
	        		response.sendRedirect("AdditionalShopkeeperInfo.jsp?user=" + firstname + "&userID=" + rs.getInt("UserID"));
	        	}
	        	else {
	        		out.println(userType + "3");
	        		response.sendRedirect("UserRegistration.jsp");
	        	}
	        	
	        } catch(SQLException sqle) {
	        	sqle.printStackTrace();
	        }
		%>
		
	</body>
	
	<script src="">	</script>
</html>