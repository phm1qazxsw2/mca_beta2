package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillPaidMgr extends dbo.Manager<BillPaid>
{
    private static BillPaidMgr _instance = null;

    BillPaidMgr() {}

    public synchronized static BillPaidMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillPaidMgr();
        }
        return _instance;
    }

    public BillPaidMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billpaid";
    }

    protected Object makeBean()
    {
        return new BillPaid();
    }

    protected String getIdentifier(Object obj)
    {
        BillPaid o = (BillPaid) obj;
        return "billPayId = " + o.getBillPayId() + " and " + "ticketId = '" + o.getTicketId()+"'";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillPaid item = (BillPaid) obj;
        try {
            int	billPayId		 = rs.getInt("billPayId");
            item.setBillPayId(billPayId);
            String	ticketId		 = rs.getString("ticketId");
            item.setTicketId(ticketId);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        BillPaid item = (BillPaid) obj;

        String ret = 
            "billPayId=" + item.getBillPayId()
            + ",ticketId='" + ServerTool.escapeString(item.getTicketId()) + "'"
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",amount=" + item.getAmount()
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "billPayId,ticketId,recordTime,amount,threadId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillPaid item = (BillPaid) obj;

        String ret = 
            "" + item.getBillPayId()
            + ",'" + ServerTool.escapeString(item.getTicketId()) + "'"
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getAmount()
            + "," + item.getThreadId()
            + "," + item.getBunitId()

        ;
        return ret;
    }
}
