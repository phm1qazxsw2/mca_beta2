package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VPaid
{

    private int   	vitemId;
    private int   	costpayId;
    private int   	amount;
    private int   	bunitId;


    public VPaid() {}


    public int   	getVitemId   	() { return vitemId; }
    public int   	getCostpayId   	() { return costpayId; }
    public int   	getAmount   	() { return amount; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setVitemId   	(int vitemId) { this.vitemId = vitemId; }
    public void 	setCostpayId   	(int costpayId) { this.costpayId = costpayId; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
