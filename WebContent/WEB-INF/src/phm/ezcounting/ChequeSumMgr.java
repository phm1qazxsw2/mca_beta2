package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ChequeSumMgr extends dbo.Manager<ChequeSum>
{
    private static ChequeSumMgr _instance = null;

    ChequeSumMgr() {}

    public synchronized static ChequeSumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ChequeSumMgr();
        }
        return _instance;
    }

    public ChequeSumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cheque";
    }

    protected Object makeBean()
    {
        return new ChequeSum();
    }

    protected String getFieldList()
    {
         return "SUM(inAmount) as s1,SUM(outAmount) as s2";
    }

    protected String getIdentifier(Object obj)
    {
        ChequeSum o = (ChequeSum) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ChequeSum item = (ChequeSum) obj;
        try {
            int	receivable		 = rs.getInt("s1");
            item.setReceivable(receivable);
            int	payable		 = rs.getInt("s2");
            item.setPayable(payable);
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
        ChequeSum item = (ChequeSum) obj;

        String ret = 
            "receivable=" + item.getReceivable()
            + ",payable=" + item.getPayable()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "receivable,payable";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ChequeSum item = (ChequeSum) obj;

        String ret = 
            "" + item.getReceivable()
            + "," + item.getPayable()

        ;
        return ret;
    }
}
