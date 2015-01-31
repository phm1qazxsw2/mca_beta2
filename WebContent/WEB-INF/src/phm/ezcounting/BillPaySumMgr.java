package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillPaySumMgr extends dbo.Manager<BillPaySum>
{
    private static BillPaySumMgr _instance = null;

    BillPaySumMgr() {}

    public synchronized static BillPaySumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillPaySumMgr();
        }
        return _instance;
    }

    public BillPaySumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billpay";
    }

    protected Object makeBean()
    {
        return new BillPaySum();
    }

    protected String getFieldList()
    {
         return "SUM(amount) as s1,SUM(remain) as s2";
    }

    protected String getIdentifier(Object obj)
    {
        BillPaySum o = (BillPaySum) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillPaySum item = (BillPaySum) obj;
        try {
            int	amount		 = rs.getInt("s1");
            item.setAmount(amount);
            int	remain		 = rs.getInt("s2");
            item.setRemain(remain);
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
        BillPaySum item = (BillPaySum) obj;

        String ret = 
            "amount=" + item.getAmount()
            + ",remain=" + item.getRemain()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "amount,remain";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillPaySum item = (BillPaySum) obj;

        String ret = 
            "" + item.getAmount()
            + "," + item.getRemain()

        ;
        return ret;
    }
}
