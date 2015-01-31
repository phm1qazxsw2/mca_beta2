package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrBillRecordMgr extends dbo.Manager<MembrBillRecord>
{
    private static MembrBillRecordMgr _instance = null;

    MembrBillRecordMgr() {}

    public synchronized static MembrBillRecordMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrBillRecordMgr();
        }
        return _instance;
    }

    public MembrBillRecordMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membrbillrecord";
    }

    protected Object makeBean()
    {
        return new MembrBillRecord();
    }

    protected String getIdentifier(Object obj)
    {
        MembrBillRecord o = (MembrBillRecord) obj;
        return "membrId = " + o.getMembrId() + " and " + "billRecordId = " + o.getBillRecordId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrBillRecord item = (MembrBillRecord) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            String	ticketId		 = rs.getString("ticketId");
            item.setTicketId(ticketId);
            int	receivable		 = rs.getInt("receivable");
            item.setReceivable(receivable);
            int	received		 = rs.getInt("received");
            item.setReceived(received);
            int	paidStatus		 = rs.getInt("paidStatus");
            item.setPaidStatus(paidStatus);
            java.util.Date	billDate		 = rs.getTimestamp("billDate");
            item.setBillDate(billDate);
            long	printDate		 = 0;try { printDate = Long.parseLong(new String(rs.getBytes("printDate"))); } catch (Exception ee) {}
            item.setPrintDate(printDate);
            long	forcemodify		 = 0;try { forcemodify = Long.parseLong(new String(rs.getBytes("forcemodify"))); } catch (Exception ee) {}
            item.setForcemodify(forcemodify);
            int	pending_cheque		 = rs.getInt("pending_cheque");
            item.setPending_cheque(pending_cheque);
            int	inheritUnpaid		 = rs.getInt("inheritUnpaid");
            item.setInheritUnpaid(inheritUnpaid);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getSaveString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MembrBillRecord item = (MembrBillRecord) obj;

        String ret = 
            "membrId=" + item.getMembrId()
            + ",billRecordId=" + item.getBillRecordId()
            + ",ticketId='" + ServerTool.escapeString(item.getTicketId()) + "'"
            + ",receivable=" + item.getReceivable()
            + ",received=" + item.getReceived()
            + ",paidStatus=" + item.getPaidStatus()
            + ",billDate=" + (((d=item.getBillDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",printDate=" + item.getPrintDate()
            + ",forcemodify=" + item.getForcemodify()
            + ",pending_cheque=" + item.getPending_cheque()
            + ",inheritUnpaid=" + item.getInheritUnpaid()
            + ",threadId=" + item.getThreadId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "membrId,billRecordId,ticketId,receivable,received,paidStatus,billDate,printDate,forcemodify,pending_cheque,inheritUnpaid,threadId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MembrBillRecord item = (MembrBillRecord) obj;

        String ret = 
            "" + item.getMembrId()
            + "," + item.getBillRecordId()
            + ",'" + ServerTool.escapeString(item.getTicketId()) + "'"
            + "," + item.getReceivable()
            + "," + item.getReceived()
            + "," + item.getPaidStatus()
            + "," + (((d=item.getBillDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getPrintDate()
            + "," + item.getForcemodify()
            + "," + item.getPending_cheque()
            + "," + item.getInheritUnpaid()
            + "," + item.getThreadId()

        ;
        return ret;
    }
}
