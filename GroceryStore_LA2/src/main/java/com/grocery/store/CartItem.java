package com.grocery.store;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
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

public class CartItem {
	
	private int buyerID;
	private int shopkeeperID;
	private int itemID;
	private String itemName;
	private double cost;
	private int quantity;
	private String unitQuantity;
	private String imgBase64;
	
	public CartItem(int buyerID, int shopkeeperID, int itemID, String itemName, double cost, int quantity, String unitQuantity, String imgBase64) {
		this.buyerID = buyerID;
		this.shopkeeperID = shopkeeperID;
		this.itemID = itemID;
		this.itemName = itemName;
		this.cost = cost;
		this.quantity = quantity;
		this.unitQuantity = unitQuantity;
		this.imgBase64 = imgBase64;
	}
	
	
	private static Properties getConnectionData() {
		
		Properties props = new Properties();
		
		String filename = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
		
		try(FileInputStream fis = new FileInputStream(filename)){
			props.load(fis);
		} catch(IOException ioe) {
			Logger lgr = Logger.getLogger(CartItem.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
		
		return props;
		
	}
	
	
	public static List<CartItem> getCartItems(int userID){
	
		List<CartItem> cartItems = new ArrayList<CartItem>();
		
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
			
			String query = "SELECT ShopkeeperID, Cart.ItemID, ItemName, Price, Quantity, UnitQuantity, TO_BASE64(Image) AS ImgBase64 FROM Item, Cart WHERE Item.ItemID = Cart.ItemID AND Cart.BuyerID = " + buyerID;
			rs = st.executeQuery(query);
			
			while(rs.next()) {
				cartItems.add(new CartItem( buyerID,
											rs.getInt("ShopkeeperID"),
											rs.getInt("ItemID"),
											rs.getString("ItemName"),
											rs.getDouble("Price"),
											rs.getInt("Quantity"),
											rs.getString("UnitQuantity"),
											rs.getString("ImgBase64")
								   		  ));
			}
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(CartItem.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		// System.out.println(items);
		return cartItems;
		
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
	
	public int getItemQuantity() {
		return this.quantity;
	}
	
	public String getItemUnitQuantity() {
		return this.unitQuantity;
	}
	
	public String getItemImage() {
		return this.imgBase64;
	}
	
}
