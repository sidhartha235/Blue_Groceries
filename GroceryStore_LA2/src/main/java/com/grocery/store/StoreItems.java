package com.grocery.store;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import java.util.List;
import java.util.ArrayList;

public class StoreItems {
	
	private int itemID;
	private String itemName;
	private String category;
	private double price;
	private String unitQuantiy;
	private int stock;
	private String description;
	private String imgBase64;
	
	private static Properties getConnectionData() {
		
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(StoreItems.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
	
		return props; 
	}
	
	public StoreItems(int itemID, String itemName, String category, double price, String unitQuantity, int stock, String description, String imgBase64) {
		this.itemID = itemID;
		this.itemName = itemName;
		this.category = category;
		this.price = price;
		this.unitQuantiy = unitQuantity;
		this.stock = stock;
		this.description = description;
		this.imgBase64 = imgBase64;
	}
	
	public static List<StoreItems> getStoreItems(int shopkeeperID){
	
		List<StoreItems> storeItems = new ArrayList<StoreItems>();
		
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
			String query = "SELECT ItemID, ItemName, Category, Price, UnitQuantity, Stock, Description, StoreName, TO_BASE64(Image) AS ImgBase64 FROM Item, Shopkeeper WHERE Stock > 0 AND Item.ShopkeeperID = Shopkeeper.ShopkeeperID AND Item.ShopkeeperID = " + shopkeeperID;
			ResultSet rs = st.executeQuery(query);
			
			while(rs.next()) {
				storeItems.add(new StoreItems( rs.getInt("ItemID"),
												  	 rs.getString("ItemName"),
												  	 rs.getString("Category"),
												  	 rs.getDouble("Price"),
												  	 rs.getString("UnitQuantity"),
												  	 rs.getInt("Stock"),
												  	 rs.getString("Description"),
												  	 rs.getString("ImgBase64")
								   					));
			}
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(StoreItems.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		return storeItems;
		
	}
	
	
	public int getItemID() {
		return this.itemID;
	}
	
	public String getItemName() {
		return this.itemName;
	}
	
	public String getItemCategory() {
		return this.category;
	}
	
	public double getItemPrice() {
		return this.price;
	}
	
	public String getItemUnitQuantity() {
		return this.unitQuantiy;
	}
	
	public int getItemStock() {
		return this.stock;
	}
	
	public String getItemDescription() {
		return this.description;
	}
	
	public String getItemImage() {
		return this.imgBase64;
	}

}
