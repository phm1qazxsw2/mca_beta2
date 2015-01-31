package phm.ezcounting;

// 2008-12-3 by peter, add billpaid.amount>0 �]�����F�ǲ� ���i��� billpaid �Q�R�F���ɭԥu�O�N amount �令 0

import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillPaidInfo
{

    private int   	billPayId;
    private String   	ticketId;
    private int   	paidAmount;
    private int   	via;
    private Date   	paidTime;
    private Date   	createTime;
    private int   	payAmount;
    private int   	remain;
    private int   	userId;
    private int   	billSourceId;
    private String   	userLoginId;
    private int   	pending;
    private String   	membrName;
    private int   	membrId;
    private int   	billRecordId;
    private int   	chequeId;
    private String   	billPrettyName;
    private Date   	billMonth;


    public BillPaidInfo() {}


    public int   	getBillPayId   	() { return billPayId; }
    public String   	getTicketId   	() { return ticketId; }
    public int   	getPaidAmount   	() { return paidAmount; }
    public int   	getVia   	() { return via; }
    public Date   	getPaidTime   	() { return paidTime; }
    public Date   	getCreateTime   	() { return createTime; }
    public int   	getPayAmount   	() { return payAmount; }
    public int   	getRemain   	() { return remain; }
    public int   	getUserId   	() { return userId; }
    public int   	getBillSourceId   	() { return billSourceId; }
    public String   	getUserLoginId   	() { return userLoginId; }
    public int   	getPending   	() { return pending; }
    public String   	getMembrName   	() { return membrName; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getBillRecordId   	() { return billRecordId; }
    public int   	getChequeId   	() { return chequeId; }
    public String   	getBillPrettyName   	() { return billPrettyName; }
    public Date   	getBillMonth   	() { return billMonth; }


    public void 	setBillPayId   	(int billPayId) { this.billPayId = billPayId; }
    public void 	setTicketId   	(String ticketId) { this.ticketId = ticketId; }
    public void 	setPaidAmount   	(int paidAmount) { this.paidAmount = paidAmount; }
    public void 	setVia   	(int via) { this.via = via; }
    public void 	setPaidTime   	(Date paidTime) { this.paidTime = paidTime; }
    public void 	setCreateTime   	(Date createTime) { this.createTime = createTime; }
    public void 	setPayAmount   	(int payAmount) { this.payAmount = payAmount; }
    public void 	setRemain   	(int remain) { this.remain = remain; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setBillSourceId   	(int billSourceId) { this.billSourceId = billSourceId; }
    public void 	setUserLoginId   	(String userLoginId) { this.userLoginId = userLoginId; }
    public void 	setPending   	(int pending) { this.pending = pending; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }
    public void 	setChequeId   	(int chequeId) { this.chequeId = chequeId; }
    public void 	setBillPrettyName   	(String billPrettyName) { this.billPrettyName = billPrettyName; }
    public void 	setBillMonth   	(Date billMonth) { this.billMonth = billMonth; }

}
