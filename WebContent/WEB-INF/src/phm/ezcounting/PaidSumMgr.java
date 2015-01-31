package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PaidSumMgr extends dbo.Manager<PaidSum>
{
    private static PaidSumMgr _instance = null;

    PaidSumMgr() {}

    public synchronized static PaidSumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PaidSumMgr();
        }
        return _instance;
    }

    public PaidSumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billpaid join membrbillrecord join billrecord join bill";
    }

    protected Object makeBean()
    {
        return new PaidSum();
    }

    protected String JoinSpace()
    {
         return "billpaid.ticketId=membrbillrecord.ticketId and billRecordId=billrecord.id and billId=bill.id";
    }

    protected String getFieldList()
    {
         return "SUM(billpaid.amount) as s1";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PaidSum item = (PaidSum) obj;
        try {
            int	sum		 = rs.getInt("s1");
            item.setSum(sum);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
