<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Buyer Info | Blue Groceries</title>
		<style>
			body{
				background-image: url("Images/signup.jpg");
				background-size: cover;
			}
			h1, h2{
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
			div.buyerForm{
				display: flex;
				flex-direction: row;
				justify-content: center;
				width: 900px;
				margin-left: 25vw;
				margin-bottom: 150px;
			}
			div.leftBuyerForm, div.rightBuyerForm{
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
	
		<h2> Fill the following to complete the registration process: </h2>
		
		<form name="buyerForm" id="buyerForm" method="post" action="AdditionalBuyerInfo.jsp">
			<div class="buyerForm">
				<input type="hidden" name="userID" value="<%= request.getParameter("userID") %>">
				<div class="leftBuyerForm">
					<label for="mobile"> Mobile: </label> <br>
					<label for="street"> Street: </label> <br>
					<label for="city"> City: </label> <br>
					<label for="state"> State: </label> <br>
					<label for="pincode"> Pin Code: </label> <br>
				</div>
				
				<div class="rightBuyerForm">
					<input type="text" name="mobile" id="mobile" placeholder="contact number" minlength="10" maxlength="10" required> <br>
					<input type="text" name="street" id="street" placeholder="h.no., street" required> <br>
					<input type="text" name="city" id="city" placeholder="city" required> <br>
					<input type="text" name="state" id="state" placeholder="state" required> <br>
					<input type="text" name="pincode" id="pincode" placeholder="pin code" minlength="6" maxlength="6" required> <br> <br>
					
					<input type="submit" name="signUp" id="signUp" value="Submit" style="margin: 10 auto; display: block;">
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
	        
	        String template = "INSERT INTO Buyer (UserID, Mobile, Street, City, State, Pincode) VALUES (?, ?, ?, ?, ?, ?)";
	        
	        try(Connection conn = DriverManager.getConnection(url, user, password)) {
				
	        	int userID = Integer.parseInt(request.getParameter("userID"));
	        	String mobile = request.getParameter("mobile");
	        	String street = request.getParameter("street");
	        	String city = request.getParameter("city");
	        	String state = request.getParameter("state");
	        	String pincode = request.getParameter("pincode");
	        	
	        	PreparedStatement inserter = conn.prepareStatement(template);
	        	
	        	inserter.setInt(1, userID);
	        	inserter.setString(2, mobile);
	        	inserter.setString(3, street);
	        	inserter.setString(4, city);
	        	inserter.setString(5, state);
	        	inserter.setString(6, pincode);
	        	
	        	inserter.executeUpdate();
	        	
	        	out.println("<h2>You have registered successfully! Log in to shop with us.<h2>");
	        	out.println("<h2>You will be redirected in a few seconds...");
	        	Thread.sleep(5000);
	        	
	        	Statement st = conn.createStatement();
	        	ResultSet rs = st.executeQuery("SELECT * FROM User WHERE UserID = " + userID);
	        	rs.next();
	        	
	        	if((rs.getString("UserType")).equals("Buyer")) {
	        		response.sendRedirect("SignIn.jsp"/* ?user=" + rs.getString("Firstname") + "&ID=" + rs.getInt("UserID") */);
	        	}
	        	else {
	        		response.sendRedirect("UserRegistration.jsp");
	        		// out.println("<h1>" + rs1.getString("UserType") + "</h1>");
	        	}
	        	
	        } catch(SQLException sqle) {
	        	sqle.printStackTrace();
	        }
		%>
		
	</body>
	
	<script src="AdditionalBuyerInfo.js"> </script>
</html>