package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillPaid
{

    private int   	billPayId;
    private String   	ticketId;
    private Date   	recordTime;
    private int   	amount;
    private int   	threadId;
    private int   	bunitId;


    public BillPaid() {}


    public int   	getBillPayId   	() { return billPayId; }
    public String   	getTicketId   	() { return ticketId; }
    public Date   	getRecordTime   	() { return recordTime; }
    public int   	getAmount   	() { return amount; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setBillPayId   	(int billPayId) { this.billPayId = billPayId; }
    public void 	setTicketId   	(String ticketId) { this.ticketId = ticketId; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

    public String getTicketIdAsString()
    {
        return "'" + getTicketId() + "'";
    }

}
