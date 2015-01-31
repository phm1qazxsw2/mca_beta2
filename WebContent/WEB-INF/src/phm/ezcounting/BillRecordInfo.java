package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillRecordInfo extends BillRecord
{

    private int   	billType;
    private int   	privLevel;
    private int   	status;
    private String   	billName;


    public BillRecordInfo() {}


    public int   	getBillType   	() { return billType; }
    public int   	getPrivLevel   	() { return privLevel; }
    public int   	getStatus   	() { return status; }
    public String   	getBillName   	() { return billName; }


    public void 	setBillType   	(int billType) { this.billType = billType; }
    public void 	setPrivLevel   	(int privLevel) { this.privLevel = privLevel; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setBillName   	(String billName) { this.billName = billName; }

}
