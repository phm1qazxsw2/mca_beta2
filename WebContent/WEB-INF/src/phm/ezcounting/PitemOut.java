package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class PitemOut
{

    private int   	pitemId;
    private int   	quantity;
    private int   	count;


    public PitemOut() {}


    public int   	getPitemId   	() { return pitemId; }
    public int   	getQuantity   	() { return quantity; }
    public int   	getCount   	() { return count; }


    public void 	setPitemId   	(int pitemId) { this.pitemId = pitemId; }
    public void 	setQuantity   	(int quantity) { this.quantity = quantity; }
    public void 	setCount   	(int count) { this.count = count; }

}
