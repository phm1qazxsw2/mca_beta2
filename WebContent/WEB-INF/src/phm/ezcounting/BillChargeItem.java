package phm.ezcounting;

// need to specify billitem.id=xx and billrecord.id=yy in the query


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillChargeItem extends ChargeItem
{

    private int   	billId;
    private String   	name;
    private int   	aliasId;
    private int   	pitemId;
    private int   	mySmallItemId;
    private int   	parentSmallItemId;
    private int   	status;
    private String   	description;
    private String   	billName;
    private String   	billRecordName;
    private int   	defaultAmount;
    private Date   	month;
    private String   	color;
    private Date   	billDate;


    public BillChargeItem() {}


    public int   	getBillId   	() { return billId; }
    public String   	getName   	() { return name; }
    public int   	getAliasId   	() { return aliasId; }
    public int   	getPitemId   	() { return pitemId; }
    public int   	getMySmallItemId   	() { return mySmallItemId; }
    public int   	getParentSmallItemId   	() { return parentSmallItemId; }
    public int   	getStatus   	() { return status; }
    public String   	getDescription   	() { return description; }
    public String   	getBillName   	() { return billName; }
    public String   	getBillRecordName   	() { return billRecordName; }
    public int   	getDefaultAmount   	() { return defaultAmount; }
    public Date   	getMonth   	() { return month; }
    public String   	getColor   	() { return color; }
    public Date   	getBillDate   	() { return billDate; }


    public void 	setBillId   	(int billId) { this.billId = billId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setAliasId   	(int aliasId) { this.aliasId = aliasId; }
    public void 	setPitemId   	(int pitemId) { this.pitemId = pitemId; }
    public void 	setMySmallItemId   	(int mySmallItemId) { this.mySmallItemId = mySmallItemId; }
    public void 	setParentSmallItemId   	(int parentSmallItemId) { this.parentSmallItemId = parentSmallItemId; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setDescription   	(String description) { this.description = description; }
    public void 	setBillName   	(String billName) { this.billName = billName; }
    public void 	setBillRecordName   	(String billRecordName) { this.billRecordName = billRecordName; }
    public void 	setDefaultAmount   	(int defaultAmount) { this.defaultAmount = defaultAmount; }
    public void 	setMonth   	(Date month) { this.month = month; }
    public void 	setColor   	(String color) { this.color = color; }
    public void 	setBillDate   	(Date billDate) { this.billDate = billDate; }

    public int getSmallItemId()
    {
        return (mySmallItemId>0)?mySmallItemId:parentSmallItemId;
    }

    public int getMyAmount()
    {
        if (this.getChargeAmount()==0)
	    return this.getDefaultAmount();
	return this.getChargeAmount();
    }




}
