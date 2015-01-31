package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VoucherMgr extends dbo.Manager<Voucher>
{
    private static VoucherMgr _instance = null;

    VoucherMgr() {}

    public synchronized static VoucherMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VoucherMgr();
        }
        return _instance;
    }

    public VoucherMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "voucher";
    }

    protected Object makeBean()
    {
        return new Voucher();
    }

    protected String getIdentifier(Object obj)
    {
        Voucher o = (Voucher) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Voucher item = (Voucher) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	costbookId		 = rs.getString("costbookId");
            item.setCostbookId(costbookId);
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
        Voucher item = (Voucher) obj;

        String ret = 
            "costbookId='" + ServerTool.escapeString(item.getCostbookId()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "costbookId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Voucher item = (Voucher) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getCostbookId()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Voucher o = (Voucher) obj;
        o.setId(auto_id);
    }
}
