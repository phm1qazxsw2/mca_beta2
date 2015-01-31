package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Inventory
{

    private int   	id;
    private int   	pitemId;
    private Date   	orderDate;
    private int   	quantity;
    private int   	totalPrice;
    private int   	traderId;
    private int   	bunitId;


    public Inventory() {}


    public int   	getId   	() { return id; }
    public int   	getPitemId   	() { return pitemId; }
    public Date   	getOrderDate   	() { return orderDate; }
    public int   	getQuantity   	() { return quantity; }
    public int   	getTotalPrice   	() { return totalPrice; }
    public int   	getTraderId   	() { return traderId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setPitemId   	(int pitemId) { this.pitemId = pitemId; }
    public void 	setOrderDate   	(Date orderDate) { this.orderDate = orderDate; }
    public void 	setQuantity   	(int quantity) { this.quantity = quantity; }
    public void 	setTotalPrice   	(int totalPrice) { this.totalPrice = totalPrice; }
    public void 	setTraderId   	(int traderId) { this.traderId = traderId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
