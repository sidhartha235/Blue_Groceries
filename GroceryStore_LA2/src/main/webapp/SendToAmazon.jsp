<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Shopkeeper | Blue Groceries</title>
		<style>
			body{
				background-image: url("Images/background.jpg");
				background-size: 100vw;
			}
			h1{
				font-size: 50px;
				text-align: right;
				margin-right: 100px;
			}
			form *{
				font-size: 30px;
			}
			.sendToAmazon{
				justify-content:center;
				display: flex;
				flex-direction: column;
				margin-left: 10vw;
			}
			.item{
				display: flex;
				flex-direction: row;
				margin: 20px;
				width: 75vw;
				height: 250px;
				box-shadow: 3px 3px 10px 0 skyblue, 3px 3px 10px 0 skyblue inset;
				background: antiquewhite;
			}
			.item img{
				margin: 25px;
			}
			#one{
				margin: 20px;
				margin-top: 50px;
				font-size: 30px;
			}
			#two{
				margin: 20px;
				margin-top: 50px;
				font-size: 20px;
			}
			#sendStock{
				margin: 20px;
				font-size: 30px;
				padding: 10px;
				height: 50px;
				background-color: tomato;
			}
			#newStock{
				margin: 20px;
				margin-top: 50px;
				font-size: 30px;
				height: 40px;
				width: 150px;
				background-color: tomato;
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>

	<body>
	
		<%@ page import="java.util.List" %>
		<%@ page import="java.lang.NullPointerException" %>
		<%@ page import="com.grocery.store.Buyer" %>
		<%@ page import="com.grocery.store.Item" %>
		<%@ page import="com.grocery.store.ReportData" %>
	
		<% 
			session = request.getSession(false);
			if(session == null){
				response.sendError(440, "Session expired! Please Log In again.");
			}
			int userID = (int) session.getAttribute("id");
			String username = (String) session.getAttribute("user");
		%>
		
		<%@ include file="Header.jsp" %>
		
		<h1> Hello <%= session.getAttribute("user") %> </h1>
		
		<div class="sendToAmazon" id="send">
		
			<%
				List<Item> items = Item.getItems(userID);
				for(Item item : items) {
			%>
			<form name="sendToAmazon" id="sendToAmazon" method="post" action="sendToAmazon">
				
				<div class="item">
					<img src="data:image/jpg;base64, <%= item.getItemImage() %>" height="200px" width="200px">
					<p id="one"> <i><b> <%= item.getItemName() %> </b></i> - <%= item.getItemCategory() %> </p>
					<p id="one"> <b> <%= item.getItemPrice() %> </b> for <%= item.getItemUnitQuantity() %> </p>
					<p id="two"> Description: <%= item.getItemDescription() %> </p>
					<p id="one"> <strong> Stock <%= item.getItemStock() %> </strong> </p>
					<div class="stylish">
						<input type="hidden" name="itemID" id="itemID" value="<%= item.getItemID() %>">
						<input type="hidden" name="itemName" id="itemName" value="<%= item.getItemName() %>">
						<input type="hidden" name="seller" id="seller" value="<%= item.getSeller() %>">
						<input type="number" name="newStock" id="newStock" min="0" max="<%= item.getItemStock() %>">
						<input type="submit" name="sendStock" id="sendStock" value="Send">
					</div>
				</div>
				
			</form>
			<%
				}
			%>
			
		</div>
		
		<%@ include file="Footer.jsp" %>
		
	</body>
	
	<script>
		$(document).ready(function(){
			$("#homepageAnchor").attr("href", "Shopkeeper.jsp");
		});
	</script>
	
	<style>
		#homepageAnchor, #signOutAnchor{
			pointer-events: auto;
		}
	</style>
	
</html>