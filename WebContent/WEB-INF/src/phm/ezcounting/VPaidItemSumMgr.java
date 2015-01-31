package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VPaidItemSumMgr extends dbo.Manager<VPaidItemSum>
{
    private static VPaidItemSumMgr _instance = null;

    VPaidItemSumMgr() {}

    public synchronized static VPaidItemSumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VPaidItemSumMgr();
        }
        return _instance;
    }

    public VPaidItemSumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vpaid join vitem join costpay";
    }

    protected Object makeBean()
    {
        return new VPaidItemSum();
    }

    protected String JoinSpace()
    {
         return "vitemId=vitem.id and costpayId=costpay.id";
    }

    protected String getFieldList()
    {
         return "SUM(vpaid.amount) as s";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VPaidItemSum item = (VPaidItemSum) obj;
        try {
            int	sum		 = rs.getInt("s");
            item.setSum(sum);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
