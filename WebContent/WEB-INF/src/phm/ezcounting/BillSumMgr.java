package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillSumMgr extends dbo.Manager<BillSum>
{
    private static BillSumMgr _instance = null;

    BillSumMgr() {}

    public synchronized static BillSumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillSumMgr();
        }
        return _instance;
    }

    public BillSumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membrbillrecord join billrecord join bill";
    }

    protected Object makeBean()
    {
        return new BillSum();
    }

    protected String JoinSpace()
    {
         return "billRecordId=billrecord.id and billId=bill.id";
    }

    protected String getFieldList()
    {
         return "SUM(receivable) as s1,SUM(received) as s2";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillSum item = (BillSum) obj;
        try {
            int	receivable		 = rs.getInt("s1");
            item.setReceivable(receivable);
            int	received		 = rs.getInt("s2");
            item.setReceived(received);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
