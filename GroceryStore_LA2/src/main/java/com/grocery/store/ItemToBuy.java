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

public class ItemToBuy {
	
	private int itemID;
	private String itemName;
	private String category;
	private double price;
	private String unitQuantiy;
	private int stock;
	private String description;
	private String imgBase64;
	private String seller;
	
	public ItemToBuy(int itemID, String itemName, String category, double price, String unitQuantity, int stock, String description, String seller, String imgBase64) throws SQLException {
		this.itemID = itemID;
		this.itemName = itemName;
		this.category = category;
		this.price = price;
		this.unitQuantiy = unitQuantity;
		this.stock = stock;
		this.description = description;
		this.seller = seller;
		this.imgBase64 = imgBase64;
	}
	
	
	private static Properties getConnectionData() {
		
		Properties props = new Properties();
		
		String filename = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
		
		try(FileInputStream fis = new FileInputStream(filename)){
			props.load(fis);
		} catch(IOException ioe) {
			Logger lgr = Logger.getLogger(ItemToBuy.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
		
		return props;
		
	}
	
	
	public static List<ItemToBuy> getAvailableItems(){
	
		List<ItemToBuy> availableItems = new ArrayList<ItemToBuy>();
		
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
			String query = "SELECT ItemID, ItemName, Category, Price, UnitQuantity, Stock, Description, StoreName, TO_BASE64(Image) AS ImgBase64 FROM Item, Shopkeeper WHERE Stock > 0 AND Item.ShopkeeperID = Shopkeeper.ShopkeeperID";
			ResultSet rs = st.executeQuery(query);
			
			while(rs.next()) {
				availableItems.add(new ItemToBuy( rs.getInt("ItemID"),
												  rs.getString("ItemName"),
												  rs.getString("Category"),
												  rs.getDouble("Price"),
												  rs.getString("UnitQuantity"),
												  rs.getInt("Stock"),
												  rs.getString("Description"),
												  rs.getString("StoreName"),
												  rs.getString("ImgBase64")
								   				));
			}
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(ItemToBuy.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		// System.out.println(items);
		return availableItems;
		
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
	
	public String getSeller() {
		return this.seller;	
	}
	
}