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

public class Shopkeeper {
	
	private int shopkeeperID;
	private String storeName;
	
	public Shopkeeper(int shopkeeperID, String storeName) {
		this.shopkeeperID = shopkeeperID;
		this.storeName = storeName;
	}

	private static Properties getConnectionData() {
		
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(Shopkeeper.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
	
		return props; 
	}
	
	
	public static List<Shopkeeper> getStores(){
		
		List<Shopkeeper> shopkeepers = new ArrayList<Shopkeeper>();
		
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
			ResultSet rs = st.executeQuery("SELECT ShopkeeperID, StoreName FROM Shopkeeper");
			
			while(rs.next()) {
				shopkeepers.add(new Shopkeeper(rs.getInt("ShopkeeperID"), rs.getString("StoreName")));
			}
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(Shopkeeper.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		return shopkeepers;
		
	}
	
	
	public int getShopkeeperID() {
		return this.shopkeeperID;
	}
	
	public String getStoreName() {
		return this.storeName;
	}

}
