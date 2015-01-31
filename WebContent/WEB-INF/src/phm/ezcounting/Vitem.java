package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Vitem
{

    private int   	id;
    private int   	userId;
    private Date   	createTime;
    private Date   	recordTime;
    private String   	title;
    private int   	type;
    private String   	acctcode;
    private int   	total;
    private int   	realized;
    private int   	paidstatus;
    private int   	attachtype;
    private int   	verifystatus;
    private Date   	verifyDate;
    private int   	verifyUserId;
    private int   	costTradeId;
    private int   	voucherId;
    private String   	note;
    private int   	orgtype;
    private int   	orgId;
    private int   	pending;
    private int   	threadId;
    private int   	bunitId;
    private String   	receiptNo;
    private String   	payerName;
    private String   	cashAcct;
    private String   	checkInfo;


    public Vitem() {}


    public int   	getId   	() { return id; }
    public int   	getUserId   	() { return userId; }
    public Date   	getCreateTime   	() { return createTime; }
    public Date   	getRecordTime   	() { return recordTime; }
    public String   	getTitle   	() { return title; }
    public int   	getType   	() { return type; }
    public String   	getAcctcode   	() { return acctcode; }
    public int   	getTotal   	() { return total; }
    public int   	getRealized   	() { return realized; }
    public int   	getPaidstatus   	() { return paidstatus; }
    public int   	getAttachtype   	() { return attachtype; }
    public int   	getVerifystatus   	() { return verifystatus; }
    public Date   	getVerifyDate   	() { return verifyDate; }
    public int   	getVerifyUserId   	() { return verifyUserId; }
    public int   	getCostTradeId   	() { return costTradeId; }
    public int   	getVoucherId   	() { return voucherId; }
    public String   	getNote   	() { return note; }
    public int   	getOrgtype   	() { return orgtype; }
    public int   	getOrgId   	() { return orgId; }
    public int   	getPending   	() { return pending; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }
    public String   	getReceiptNo   	() { return receiptNo; }
    public String   	getPayerName   	() { return payerName; }
    public String   	getCashAcct   	() { return cashAcct; }
    public String   	getCheckInfo   	() { return checkInfo; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setCreateTime   	(Date createTime) { this.createTime = createTime; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setTitle   	(String title) { this.title = title; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setAcctcode   	(String acctcode) { this.acctcode = acctcode; }
    public void 	setTotal   	(int total) { this.total = total; }
    public void 	setRealized   	(int realized) { this.realized = realized; }
    public void 	setPaidstatus   	(int paidstatus) { this.paidstatus = paidstatus; }
    public void 	setAttachtype   	(int attachtype) { this.attachtype = attachtype; }
    public void 	setVerifystatus   	(int verifystatus) { this.verifystatus = verifystatus; }
    public void 	setVerifyDate   	(Date verifyDate) { this.verifyDate = verifyDate; }
    public void 	setVerifyUserId   	(int verifyUserId) { this.verifyUserId = verifyUserId; }
    public void 	setCostTradeId   	(int costTradeId) { this.costTradeId = costTradeId; }
    public void 	setVoucherId   	(int voucherId) { this.voucherId = voucherId; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setOrgtype   	(int orgtype) { this.orgtype = orgtype; }
    public void 	setOrgId   	(int orgId) { this.orgId = orgId; }
    public void 	setPending   	(int pending) { this.pending = pending; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setReceiptNo   	(String receiptNo) { this.receiptNo = receiptNo; }
    public void 	setPayerName   	(String payerName) { this.payerName = payerName; }
    public void 	setCashAcct   	(String cashAcct) { this.cashAcct = cashAcct; }
    public void 	setCheckInfo   	(String checkInfo) { this.checkInfo = checkInfo; }

    public final static int TYPE_SPENDING = 0;
    public final static int TYPE_INCOME = 1;
    public final static int TYPE_COST_OF_GOODS = 2;

    public final static int STATUS_NOT_PAID = 0;
    public final static int STATUS_PARTLY_PAID = 1;
    public final static int STATUS_FULLY_PAID = 2;

    public final static int VERIFY_NO = 0;
    public final static int VERIFY_WARN = 1;
    public final static int VERIFY_YES = 2;

    public final static int ATTACH_NONE = 0;
    public final static int ATTACH_RECEIPT = 1;
    public final static int ATTACH_TAXSLIP = 2;

    public final static int ORG_TYPE_INVENTORY = 1;

    public String getAttachTypeName()
    {
        switch (attachtype) {
            case 0: return "無"; 
	    case 1: return "收據";
	    case 2: return "發票";
	}
	return "";
    }

    public String getAcctMajorCode()
    {
        String c = getAcctcode();
	if (c!=null&&c.length()>=4)
	    return c.substring(0,4);
	return "####";
    }

    public String getAcctCodeTrim()
    {
	return getAcctcode().trim();
    }

}
