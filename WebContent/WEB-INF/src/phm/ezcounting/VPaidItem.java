package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VPaidItem
{

    private String   	title;
    private int   	vitemId;
    private int   	costpayId;
    private int   	amount;
    private Date   	recordTime;


    public VPaidItem() {}


    public String   	getTitle   	() { return title; }
    public int   	getVitemId   	() { return vitemId; }
    public int   	getCostpayId   	() { return costpayId; }
    public int   	getAmount   	() { return amount; }
    public Date   	getRecordTime   	() { return recordTime; }


    public void 	setTitle   	(String title) { this.title = title; }
    public void 	setVitemId   	(int vitemId) { this.vitemId = vitemId; }
    public void 	setCostpayId   	(int costpayId) { this.costpayId = costpayId; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }

}
