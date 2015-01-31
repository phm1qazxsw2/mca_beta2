package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VPaidMgr extends dbo.Manager<VPaid>
{
    private static VPaidMgr _instance = null;

    VPaidMgr() {}

    public synchronized static VPaidMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VPaidMgr();
        }
        return _instance;
    }

    public VPaidMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vpaid";
    }

    protected Object makeBean()
    {
        return new VPaid();
    }

    protected String getIdentifier(Object obj)
    {
        VPaid o = (VPaid) obj;
        return "vitemId = " + o.getVitemId() + " and " + "costpayId = " + o.getCostpayId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VPaid item = (VPaid) obj;
        try {
            int	vitemId		 = rs.getInt("vitemId");
            item.setVitemId(vitemId);
            int	costpayId		 = rs.getInt("costpayId");
            item.setCostpayId(costpayId);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
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
        VPaid item = (VPaid) obj;

        String ret = 
            "vitemId=" + item.getVitemId()
            + ",costpayId=" + item.getCostpayId()
            + ",amount=" + item.getAmount()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "vitemId,costpayId,amount,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        VPaid item = (VPaid) obj;

        String ret = 
            "" + item.getVitemId()
            + "," + item.getCostpayId()
            + "," + item.getAmount()
            + "," + item.getBunitId()

        ;
        return ret;
    }
}
