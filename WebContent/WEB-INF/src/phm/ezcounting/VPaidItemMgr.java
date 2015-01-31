package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VPaidItemMgr extends dbo.Manager<VPaidItem>
{
    private static VPaidItemMgr _instance = null;

    VPaidItemMgr() {}

    public synchronized static VPaidItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VPaidItemMgr();
        }
        return _instance;
    }

    public VPaidItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vpaid join vitem";
    }

    protected Object makeBean()
    {
        return new VPaidItem();
    }

    protected String JoinSpace()
    {
         return "vitemId=vitem.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VPaidItem item = (VPaidItem) obj;
        try {
            String	title		 = rs.getString("title");
            item.setTitle(title);
            int	vitemId		 = rs.getInt("vitemId");
            item.setVitemId(vitemId);
            int	costpayId		 = rs.getInt("costpayId");
            item.setCostpayId(costpayId);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
