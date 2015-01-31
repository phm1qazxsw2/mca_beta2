package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillCommentMgr extends dbo.Manager<BillComment>
{
    private static BillCommentMgr _instance = null;

    BillCommentMgr() {}

    public synchronized static BillCommentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillCommentMgr();
        }
        return _instance;
    }

    public BillCommentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billcomment";
    }

    protected Object makeBean()
    {
        return new BillComment();
    }

    protected String getIdentifier(Object obj)
    {
        BillComment o = (BillComment) obj;
        return "membrId = " + o.getMembrId() + " and " + "billRecordId = " + o.getBillRecordId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillComment item = (BillComment) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            String	comment		 = rs.getString("comment");
            item.setComment(comment);
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
        BillComment item = (BillComment) obj;

        String ret = 
            "membrId=" + item.getMembrId()
            + ",billRecordId=" + item.getBillRecordId()
            + ",comment='" + ServerTool.escapeString(item.getComment()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "membrId,billRecordId,comment";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillComment item = (BillComment) obj;

        String ret = 
            "" + item.getMembrId()
            + "," + item.getBillRecordId()
            + ",'" + ServerTool.escapeString(item.getComment()) + "'"

        ;
        return ret;
    }
}
