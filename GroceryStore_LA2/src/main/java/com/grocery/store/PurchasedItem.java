package com.grocery.store;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
//import java.sql.Blob;
import java.util.logging.Level;
import java.util.logging.Logger;

import java.util.Properties;
import java.util.List;
import java.util.ArrayList;

public class PurchasedItem {
	
	private int buyerID;
	private int shopkeeperID;
	private int itemID;
	private String itemName;
	private double cost;
	private int quantity;
	private Date orderDate;
	
	public PurchasedItem(int buyerID, int shopkeeperID, int itemID, String itemName, double cost, int quantity, Date orderDate) {
		this.buyerID = buyerID;
		this.shopkeeperID = shopkeeperID;
		this.itemID = itemID;
		this.itemName = itemName;
		this.cost = cost;
		this.quantity = quantity;
		this.orderDate = orderDate;
	}
	
	
	private static Properties getConnectionData() {
		
		Properties props = new Properties();
		
		String filename = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
		
		try(FileInputStream fis = new FileInputStream(filename)){
			props.load(fis);
		} catch(IOException ioe) {
			Logger lgr = Logger.getLogger(PurchasedItem.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
		
		return props;
		
	}
	
	
	public static List<PurchasedItem> getPurchasedItems(int userID){
	
		List<PurchasedItem> purchasedItems = new ArrayList<PurchasedItem>();
		
		Properties props = getConnectionData();
		
		try { 
			Class.forName("com.mysql.cj.jdbc.Driver"); 
		} catch(ClassNotFoundException cnfe) { 
			System.out.println(cnfe); 
		}
		
		String url = props.getProperty("db.url");
		String user = props.getProperty("db.user");
		String password = props.getProperty("db.password");
		
		try(Connection conn = DriverManager.getConnection(url, user, password)) { 
			
			Statement st = conn.createStatement();
			ResultSet rs = st.executeQuery("SELECT BuyerID FROM Buyer WHERE UserID = " + userID);
			rs.next();
			int buyerID = rs.getInt("BuyerID");
			
			String query = "SELECT OrderedItem.ShopkeeperID, OrderedItem.ItemID, ItemName, Quantity, Cost, OrderDate FROM OrderedItem, Item WHERE Item.ItemID = OrderedItem.ItemID AND OrderedItem.BuyerID = " + buyerID;
			rs = st.executeQuery(query);
			
			while(rs.next()) {
				purchasedItems.add(new PurchasedItem( buyerID,
											rs.getInt("ShopkeeperID"),
											rs.getInt("ItemID"),
											rs.getString("ItemName"),
											rs.getDouble("Cost"),
											rs.getInt("Quantity"),
											rs.getDate("OrderDate")
								   		  ));
			}
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(PurchasedItem.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		return purchasedItems;
		
	}
	
	
	public int getBuyerID() {
		return this.buyerID;
	}
	
	public int getShopkeeperID() {
		return this.shopkeeperID;
	}
	
	public int getItemID() {
		return this.itemID;
	}
	
	public String getItemName() {
		return this.itemName;
	}
	
	public double getCost() {
		return this.cost;
	}
	
	public int getQuantity() {
		return this.quantity;
	}
	
	public String getOrderDate() {
		return this.orderDate.toString();
	}
	
}
