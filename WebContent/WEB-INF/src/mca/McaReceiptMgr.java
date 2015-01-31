package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaReceiptMgr extends dbo.Manager<McaReceipt>
{
    private static McaReceiptMgr _instance = null;

    McaReceiptMgr() {}

    public synchronized static McaReceiptMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaReceiptMgr();
        }
        return _instance;
    }

    public McaReceiptMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_receipt";
    }

    protected Object makeBean()
    {
        return new McaReceipt();
    }

    protected String getIdentifier(Object obj)
    {
        McaReceipt o = (McaReceipt) obj;
        return "pkey = '" + o.getPkey()+"'";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaReceipt item = (McaReceipt) obj;
        try {
            String	pkey		 = rs.getString("pkey");
            item.setPkey(pkey);
            int	costpayId		 = rs.getInt("costpayId");
            item.setCostpayId(costpayId);
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
        McaReceipt item = (McaReceipt) obj;

        String ret = 
            "pkey='" + ServerTool.escapeString(item.getPkey()) + "'"
            + ",costpayId=" + item.getCostpayId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "pkey,costpayId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaReceipt item = (McaReceipt) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getPkey()) + "'"
            + "," + item.getCostpayId()

        ;
        return ret;
    }
}
