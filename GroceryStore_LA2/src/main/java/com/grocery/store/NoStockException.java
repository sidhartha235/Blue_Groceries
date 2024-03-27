package com.grocery.store;

public class NoStockException extends Exception {
	
	private static final long serialVersionUID = 1L;

	@Override
	public String toString() {
		return "Some item(s) are more than available stock!";
	}
	
}
