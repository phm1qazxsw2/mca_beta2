package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class IncomeCostMgr extends dbo.Manager<IncomeCost>
{
    private static IncomeCostMgr _instance = null;

    IncomeCostMgr() {}

    public synchronized static IncomeCostMgr getInstance()
    {
        if (_instance==null) {
            _instance = new IncomeCostMgr();
        }
        return _instance;
    }

    public IncomeCostMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costpay";
    }

    protected Object makeBean()
    {
        return new IncomeCost();
    }

    protected String getFieldList()
    {
         return "SUM(costpayCostNumber) as s1,SUM(costpayIncomeNumber) as s2,SUM(orgAmount) as s3";
    }

    protected String getIdentifier(Object obj)
    {
        IncomeCost o = (IncomeCost) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        IncomeCost item = (IncomeCost) obj;
        try {
            int	cost		 = rs.getInt("s1");
            item.setCost(cost);
            int	income		 = rs.getInt("s2");
            item.setIncome(income);
            double	orgAmount		 = rs.getDouble("s3");
            item.setOrgAmount(orgAmount);
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
        IncomeCost item = (IncomeCost) obj;

        String ret = 
            "cost=" + item.getCost()
            + ",income=" + item.getIncome()
            + ",orgAmount=" + item.getOrgAmount()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "cost,income,orgAmount";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        IncomeCost item = (IncomeCost) obj;

        String ret = 
            "" + item.getCost()
            + "," + item.getIncome()
            + "," + item.getOrgAmount()

        ;
        return ret;
    }
}
