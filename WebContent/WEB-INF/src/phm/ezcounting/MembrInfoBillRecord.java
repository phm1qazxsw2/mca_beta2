package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrInfoBillRecord extends MembrBillRecord
{

    private Date   	parentBillDate;
    private String   	membrName;
    private Date   	billMonth;
    private Date   	membrBirth;
    private int   	balanceWay;
    private String   	billRecordName;
    private String   	billPrettyName;
    private int   	billId;
    private int   	membrSurrogateId;
    private int   	billType;
    private String   	billName;
    private String   	comName;
    private String   	comAddr;
    private String   	payNote;
    private String   	regInfo;
    private int   	bunitId;
    private long   	forcemodify;


    public MembrInfoBillRecord() {}


    public Date   	getParentBillDate   	() { return parentBillDate; }
    public String   	getMembrName   	() { return membrName; }
    public Date   	getBillMonth   	() { return billMonth; }
    public Date   	getMembrBirth   	() { return membrBirth; }
    public int   	getBalanceWay   	() { return balanceWay; }
    public String   	getBillRecordName   	() { return billRecordName; }
    public String   	getBillPrettyName   	() { return billPrettyName; }
    public int   	getBillId   	() { return billId; }
    public int   	getMembrSurrogateId   	() { return membrSurrogateId; }
    public int   	getBillType   	() { return billType; }
    public String   	getBillName   	() { return billName; }
    public String   	getComName   	() { return comName; }
    public String   	getComAddr   	() { return comAddr; }
    public String   	getPayNote   	() { return payNote; }
    public String   	getRegInfo   	() { return regInfo; }
    public int   	getBunitId   	() { return bunitId; }
    public long   	getForcemodify   	() { return forcemodify; }


    public void 	setParentBillDate   	(Date parentBillDate) { this.parentBillDate = parentBillDate; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }
    public void 	setBillMonth   	(Date billMonth) { this.billMonth = billMonth; }
    public void 	setMembrBirth   	(Date membrBirth) { this.membrBirth = membrBirth; }
    public void 	setBalanceWay   	(int balanceWay) { this.balanceWay = balanceWay; }
    public void 	setBillRecordName   	(String billRecordName) { this.billRecordName = billRecordName; }
    public void 	setBillPrettyName   	(String billPrettyName) { this.billPrettyName = billPrettyName; }
    public void 	setBillId   	(int billId) { this.billId = billId; }
    public void 	setMembrSurrogateId   	(int membrSurrogateId) { this.membrSurrogateId = membrSurrogateId; }
    public void 	setBillType   	(int billType) { this.billType = billType; }
    public void 	setBillName   	(String billName) { this.billName = billName; }
    public void 	setComName   	(String comName) { this.comName = comName; }
    public void 	setComAddr   	(String comAddr) { this.comAddr = comAddr; }
    public void 	setPayNote   	(String payNote) { this.payNote = payNote; }
    public void 	setRegInfo   	(String regInfo) { this.regInfo = regInfo; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setForcemodify   	(long forcemodify) { this.forcemodify = forcemodify; }

    public Date getMyBillDate()
    {
        return (this.getBillDate()!=null)?this.getBillDate():parentBillDate;
    }

    public String getMembrBillKey()
    {
        return getMembrId()+"#" + getBillId();
    }

    public int getFinalAmount()
    {
        return getReceivable() + getInheritUnpaid();
    }

}
