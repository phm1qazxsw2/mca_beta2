package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillRecord
{

    private int   	id;
    private int   	billId;
    private String   	name;
    private int   	confirmed;
    private Date   	month;
    private Date   	billDate;


    public BillRecord() {}


    public int   	getId   	() { return id; }
    public int   	getBillId   	() { return billId; }
    public String   	getName   	() { return name; }
    public int   	getConfirmed   	() { return confirmed; }
    public Date   	getMonth   	() { return month; }
    public Date   	getBillDate   	() { return billDate; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setBillId   	(int billId) { this.billId = billId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setConfirmed   	(int confirmed) { this.confirmed = confirmed; }
    public void 	setMonth   	(Date month) { this.month = month; }
    public void 	setBillDate   	(Date billDate) { this.billDate = billDate; }

}
