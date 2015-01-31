package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrBillRecord
{

    private int   	membrId;
    private int   	billRecordId;
    private String   	ticketId;
    private int   	receivable;
    private int   	received;
    private int   	paidStatus;
    private Date   	billDate;
    private long   	printDate;
    private long   	forcemodify;
    private int   	pending_cheque;
    private int   	inheritUnpaid;
    private int   	threadId;


    public MembrBillRecord() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getBillRecordId   	() { return billRecordId; }
    public String   	getTicketId   	() { return ticketId; }
    public int   	getReceivable   	() { return receivable; }
    public int   	getReceived   	() { return received; }
    public int   	getPaidStatus   	() { return paidStatus; }
    public Date   	getBillDate   	() { return billDate; }
    public long   	getPrintDate   	() { return printDate; }
    public long   	getForcemodify   	() { return forcemodify; }
    public int   	getPending_cheque   	() { return pending_cheque; }
    public int   	getInheritUnpaid   	() { return inheritUnpaid; }
    public int   	getThreadId   	() { return threadId; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }
    public void 	setTicketId   	(String ticketId) { this.ticketId = ticketId; }
    public void 	setReceivable   	(int receivable) { this.receivable = receivable; }
    public void 	setReceived   	(int received) { this.received = received; }
    public void 	setPaidStatus   	(int paidStatus) { this.paidStatus = paidStatus; }
    public void 	setBillDate   	(Date billDate) { this.billDate = billDate; }
    public void 	setPrintDate   	(long printDate) { this.printDate = printDate; }
    public void 	setForcemodify   	(long forcemodify) { this.forcemodify = forcemodify; }
    public void 	setPending_cheque   	(int pending_cheque) { this.pending_cheque = pending_cheque; }
    public void 	setInheritUnpaid   	(int inheritUnpaid) { this.inheritUnpaid = inheritUnpaid; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }

    // paidStatus
    //   0 : not paid or under paid
    //  -1 : obsolete
    //   1 : partly paid
    //   2 : fully paid
    public static final int STATUS_NOT_PAID = 0;
    public static final int STATUS_PARTLY_PAID = 1;
    public static final int STATUS_FULLY_PAID = 2;
    public static final int STATUS_OBSOLETE = -1;

   public String getBillKey()
   {
        return getMembrId()+"#"+getBillRecordId();
   }

   public String getTicketIdAsString()
   {
       return "'" + this.getTicketId() + "'";
   }

}
