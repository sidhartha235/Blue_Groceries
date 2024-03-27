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

public class Buyer {
	
	private int buyerID;
	private String buyerName;
	
	private static int shopkeeperID;
	
	public Buyer(int buyerID, String buyerName) {
		this.buyerID = buyerID;
		this.buyerName = buyerName;
	}
	

	private static Properties getConnectionData() {
		
		Properties props = new Properties();
	
		String fileName = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
	
		try (FileInputStream fis = new FileInputStream(fileName)) { 
			props.load(fis);
		} catch (IOException ioe) { 
			Logger lgr = Logger.getLogger(Buyer.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
	
		return props; 
	}
	
	
	public static List<Buyer> getBuyersList(int userID){
		
		List<Buyer> buyers = new ArrayList<Buyer>();
		
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
			ResultSet rs = st.executeQuery("SELECT ShopkeeperID FROM Shopkeeper WHERE UserID = " + userID);
			rs.next();
			shopkeeperID = rs.getInt("ShopkeeperID");
			
			String query = "SELECT DISTINCT Buyer.BuyerID, User.Firstname, User.Lastname FROM User, Buyer, OrderedItem WHERE (OrderedItem.ShopkeeperID = " + shopkeeperID + ") AND (OrderedItem.BuyerID = Buyer.BuyerID AND Buyer.UserID = User.UserID)";
			rs = st.executeQuery(query);
			
			while(rs.next()) {
				buyers.add(new Buyer(rs.getInt("BuyerID"), rs.getString("Firstname") + " " + rs.getString("Lastname")));
			}
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(Buyer.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		// System.out.println(buyers);
		return buyers;
		
	}
	
	
	public int getBuyerId() {
		return this.buyerID;
	}
	
	public String getBuyerName() {
		return this.buyerName;
	}

}
