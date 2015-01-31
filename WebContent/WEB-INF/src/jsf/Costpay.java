package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Costpay
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


    public Costpay() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	costpayDate,
        int	costpaySide,
        int	costpaySideID,
        int	costpayFeeticketID,
        int	costpayFeePayFeeID,
        int	costpayOwnertradeStatus,
        int	costpayOwnertradeId,
        int	costpaySalaryTicketId,
        int	costpaySalaryBankId,
        int	costpayNumberInOut,
        int	costpayPayway,
        int	costpayAccountType,
        int	costpayAccountId,
        int	costpayCostNumber,
        int	costpayIncomeNumber,
        int	costpayLogWay,
        Date	costpayLogDate,
        int	costpayLogId,
        String	costpayLogPs,
        int	costpayBanklog,
        int	costpayChequeId,
        int	costpayCostbookId,
        int	costpayCostCheckId,
        int	costpayVerifyStatus,
        Date	costpayVerifyDate,
        int	costpayVerifyId,
        String	costpayVerifyPs,
        int	costpayStudentAccountId,
        int	exRateId,
        double	exrate,
        double	orgAmount,
        String	checkInfo,
        String	receiptNo,
        String	payerName,
        int	threadId,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.costpayDate 	 = costpayDate;
        this.costpaySide 	 = costpaySide;
        this.costpaySideID 	 = costpaySideID;
        this.costpayFeeticketID 	 = costpayFeeticketID;
        this.costpayFeePayFeeID 	 = costpayFeePayFeeID;
        this.costpayOwnertradeStatus 	 = costpayOwnertradeStatus;
        this.costpayOwnertradeId 	 = costpayOwnertradeId;
        this.costpaySalaryTicketId 	 = costpaySalaryTicketId;
        this.costpaySalaryBankId 	 = costpaySalaryBankId;
        this.costpayNumberInOut 	 = costpayNumberInOut;
        this.costpayPayway 	 = costpayPayway;
        this.costpayAccountType 	 = costpayAccountType;
        this.costpayAccountId 	 = costpayAccountId;
        this.costpayCostNumber 	 = costpayCostNumber;
        this.costpayIncomeNumber 	 = costpayIncomeNumber;
        this.costpayLogWay 	 = costpayLogWay;
        this.costpayLogDate 	 = costpayLogDate;
        this.costpayLogId 	 = costpayLogId;
        this.costpayLogPs 	 = costpayLogPs;
        this.costpayBanklog 	 = costpayBanklog;
        this.costpayChequeId 	 = costpayChequeId;
        this.costpayCostbookId 	 = costpayCostbookId;
        this.costpayCostCheckId 	 = costpayCostCheckId;
        this.costpayVerifyStatus 	 = costpayVerifyStatus;
        this.costpayVerifyDate 	 = costpayVerifyDate;
        this.costpayVerifyId 	 = costpayVerifyId;
        this.costpayVerifyPs 	 = costpayVerifyPs;
        this.costpayStudentAccountId 	 = costpayStudentAccountId;
        this.exRateId 	 = exRateId;
        this.exrate 	 = exrate;
        this.orgAmount 	 = orgAmount;
        this.checkInfo 	 = checkInfo;
        this.receiptNo 	 = receiptNo;
        this.payerName 	 = payerName;
        this.threadId 	 = threadId;
        this.bunitId 	 = bunitId;
    }


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
}
