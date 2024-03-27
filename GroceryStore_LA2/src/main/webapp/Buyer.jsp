<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Buyer | Blue Groceries</title>
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
			form{
				display: flex;
				flex-direction: column;
				align-items: center;
			}
			div.displayItems *, div.selectShop *{
				font-size: 30px;
				margin: 5px;
				margin-bottom: 20px;
			}
			#displayCount{
				width: 100px;
			}
			#changeDisplay, #displayStoreItems{
				background-color: tomato;
			}
			div.availableItem{
				display: flex;
				flex-direction: row;
				margin: 20px;
				width: 75vw;
				height: 250px;
				box-shadow: 3px 3px 10px 0 skyblue, 3px 3px 10px 0 skyblue inset;
				background: antiquewhite;
			}
			div.availableItem img{
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
			#addToCartButton{
				margin: 20px;
				font-size: 30px;
				padding: 10px;
				height: 50px;
				background-color: tomato;
			}
			#quantity{
				margin: 20px;
				margin-top: 50px;
				font-size: 30px;
				height: 40px;
				width: 150px;
				background-color: tomato;
			}
			a, span{
				font-size: 25px;
				color: black;
			}
			div.navigatePages{
				text-align: center;
			}
		</style>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"> </script>
	</head>
	
	<body>
		
		<%@ page import="java.util.List" %>
		<%@ page import="java.lang.NullPointerException" %>
		<%@ page import="com.grocery.store.ItemToBuy" %>
		<%@ page import="com.grocery.store.Shopkeeper" %>
		<%@ page import="com.grocery.store.StoreItems" %>
		<%@ page import="com.grocery.store.SearchItem" %>
		
		<% 
			session = request.getSession(false);
			if(session == null){
				response.sendError(440, "Session expired! Please Log In again.");
			}
			int userID = (int) session.getAttribute("id");
			String username = (String) session.getAttribute("user");
		%>
		
		<%@ include file="Header.jsp" %>
		
		<h1> Welcome <%= session.getAttribute("user") %> </h1>
		
		<input type="hidden" id="user" value="<%= request.getParameter("user") %>">
    	<input type="hidden" id="ID" value="<%= request.getParameter("ID") %>">
		
		<form name="selectStore" id="selectStore" method="post" action="displayStore">
		
			<div class="selectShop">
				<label for="store"> Store: </label>
				<select name="store" id="store">
					<option selected disabled value=""> -choose store- </option>
					<%
						List<Shopkeeper> stores = Shopkeeper.getStores();
						for(Shopkeeper store : stores){
					%>
							<option value="<%= store.getShopkeeperID() %>"> <%= store.getStoreName() %> </option>
					<%
						}
					%>
				</select>
				<input type="submit" name="displayStoreItems" id="displayStoreItems" value="Get">
			</div>
		
		</form> <br>
		
		<form name="buyerForm" id="buyerForm" method="post" action="Buyer.jsp?user=<%= request.getParameter("user") %>&ID=<%= Integer.parseInt(request.getParameter("ID")) %>&page=1&displayCount=<%= (request.getParameter("displayCount") == null) ? 10 : Integer.parseInt(request.getParameter("displayCount")) %>">
			
			<div class="displayItems">
				<label for="displayCount"> Display(no. of items): </label>
				<input type="number" name="displayCount" id="displayCount" min="1">
				<input type="submit" name="changeDisplay" id="changeDisplay" value="Show">
			</div>
			
		</form> <br>
			
			
		<%	
		if(session.getAttribute("searched") != null && session.getAttribute("searched").equals("yes")){
			
			List<SearchItem> searchItems = (List<SearchItem>)session.getAttribute("searchItems");
			for(SearchItem searchItem : searchItems){
		%>
				<form name="searchItemForm" id="searchItemForm" method="post" action="addToCart">
					<div class="availableItem">
						<img class="image" name="<%= searchItem.getItemID() %>" alt="<%= searchItem.getItemName() %>" src="" height="200px" width="200px">
						<p id="one"> <b><i> <%= searchItem.getItemName() %> </i></b> - <%= searchItem.getItemCategory() %> </p>
						<p id="one"> <b> <%= searchItem.getItemPrice() %> </b> for <%= searchItem.getItemUnitQuantity() %> </p>
						<p id="one"> Available Stock : <b> <%= searchItem.getItemStock() %> </b> </p>
						<p id="two"> Description: <%= searchItem.getItemDescription() %> </p>
						<p id="one"> Seller: <b> <%= searchItem.getSeller() %> </b> </p>
						<div class="stylish">
							<input type="hidden" name="itemID" id="itemID" value="<%=searchItem.getItemID()%>">
							<input type="number" name="quantity" id="quantity" placeholder="quantity" min="1" max="<%= searchItem.getItemStock() %>">
							<input type="submit" name="addToCartButton" id="addToCartButton" value="Add to Cart">
						</div>
					</div>
				</form>
		<%
			}
			
			session.removeAttribute("searched");
			
			if(searchItems.size() == 0) {
		%>
				<h2 style="text-align: center"> No items with given input! </h2>	
		<%	
			}
			
		}	
		else if(session.getAttribute("storeSpecific") != null && session.getAttribute("storeSpecific").equals("yes")){
			
			List<StoreItems> storeItems = (List<StoreItems>)session.getAttribute("storeItems");
			for(StoreItems storeItem : storeItems){
		%>
				<form name="storeItemForm" id="storeItemForm" method="post" action="addToCart">
					<div class="availableItem">
						<img src="data:image/jpg;base64, <%= storeItem.getItemImage() %>" height="200px" width="200px">
						<p id="one"> <b><i> <%= storeItem.getItemName() %> </i></b> - <%= storeItem.getItemCategory() %> </p>
						<p id="one"> <b> <%= storeItem.getItemPrice() %> </b> for <%= storeItem.getItemUnitQuantity() %> </p>
						<p id="one"> Available Stock : <b> <%= storeItem.getItemStock() %> </b> </p>
						<p id="two"> Description: <%= storeItem.getItemDescription() %> </p>
						<div class="stylish">
							<input type="hidden" name="itemID" id="itemID" value="<%=storeItem.getItemID()%>">
							<input type="number" name="quantity" id="quantity" placeholder="quantity" min="1" max="<%= storeItem.getItemStock() %>">
							<input type="submit" name="addToCartButton" id="addToCartButton" value="Add to Cart">
						</div>
					</div>
				</form>
		<%
			}
			
			session.removeAttribute("storeSpecific");
			
			if(storeItems.size() == 0) {
		%>
				<h2 style="text-align: center"> No items available to buy from this Store! </h2>	
		<%	
			}
			
		}
		else {
		
			int itemsPerPage = (request.getParameter("displayCount") == null) ? 10 : Integer.parseInt(request.getParameter("displayCount"));
			List<ItemToBuy> availableItems = ItemToBuy.getAvailableItems();
			
			int currentPage = (request.getParameter("page") == null) ? 1 : Integer.parseInt(request.getParameter("page"));
			
			if(availableItems != null){
				int totalItems = availableItems.size();
				int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
		%>
		
		<div class="navigatePages">
			<% 
				if(currentPage > 1) {
			%>
					<a href="Buyer.jsp?user=<%= request.getParameter("user") %>&ID=<%= Integer.parseInt(request.getParameter("ID")) %>&page=<%= currentPage - 1 %>&displayCount=<%= itemsPerPage %>">Previous Page</a> &nbsp; &nbsp;
			<%
				}
			
				for(int i = 1; i <= totalPages; i++) {
					if(i == currentPage){
			%>
						<span> &nbsp; <%= i %> &nbsp; </span>
			<%
						break;
					}
				}
			
				if(currentPage < totalPages) {
			%>
					&nbsp; &nbsp; <a href="Buyer.jsp?user=<%= request.getParameter("user") %>&ID=<%= Integer.parseInt(request.getParameter("ID")) %>&page=<%= currentPage + 1 %>&displayCount=<%= itemsPerPage %>"> Next Page </a>
			<%
				}
			%>
		</div>
		
		<%
				int start = (currentPage - 1) * itemsPerPage;
				int end = Math.min(start + itemsPerPage, totalItems);
				
				for(int i = start; i < end; i++) {
					ItemToBuy item = availableItems.get(i);
		%>
					<form name="itemForm" id="itemForm" method="post" action="addToCart">
						<div class="availableItem">
							<img src="data:image/jpg;base64, <%= item.getItemImage() %>" height="200px" width="200px">
							<p id="one"> <b><i> <%= item.getItemName() %> </i></b> - <%= item.getItemCategory() %> </p>
							<p id="one"> <b> <%= item.getItemPrice() %> </b> for <%= item.getItemUnitQuantity() %> </p>
							<p id="one"> Available Stock : <b> <%= item.getItemStock() %> </b> </p>
							<p id="two"> Description: <%= item.getItemDescription() %> </p>
							<p id="one"> Seller: <b> <%= item.getSeller() %> </b> </p>
							<div class="stylish">
								<input type="hidden" name="itemID" id="itemID" value="<%=item.getItemID()%>">
								<input type="number" name="quantity" id="quantity" placeholder="quantity" min="1" max="<%= item.getItemStock() %>">
								<input type="submit" name="addToCartButton" id="addToCartButton" value="Add to Cart">
							</div>
						</div>
					</form>
		<%
				}
			}
			else{
		%>
				<h2 style="text-align: center"> No items available to buy! </h2>
		<%
			}
			
		}
		%>
		
		<%@ include file="Footer.jsp" %>
		
	</body>
	
	<script>
		$(document).ready(function(){
			$("#homepageAnchor").attr("href", "Buyer.jsp?user=<%= username %>&ID=<%= userID %>");
		});
	</script>
	
	<style>
		#homepageAnchor, #cartAnchor, #signOutAnchor, #search{
			pointer-events: auto;
		}
	</style>
	
	<script src="Buyer.js"> </script>
	
</html>