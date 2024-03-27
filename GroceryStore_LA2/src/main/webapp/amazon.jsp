<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Amazon Server</title>
		<style>
			body{
				background-image: url("Images/amazonfresh0.jpg");
				background-size: cover;
			}
			h1{
				font-size: 50px;
				text-align: right;
				margin-right: 60px;
				color: antiquewhite;
				text-shadow: 0px 0px 10px red;
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>
	
	<body>
		
		<%@ page import="java.util.List" %>
		<%@ page import="java.lang.NullPointerException" %>
		<%@ page import="com.grocery.store.ItemToBuy" %>
		
		<% 
			try {
				session = request.getSession(false);
				String username = (String)session.getAttribute("user");
				int id = (int)session.getAttribute("id");
			} catch(NullPointerException npe){
				response.sendError(440, "Session expired! Please Log In again.");
			}
		%>
		
		<%@ include file="Header.jsp" %>
		
		<h1> Welcome <%= session.getAttribute("user") %> </h1>
		
		
		
		<%@ include file="Footer.jsp" %>
		
	</body>
	
	<style>
		#signOutAnchor{
			pointer-events: auto;
		}
	</style>
	
	<script src=""> </script>

</html>