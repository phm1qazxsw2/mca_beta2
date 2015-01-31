package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaReceipt
{

    private String   	pkey;
    private int   	costpayId;


    public McaReceipt() {}


    public String   	getPkey   	() { return pkey; }
    public int   	getCostpayId   	() { return costpayId; }


    public void 	setPkey   	(String pkey) { this.pkey = pkey; }
    public void 	setCostpayId   	(int costpayId) { this.costpayId = costpayId; }

}
