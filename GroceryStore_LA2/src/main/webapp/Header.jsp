<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Header | Blue Groceries</title>
		<style>
			div.header{
				padding: 10px;
				background-color: paleturquoise;
				margin: -5px;
				height: 40px;
			}
			hr{
				border-color: turquoise;
				margin: 0px;
			}
			div.leftHeader{
				text-align: left;
				margin: 0px;
			}
			div.rightHeader{
				text-align: right;
				margin: 0px;
				margin-top: -30px;
				font-size: 25px;
			}
			.search{
				font-size: 25px;
			}
			#search{
				background-color: antiquewhite;
				color: darkslategrey;
				pointer-events: none;
				width: 300px;
			}
			#homepageAnchor, #profileAnchor, #cartAnchor, #signOutAnchor{
				color: black;
				pointer-events: none;
			}
			#amazon{
				height: 30px;
				width: 100px;
			}
			#searchForm{
				margin: 0px;
				display: flex;
				flex-direction: row;
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>
	
	<body>

		<div class="header">
		
		<%
			session = request.getSession(false);
			String role = (String)session.getAttribute("role");
			
			if(role.equals("Buyer")){
		%>
				<div class="leftHeader">
					<form name="searchForm" id="searchForm" method="post" action="search">
						<label class="search" for="search"> Search: </label> &nbsp;
						<input class="search" type="search" name="search" id="search" placeholder="search here..">
					</form>
				</div>
				<div class="rightHeader">
					<a id="homepageAnchor" href="HomePage.jsp"> Home </a> &#x1F3E0; &nbsp; &nbsp; &nbsp;
					<a id="profileAnchor" href="Profile.jsp"> Profile </a> &#x1F464; &nbsp; &nbsp; &nbsp;
					<a id="cartAnchor" href="Cart.jsp"> Cart </a>  &#x1F6D2; &nbsp; &nbsp; &nbsp;
					<a id="signOutAnchor" href="SignOut.jsp"> Sign Out </a>  &#x1F87D; &nbsp; &nbsp; &nbsp;
				</div>
				<hr>
		<%
			}
			else if(role.equals("Shopkeeper")){
		%>
				<div class="leftHeader">
					<label class="search" for="search"> Search: </label> &nbsp;
					<input class="search" type="search" name="search" id="search" placeholder="search here..">
				</div>
				<div class="rightHeader">
					<a id="sendToAmazon" href="SendToAmazon.jsp"> Send To Amazon </a> &nbsp; &nbsp; &nbsp;
					<a id="homepageAnchor" href="HomePage.jsp"> Home </a> &#x1F3E0; &nbsp; &nbsp; &nbsp;
					<a id="profileAnchor" href="Profile.jsp"> Profile </a> &#x1F464; &nbsp; &nbsp; &nbsp;
					<a id="signOutAnchor" href="SignOut.jsp"> Sign Out </a>  &#x1F87D; &nbsp; &nbsp; &nbsp;
				</div>
				<hr>
		<%
			}
			else if(role.equals("Amazon")){
		%>
				<script>
					$(document).ready(function(){
						$(".header").css("background-color", "antiquewhite");
						$(".footer").css("background-color", "antiquewhite");
					});
				</script>
				<div class="leftHeader">
					<img id="amazon" src="Images/amazon.png" alt="Amazon">
				</div>
				<div class="rightHeader">
					<a id="profileAnchor" href="Profile.jsp"> Profile </a> &#x1F464; &nbsp; &nbsp; &nbsp;
					<a id="signOutAnchor" href="SignOut.jsp"> Sign Out </a>  &#x1F87D; &nbsp; &nbsp; &nbsp;
				</div>
				<hr>
		<%	
			}
		%>
				
		</div>

	</body>
</html>