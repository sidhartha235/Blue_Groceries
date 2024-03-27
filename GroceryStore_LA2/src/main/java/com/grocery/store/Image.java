package com.grocery.store;

import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.Properties;
import java.util.List;
import java.util.ArrayList;

public class Image {
	
	private String imageName;
	private String imgBase64;
	
	public Image(String imageName, String imgBase64) {
		this.imageName = imageName;
		this.imgBase64 = imgBase64;
	}
	
	
	private static Properties getConnectionData() {
		
		Properties props = new Properties();
		
		String filename = "/home/sidhartha/eclipse-workspace/GroceryStore_LA2/src/main/java/db.properties";
		
		try(FileInputStream fis = new FileInputStream(filename)){
			props.load(fis);
		} catch(IOException ioe) {
			Logger lgr = Logger.getLogger(Image.class.getName());
			lgr.log(Level.SEVERE, ioe.getMessage(), ioe);
		}
		
		return props;
		
	}

	
	public static String getImage(int itemID){
		
		String image = "";
		
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
			
			String query = "SELECT ItemName, TO_BASE64(Image) AS ImgBase64 FROM Item WHERE ItemID = ?";
			PreparedStatement inserter = conn.prepareStatement(query);
			
			inserter.setInt(1, itemID);
			
			ResultSet rs = inserter.executeQuery();
			rs.next();
			
			image = rs.getString("ImgBase64");
			
		} catch(SQLException sqle) {
			Logger lgr = Logger.getLogger(Image.class.getName());
			lgr.log(Level.SEVERE, sqle.getMessage(), sqle);
		}
		
		return image;
		
	}
	
	
	public String getImageName() {
		return this.imageName;
	}
	
	public String getImage() {
		return this.imgBase64;
	}
	
}