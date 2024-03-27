<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
	<html>
	<head>
		<meta charset="UTF-8">
		<title>Sign Out</title>
		<style>
			body{
				background: skyblue;
			}
			h1{
				text-align: center;
				margin-top: 300px;
			}
			p{
				font-size: 20px;
				text-align: center;
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>

	<body>
		<%
		    session = request.getSession(false);
		    session.invalidate();
		%>
		
		<h1>You have been successfully logged out.</h1>
		
		<p> Click here to <a href="SignIn.jsp"> Sign In </a> again. </p>
	</body>
</html>