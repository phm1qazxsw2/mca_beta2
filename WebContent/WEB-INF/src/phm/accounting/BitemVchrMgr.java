package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BitemVchrMgr extends dbo.Manager<BitemVchr>
{
    private static BitemVchrMgr _instance = null;

    BitemVchrMgr() {}

    public synchronized static BitemVchrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BitemVchrMgr();
        }
        return _instance;
    }

    public BitemVchrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bitem_vchr";
    }

    protected Object makeBean()
    {
        return new BitemVchr();
    }

    protected String getIdentifier(Object obj)
    {
        BitemVchr o = (BitemVchr) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BitemVchr item = (BitemVchr) obj;
        try {
            int	billItemId		 = rs.getInt("billItemId");
            item.setBillItemId(billItemId);
            int	vchrId		 = rs.getInt("vchrId");
            item.setVchrId(vchrId);
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
        BitemVchr item = (BitemVchr) obj;

        String ret = 
            "billItemId=" + item.getBillItemId()
            + ",vchrId=" + item.getVchrId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "billItemId,vchrId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BitemVchr item = (BitemVchr) obj;

        String ret = 
            "" + item.getBillItemId()
            + "," + item.getVchrId()

        ;
        return ret;
    }
}
