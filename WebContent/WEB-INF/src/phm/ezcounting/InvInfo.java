package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class InvInfo
{

    private int   	quantity;
    private int   	cost;
    private int   	pitemId;


    public InvInfo() {}


    public int   	getQuantity   	() { return quantity; }
    public int   	getCost   	() { return cost; }
    public int   	getPitemId   	() { return pitemId; }


    public void 	setQuantity   	(int quantity) { this.quantity = quantity; }
    public void 	setCost   	(int cost) { this.cost = cost; }
    public void 	setPitemId   	(int pitemId) { this.pitemId = pitemId; }

}
