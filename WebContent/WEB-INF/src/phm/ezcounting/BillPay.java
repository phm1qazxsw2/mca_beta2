package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillPay
{

    private int   	id;
    private int   	via;
    private Date   	recordTime;
    private Date   	createTime;
    private int   	amount;
    private int   	remain;
    private int   	membrId;
    private int   	userId;
    private int   	billSourceId;
    private int   	chequeId;
    private int   	pending;
    private int   	refundCostPayId;
    private long   	exportDate;
    private int   	exportUserId;
    private int   	verifyStatus;
    private int   	verifyId;
    private Date   	verifyDate;
    private String   	note;
    private int   	threadId;
    private int   	bunitId;


    public BillPay() {}


    public int   	getId   	() { return id; }
    public int   	getVia   	() { return via; }
    public Date   	getRecordTime   	() { return recordTime; }
    public Date   	getCreateTime   	() { return createTime; }
    public int   	getAmount   	() { return amount; }
    public int   	getRemain   	() { return remain; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getUserId   	() { return userId; }
    public int   	getBillSourceId   	() { return billSourceId; }
    public int   	getChequeId   	() { return chequeId; }
    public int   	getPending   	() { return pending; }
    public int   	getRefundCostPayId   	() { return refundCostPayId; }
    public long   	getExportDate   	() { return exportDate; }
    public int   	getExportUserId   	() { return exportUserId; }
    public int   	getVerifyStatus   	() { return verifyStatus; }
    public int   	getVerifyId   	() { return verifyId; }
    public Date   	getVerifyDate   	() { return verifyDate; }
    public String   	getNote   	() { return note; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setVia   	(int via) { this.via = via; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setCreateTime   	(Date createTime) { this.createTime = createTime; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setRemain   	(int remain) { this.remain = remain; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setBillSourceId   	(int billSourceId) { this.billSourceId = billSourceId; }
    public void 	setChequeId   	(int chequeId) { this.chequeId = chequeId; }
    public void 	setPending   	(int pending) { this.pending = pending; }
    public void 	setRefundCostPayId   	(int refundCostPayId) { this.refundCostPayId = refundCostPayId; }
    public void 	setExportDate   	(long exportDate) { this.exportDate = exportDate; }
    public void 	setExportUserId   	(int exportUserId) { this.exportUserId = exportUserId; }
    public void 	setVerifyStatus   	(int verifyStatus) { this.verifyStatus = verifyStatus; }
    public void 	setVerifyId   	(int verifyId) { this.verifyId = verifyId; }
    public void 	setVerifyDate   	(Date verifyDate) { this.verifyDate = verifyDate; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
   // via
   /* 0: cash, 1: atm, 2:store, 3:check, 4:wire, 5:credit card, 
      100: cash salary, 101: wire salary, 102: check salary */

    public static final int VIA_INPERSON = 0; 
    public static final int VIA_ATM = 1;
    public static final int VIA_STORE = 2;
    public static final int VIA_CHECK = 3;
    public static final int VIA_WIRE = 4;
    public static final int VIA_CREDITCARD = 5;

    public static final int SALARY_CASH = 100;
    public static final int SALARY_WIRE = 101;
    public static final int SALARY_CHECK = 102;

    public static final int STATUS_NOT_VERIFIED = 0;
    public static final int STATUS_VERIFIED = 1;

}
