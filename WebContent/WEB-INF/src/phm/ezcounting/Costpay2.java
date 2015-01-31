package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Costpay2
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	costpayDate;
    private int   	costpaySide;
    private int   	costpaySideID;
    private int   	costpayFeeticketID;
    private int   	costpayFeePayFeeID;
    private int   	costpayOwnertradeStatus;
    private int   	costpayOwnertradeId;
    private int   	costpaySalaryTicketId;
    private int   	costpaySalaryBankId;
    private int   	costpayNumberInOut;
    private int   	costpayPayway;
    private int   	costpayAccountType;
    private int   	costpayAccountId;
    private int   	costpayCostNumber;
    private int   	costpayIncomeNumber;
    private int   	costpayLogWay;
    private Date   	costpayLogDate;
    private int   	costpayLogId;
    private String   	costpayLogPs;
    private int   	costpayBanklog;
    private int   	costpayChequeId;
    private int   	costpayCostbookId;
    private int   	costpayCostCheckId;
    private int   	costpayVerifyStatus;
    private Date   	costpayVerifyDate;
    private int   	costpayVerifyId;
    private String   	costpayVerifyPs;
    private int   	costpayStudentAccountId;
    private int   	exRateId;
    private double   	exrate;
    private double   	orgAmount;
    private String   	checkInfo;
    private String   	receiptNo;
    private String   	payerName;
    private int   	threadId;
    private int   	bunitId;


    public Costpay2() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getCostpayDate   	() { return costpayDate; }
    public int   	getCostpaySide   	() { return costpaySide; }
    public int   	getCostpaySideID   	() { return costpaySideID; }
    public int   	getCostpayFeeticketID   	() { return costpayFeeticketID; }
    public int   	getCostpayFeePayFeeID   	() { return costpayFeePayFeeID; }
    public int   	getCostpayOwnertradeStatus   	() { return costpayOwnertradeStatus; }
    public int   	getCostpayOwnertradeId   	() { return costpayOwnertradeId; }
    public int   	getCostpaySalaryTicketId   	() { return costpaySalaryTicketId; }
    public int   	getCostpaySalaryBankId   	() { return costpaySalaryBankId; }
    public int   	getCostpayNumberInOut   	() { return costpayNumberInOut; }
    public int   	getCostpayPayway   	() { return costpayPayway; }
    public int   	getCostpayAccountType   	() { return costpayAccountType; }
    public int   	getCostpayAccountId   	() { return costpayAccountId; }
    public int   	getCostpayCostNumber   	() { return costpayCostNumber; }
    public int   	getCostpayIncomeNumber   	() { return costpayIncomeNumber; }
    public int   	getCostpayLogWay   	() { return costpayLogWay; }
    public Date   	getCostpayLogDate   	() { return costpayLogDate; }
    public int   	getCostpayLogId   	() { return costpayLogId; }
    public String   	getCostpayLogPs   	() { return costpayLogPs; }
    public int   	getCostpayBanklog   	() { return costpayBanklog; }
    public int   	getCostpayChequeId   	() { return costpayChequeId; }
    public int   	getCostpayCostbookId   	() { return costpayCostbookId; }
    public int   	getCostpayCostCheckId   	() { return costpayCostCheckId; }
    public int   	getCostpayVerifyStatus   	() { return costpayVerifyStatus; }
    public Date   	getCostpayVerifyDate   	() { return costpayVerifyDate; }
    public int   	getCostpayVerifyId   	() { return costpayVerifyId; }
    public String   	getCostpayVerifyPs   	() { return costpayVerifyPs; }
    public int   	getCostpayStudentAccountId   	() { return costpayStudentAccountId; }
    public int   	getExRateId   	() { return exRateId; }
    public double   	getExrate   	() { return exrate; }
    public double   	getOrgAmount   	() { return orgAmount; }
    public String   	getCheckInfo   	() { return checkInfo; }
    public String   	getReceiptNo   	() { return receiptNo; }
    public String   	getPayerName   	() { return payerName; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCostpayDate   	(Date costpayDate) { this.costpayDate = costpayDate; }
    public void 	setCostpaySide   	(int costpaySide) { this.costpaySide = costpaySide; }
    public void 	setCostpaySideID   	(int costpaySideID) { this.costpaySideID = costpaySideID; }
    public void 	setCostpayFeeticketID   	(int costpayFeeticketID) { this.costpayFeeticketID = costpayFeeticketID; }
    public void 	setCostpayFeePayFeeID   	(int costpayFeePayFeeID) { this.costpayFeePayFeeID = costpayFeePayFeeID; }
    public void 	setCostpayOwnertradeStatus   	(int costpayOwnertradeStatus) { this.costpayOwnertradeStatus = costpayOwnertradeStatus; }
    public void 	setCostpayOwnertradeId   	(int costpayOwnertradeId) { this.costpayOwnertradeId = costpayOwnertradeId; }
    public void 	setCostpaySalaryTicketId   	(int costpaySalaryTicketId) { this.costpaySalaryTicketId = costpaySalaryTicketId; }
    public void 	setCostpaySalaryBankId   	(int costpaySalaryBankId) { this.costpaySalaryBankId = costpaySalaryBankId; }
    public void 	setCostpayNumberInOut   	(int costpayNumberInOut) { this.costpayNumberInOut = costpayNumberInOut; }
    public void 	setCostpayPayway   	(int costpayPayway) { this.costpayPayway = costpayPayway; }
    public void 	setCostpayAccountType   	(int costpayAccountType) { this.costpayAccountType = costpayAccountType; }
    public void 	setCostpayAccountId   	(int costpayAccountId) { this.costpayAccountId = costpayAccountId; }
    public void 	setCostpayCostNumber   	(int costpayCostNumber) { this.costpayCostNumber = costpayCostNumber; }
    public void 	setCostpayIncomeNumber   	(int costpayIncomeNumber) { this.costpayIncomeNumber = costpayIncomeNumber; }
    public void 	setCostpayLogWay   	(int costpayLogWay) { this.costpayLogWay = costpayLogWay; }
    public void 	setCostpayLogDate   	(Date costpayLogDate) { this.costpayLogDate = costpayLogDate; }
    public void 	setCostpayLogId   	(int costpayLogId) { this.costpayLogId = costpayLogId; }
    public void 	setCostpayLogPs   	(String costpayLogPs) { this.costpayLogPs = costpayLogPs; }
    public void 	setCostpayBanklog   	(int costpayBanklog) { this.costpayBanklog = costpayBanklog; }
    public void 	setCostpayChequeId   	(int costpayChequeId) { this.costpayChequeId = costpayChequeId; }
    public void 	setCostpayCostbookId   	(int costpayCostbookId) { this.costpayCostbookId = costpayCostbookId; }
    public void 	setCostpayCostCheckId   	(int costpayCostCheckId) { this.costpayCostCheckId = costpayCostCheckId; }
    public void 	setCostpayVerifyStatus   	(int costpayVerifyStatus) { this.costpayVerifyStatus = costpayVerifyStatus; }
    public void 	setCostpayVerifyDate   	(Date costpayVerifyDate) { this.costpayVerifyDate = costpayVerifyDate; }
    public void 	setCostpayVerifyId   	(int costpayVerifyId) { this.costpayVerifyId = costpayVerifyId; }
    public void 	setCostpayVerifyPs   	(String costpayVerifyPs) { this.costpayVerifyPs = costpayVerifyPs; }
    public void 	setCostpayStudentAccountId   	(int costpayStudentAccountId) { this.costpayStudentAccountId = costpayStudentAccountId; }
    public void 	setExRateId   	(int exRateId) { this.exRateId = exRateId; }
    public void 	setExrate   	(double exrate) { this.exrate = exrate; }
    public void 	setOrgAmount   	(double orgAmount) { this.orgAmount = orgAmount; }
    public void 	setCheckInfo   	(String checkInfo) { this.checkInfo = checkInfo; }
    public void 	setReceiptNo   	(String receiptNo) { this.receiptNo = receiptNo; }
    public void 	setPayerName   	(String payerName) { this.payerName = payerName; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

    public static final int COSPAY_TYPE_TUITION = -9999;
    public static final int COSPAY_TYPE_SALARY = -10000;
    public static final int COSPAY_TYPE_REFUND = -10001;
    public static final int COSPAY_TYPE_SPENDING = -10002;
    public static final int COSPAY_TYPE_INCOME = -10003;
    public static final int COSPAY_TYPE_COST_OF_GOODS = -10006;
    public static final int COSPAY_TYPE_CHEQUE_TUITION = -10004;
    public static final int COSPAY_TYPE_INITIALIZE = -10005;
    public static final int COSPAY_TYPE_MANUAL_VOUCHER = -10007;

    public static final int VERIFIED_NO = 0;
    public static final int VERIFIED_WARN = 1;
    public static final int VERIFIED_YES = 2;

    public static final int ACCOUNT_TYPE_CASH = 1;
    public static final int ACCOUNT_TYPE_BANK = 2;
    public static final int ACCOUNT_TYPE_CHEQUE = 3;
    public static final int ACCOUNT_TYPE_USD_CASH = 4; // ���
    public static final int ACCOUNT_TYPE_USD_CHECK = 5; // ���


    //payway: 0:�{��A1�G�䲼�A2�G�״ڡG3�G��L
    public static final int PAYWAY_CASH = 0;
    public static final int PAYWAY_CHEQUE = 1;
    public static final int PAYWAY_WIRE = 2;
    public static final int PAYWAY_OTHER = 3;
    public static final int PAYWAY_USD_CASH = 4;
    public static final int PAYWAY_USD_CHECK = 5;


}
