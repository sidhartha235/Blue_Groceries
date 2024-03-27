<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Purchases | Blue Groceries</title>
		<style>
			body{
				background-image: url("Images/background.jpg");
				background-size: 100vw;
			}
			h1{
				font-size: 50px;
				text-align: center;
			}
			table{
				margin-left: 300px;
				margin-right: 300px;
				background-color: skyblue;
			}
			table, tr, th, td{
				font-size: 25px;
				text-align: center;
				border: 3px solid;
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
		<%@ page import="com.grocery.store.PurchasedItem" %>
		
		<%
			session = request.getSession(false);
			int userID = (int) session.getAttribute("id");
			String username = (String) session.getAttribute("user");
			List<Integer> boughtItems = (List<Integer>) session.getAttribute("cartItems");
		%>
		
		<%@ include file="Header.jsp" %>
		
		<h1>Purchased Items</h1>

	    <table>
	    
	        <tr>
	            <th> Item Name </th>
	            <th> Quantity </th>
	            <th> Cost </th>
	        </tr>
	        
			<%
	            List<PurchasedItem> purchasedItems = PurchasedItem.getPurchasedItems(userID);
	
	            double totalCost = 0;
	            int last = purchasedItems.size() - 1;
	
	            for (int i=last; i>=0; i--) {
	            	PurchasedItem item = purchasedItems.get(i);
	            	
	            	if(boughtItems.contains(item.getItemID())) {
	                	totalCost += item.getCost();
	        %>
	        
			            <tr>
			                <td><%= item.getItemName() %></td>
			                <td><%= item.getQuantity() %></td>
			                <td>&#x20A8; <%= item.getCost() %></td>
			            </tr>
		            
	        <%
	            	}
            		boughtItems.remove((Object)item.getItemID());
	            }
	        %>
	        
	        <tr>
	            <td colspan="2"><b>Total Cost:</b></td>
	            <td>&#x20A8; <%= totalCost %></td>
	        </tr>
	        
	    </table>
	    
	    <%
	    	session.removeAttribute("cartItems");
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
	</script>
</html>