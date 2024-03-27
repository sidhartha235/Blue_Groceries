<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Cart | Blue Groceries</title>
		<style>
			body{
				background-image: url("Images/background.jpg");
				background-size: 100vw;
			}
			h1{
				font-size: 50px;
				margin-right: 50px;
				text-align: right;
			}
			form{
				display: flex;
				flex-direction: column;
				align-items: center;
			}
			div.cartItem{
				display: flex;
				flex-direction: row;
				margin: 20px;
				width: 75vw;
				height: 250px;
				box-shadow: 3px 3px 10px 0 skyblue, 3px 3px 10px 0 skyblue inset;
				background: antiquewhite;
			}
			div.cartItem img{
				margin: 25px;
			}
			#oneTop{
				margin: 20px;
				font-size: 30px;
			}
			#one{
				margin: 20px;
				margin-top: 100px;
				font-size: 30px;
			}
			.cartActionButton{
				margin: 20px;
				margin-top: 100px;
				font-size: 30px;
				padding: 10px;
				height: 50px;
				background-color: tomato;
			}
			#buyButton{
				margin: 20px;
				font-size: 30px;
				background-color: skyblue;
			}
			div.buyButton{
				display: flex;
				flex-direction: row;
			}
			#back{
				font-size: 30px;
				text-align: center;
				color: black;
				margin-top: 20px;
				margin-bottom: 10px;
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>

	<body>
	
		<%@ page import="java.util.List" %>
		<%@ page import="com.grocery.store.CartItem" %>
	
		<%
			session = request.getSession(false);
			if(session == null){
				response.sendError(440, "Session expired! Please Log In again.");
			}
			int userID = (int) session.getAttribute("id");
			String username = (String) session.getAttribute("user");
		%>
		
		<%@ include file="Header.jsp" %>
		
		<h1> <%= username %>'s Cart </h1>
		
		<% 
			List<CartItem> cartItems = CartItem.getCartItems(userID);
		%>
		
			<form name="buyForm" id="buyForm" method="post" action="buyProducts">
				<div class="buyButton">
					<p id="oneTop" style="text-align: center;"> Total Items: <%= cartItems.size() %> </p>
					<input type="submit" name="buyButton" id="buyButton" value="Buy">
				</div>
			</form>
		
		<%
			for(CartItem item : cartItems){
		%>
			
				<form name="cartForm" id="cartForm" method="post" action="updateCart">
					
					<div class="cartItem">
					
						<input type="hidden" name="buyerID" id="buyerID" value="<%= item.getBuyerID() %>">
						<input type="hidden" name="shopkeeperID" id="shopkeeperID" value="<%= item.getShopkeeperID() %>">
						<input type="hidden" name="itemID" id="itemID" value="<%= item.getItemID() %>">
						<input type="hidden" name="quantity" id="quantity" value="<%= item.getItemQuantity() %>">
						<img src="data:image/jpg;base64, <%= item.getItemImage() %>" height="200px" width="200px">
						<p id="one"> <b><i> <%= item.getItemName() %> </i></b> </p>
						<p id="one"> <b> <%= item.getItemQuantity() %> &times; <%= item.getCost() %> </b> </p>
						<p id="one"> <%= item.getItemQuantity() %> &times; <%= item.getItemUnitQuantity() %> </p>
						
			            &nbsp; &nbsp; &nbsp;
			            <input type="submit" name="action" value="Decrease" class="cartActionButton">
			            <input type="submit" name="action" value="Increase" class="cartActionButton">
			            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
			            <input type="submit" name="action" value="Delete" class="cartActionButton">
						
					</div>
					
				</form>
		
		<%
			}
		%>
		
		<a id="back" href="Buyer.jsp?user=<%= username %>&ID=<%= userID %>"> Go Back </a>
		
		<%@ include file="Footer.jsp" %>
		
	</body>
	
	<style>
		#signOutAnchor, #homepageAnchor{
			pointer-events: auto;
		}
	</style>
	
	<script>
		$(document).ready(function(){
			$("#homepageAnchor").attr("href", "Buyer.jsp?user=<%= username %>&ID=<%= userID %>");
		});
	
		<% 
			if(session.getAttribute("noStock") != null){
		%>
				alert("Stock unavailable of some item(s) present in the cart!");
		<%
				session.removeAttribute("noStock");
			}
		%>
	</script>
	
</html>