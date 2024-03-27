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
			.shopkeeperOptions{
				margin: 30px;
				text-align: center;
				font-size: 30px;
			}
			#options{
				font-size: 30px;
			}
			.createItem, .updateItems, .produceReport{
				display: none;
				justify-content:center;
			}
			#createItemDiv, #produceReportDiv{
				flex-direction: column;
				max-width: 33vw;
				margin-left: 33vw;
			}
			#updateItemsDiv{
				flex-direction: column;
				align-items: center;
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
			#updateStock{
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
			table{
				margin-left: 300px;
				margin-right: 300px;
				margin-top: 10px;
				background-color: skyblue;
			}
			table, tr, th, td{
				font-size: 25px;
				text-align: center;
				border: 3px solid;
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
		
		<h1> Welcome <%= session.getAttribute("user") %> </h1>
		
		<div class="shopkeeperOptions">
			
			<label for="options"> Select an option: </label>
			<select name="options" id="options" required>
				<option disabled selected value=""> --select-- </option>
				<option id="createItem" value="Create Item"> Create Item </option>
				<option id="updateItems" value="Update Items"> Update Items </option>
				<option id="produceReports" value="Produce Report"> Produce Report </option>
			</select>
			
			<!-- <input type="submit" name="submitOption" id="submitOption" value="Submit"> -->
		
		</div>

		<div class="createItem" id="createItemDiv">
			<form name="shopkeeperForm1" id="shopkeeperForm1" method="post" action="shopkeeperServlet" enctype="multipart/form-data">			
				
				<input type="hidden" name="selectedOption" value="Create Item">
				
				<label for="itemName"> Item Name: </label> <br>
					<input type="text" name="itemName" id="itemName" placeholder="new item" required> <br>
				<label for="itemCategory"> Category: </label> <br>
					<select name="itemCategory" id="itemCategory" required>
						<option disabled selected value=""> --category-- </option>
						<option id="bakery" title="breads, cakes, rolls, ..." value="Bakery"> Bakery </option>
						<option id="dairyAndEggs" title="milk, cheese, yoghurt, eggs, ..." value="Dairy and Eggs"> Dairy and Eggs </option>
						<option id="freshProduce" title="fruits & vegetables" value="Fresh Produce"> Fresh Produce </option>
						<option id="meatAndSeafood" title="meats, fish, ..." value="Meat & Seafood"> Meat and Seafood </option>
						<option id="snacks" title="chips, cholocates, nuts, icecreams, ..." value="Sancks"> Snacks,Chocolates,Icecreams </option>
						<option id="staples" title="cereals, flour, sugar, cooking oil, pulses ..." value="Staples"> Staple Food </option>
						<option id="householdSupplies" title="cleaning products, bath products, ..." value="Household Supplies"> Household Supplies </option>
						<option id="petSupplies" title="pet food, treats, toys, ..." value="Pet Supplies"> Pet Supplies </option>
						<option id="miscellaneous" title="others" value="Miscellaneous"> Miscellaneous </option> 
					</select> <br>
				<label for="itemPrice"> Price (per Unit Quantity): </label>
					<input type="text" name="itemPrice" id="itemPrice" placeholder="(in Rupees)" required> <br>
				<label for="itemUnitQuantity"> Unit Quantity: </label>
					<input type="text" name="itemUnitQuantity" id="itemUnitQuantity" placeholder="weight/count" required> <br>
				<label for="itemStock"> Stock (initial): </label>
					<input type="number" name="itemStock" id="itemStock" placeholder="quantity" min="1" required> <br>
				<label for="itemDescription"> Description: </label>
					<textarea name="itemDescription" id="itemDescription" placeholder="Description of your item here.." rows="3" cols="50" required> </textarea> <br>
				<label for="itemImage"> Upload Image: &nbsp; (Max. Size = 16MB)</label>
					<input type="file" name="itemImage" id="itemImage" accept="image/*" required> <br> <br>
				
					<input type="submit" name="create" id="create" value="Create" style="margin: 10 auto;">
					
					<p id="message"> </p>
				
			</form>
		</div>
		
			
		<div class="updateItems" id="updateItemsDiv">
			<%
				List<Item> items = Item.getItems(userID);
				for(Item item : items) {
			%>
			<form name="shopkeeperForm2" id="shopkeeperForm2" method="post" action="shopkeeperServlet">
				
				<input type="hidden" name="selectedOption" value="Update Items">
				
				<div class="item">
					<img src="data:image/jpg;base64, <%= item.getItemImage() %>" height="200px" width="200px">
					<p id="one"> <i><b> <%= item.getItemName() %> </b></i> - <%= item.getItemCategory() %> </p>
					<p id="one"> <b> <%= item.getItemPrice() %> </b> for <%= item.getItemUnitQuantity() %> </p>
					<p id="two"> Description: <%= item.getItemDescription() %> </p>
					<p id="one"> <strong> Stock <%= item.getItemStock() %> </strong> </p>
					<div class="stylish">
						<input type="hidden" name="itemID" id="itemID" value="<%= item.getItemID() %>">
						<input type="number" name="newStock" id="newStock" min="0">
						<input type="submit" name="updateStock" id="updateStock" value="Update">
					</div>
				</div>
				
			</form>
			<%
				}
			%>
		</div>
			
		
		<div class="produceReport" id="produceReportDiv">
			<form name="shopkeeperForm3" id="shopkeeperForm3" method="post" action="shopkeeperServlet">		
				
				<input type="hidden" name="selectedOption" value="Produce Report">
				
				<label for="buyers">Buyers: </label>
				<select name="buyers" id="buyers">
					<option value="" disabled selected> ---buyer--- </option>
					<%
						List<Buyer> buyersList = Buyer.getBuyersList(userID);
						for(Buyer buyer : buyersList) {
					%>
						<option value="<%= buyer.getBuyerId() %>"> <%= buyer.getBuyerName() %> </option>
					<%
						}
					%>
				</select> <br> <br>
				
				(OR) <br> <br>
				
				<label for="fromDate"> From: </label>
				<input type="date" name="fromDate" id="fromDate">
				
				<label for="toDate"> To: </label>
				<input type="date" name="toDate" id="toDate"> <br> <br> <br>
				
				<input type="submit" name="generate" id="generate" value="Generate">
				
			</form>
			
		</div>
		
		<%
		
			List<ReportData> reportData = (List<ReportData>) session.getAttribute("reportData");
		
			if(reportData != null) {
		
		%>
				<table>
					<tr>
						<th>Item Name</th>
						<th>Quantity</th>
						<th>Cost</th>
						<th>Order Date</th>
					</tr>
		<%
				
				for(ReportData dataItem : reportData) {
		
		%>
					<tr>
						<td> <%= dataItem.getItemName() %> </td>
						<td> <%= dataItem.getQuantity() %> </td>
						<td> <%= dataItem.getCost() %> </td>
						<td> <%= dataItem.getOrderDate() %> </td>
					</tr>
		<%
					
				}
		
		%>
				</table>
		<%
		
			}
			else {
				
				// Nothing is shown..
				
			}
			
			session.removeAttribute("reportData");
		
		%>
		
		
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
	
	<script src="Shopkeeper.js"> </script>
	
</html>