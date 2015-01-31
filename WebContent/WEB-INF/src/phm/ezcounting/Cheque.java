package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Cheque
{

    private int   	id;
    private int   	inAmount;
    private int   	outAmount;
    private String   	chequeId;
    private Date   	recordTime;
    private Date   	cashDate;
    private int   	type;
    private Date   	cashed;
    private String   	title;
    private int   	billpayId;
    private int   	costpayId;
    private String   	issueBank;
    private int   	threadId;
    private int   	bunitId;


    public Cheque() {}


    public int   	getId   	() { return id; }
    public int   	getInAmount   	() { return inAmount; }
    public int   	getOutAmount   	() { return outAmount; }
    public String   	getChequeId   	() { return chequeId; }
    public Date   	getRecordTime   	() { return recordTime; }
    public Date   	getCashDate   	() { return cashDate; }
    public int   	getType   	() { return type; }
    public Date   	getCashed   	() { return cashed; }
    public String   	getTitle   	() { return title; }
    public int   	getBillpayId   	() { return billpayId; }
    public int   	getCostpayId   	() { return costpayId; }
    public String   	getIssueBank   	() { return issueBank; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setInAmount   	(int inAmount) { this.inAmount = inAmount; }
    public void 	setOutAmount   	(int outAmount) { this.outAmount = outAmount; }
    public void 	setChequeId   	(String chequeId) { this.chequeId = chequeId; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setCashDate   	(Date cashDate) { this.cashDate = cashDate; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setCashed   	(Date cashed) { this.cashed = cashed; }
    public void 	setTitle   	(String title) { this.title = title; }
    public void 	setBillpayId   	(int billpayId) { this.billpayId = billpayId; }
    public void 	setCostpayId   	(int costpayId) { this.costpayId = costpayId; }
    public void 	setIssueBank   	(String issueBank) { this.issueBank = issueBank; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public final static int TYPE_INCOME_TUITION = 1;
    public final static int TYPE_SPENDING_INCOME = 2;
    public final static int TYPE_SPENDING_PAY = 3;
    public final static int TYPE_COST_OF_GOODS = 4;


}
