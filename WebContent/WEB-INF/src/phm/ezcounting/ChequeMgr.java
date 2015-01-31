package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ChequeMgr extends dbo.Manager<Cheque>
{
    private static ChequeMgr _instance = null;

    ChequeMgr() {}

    public synchronized static ChequeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ChequeMgr();
        }
        return _instance;
    }

    public ChequeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cheque";
    }

    protected Object makeBean()
    {
        return new Cheque();
    }

    protected String getIdentifier(Object obj)
    {
        Cheque o = (Cheque) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Cheque item = (Cheque) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	inAmount		 = rs.getInt("inAmount");
            item.setInAmount(inAmount);
            int	outAmount		 = rs.getInt("outAmount");
            item.setOutAmount(outAmount);
            String	chequeId		 = rs.getString("chequeId");
            item.setChequeId(chequeId);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            java.util.Date	cashDate		 = rs.getTimestamp("cashDate");
            item.setCashDate(cashDate);
            int	type		 = rs.getInt("type");
            item.setType(type);
            java.util.Date	cashed		 = rs.getTimestamp("cashed");
            item.setCashed(cashed);
            String	title		 = rs.getString("title");
            item.setTitle(title);
            int	billpayId		 = rs.getInt("billpayId");
            item.setBillpayId(billpayId);
            int	costpayId		 = rs.getInt("costpayId");
            item.setCostpayId(costpayId);
            String	issueBank		 = rs.getString("issueBank");
            item.setIssueBank(issueBank);
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
        Cheque item = (Cheque) obj;

        String ret = 
            "inAmount=" + item.getInAmount()
            + ",outAmount=" + item.getOutAmount()
            + ",chequeId='" + ServerTool.escapeString(item.getChequeId()) + "'"
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",cashDate=" + (((d=item.getCashDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",type=" + item.getType()
            + ",cashed=" + (((d=item.getCashed())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",title='" + ServerTool.escapeString(item.getTitle()) + "'"
            + ",billpayId=" + item.getBillpayId()
            + ",costpayId=" + item.getCostpayId()
            + ",issueBank='" + ServerTool.escapeString(item.getIssueBank()) + "'"
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "inAmount,outAmount,chequeId,recordTime,cashDate,type,cashed,title,billpayId,costpayId,issueBank,threadId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Cheque item = (Cheque) obj;

        String ret = 
            "" + item.getInAmount()
            + "," + item.getOutAmount()
            + ",'" + ServerTool.escapeString(item.getChequeId()) + "'"
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getCashDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getType()
            + "," + (((d=item.getCashed())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getTitle()) + "'"
            + "," + item.getBillpayId()
            + "," + item.getCostpayId()
            + ",'" + ServerTool.escapeString(item.getIssueBank()) + "'"
            + "," + item.getThreadId()
            + "," + item.getBunitId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Cheque o = (Cheque) obj;
        o.setId(auto_id);
    }
}
