package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PitemOutMgr extends dbo.Manager<PitemOut>
{
    private static PitemOutMgr _instance = null;

    PitemOutMgr() {}

    public synchronized static PitemOutMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PitemOutMgr();
        }
        return _instance;
    }

    public PitemOutMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billitem join chargeitem join charge join billrecord join bill";
    }

    protected Object makeBean()
    {
        return new PitemOut();
    }

    protected String JoinSpace()
    {
         return "billItemId=billitem.id and chargeItemId=chargeitem.id and chargeitem.billRecordId=billrecord.id and billitem.billId=bill.id and pitemId>0";
    }

    protected String getFieldList()
    {
         return "pitemId,sum(pitemNum) as q,count(*) as c";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PitemOut item = (PitemOut) obj;
        try {
            int	pitemId		 = rs.getInt("pitemId");
            item.setPitemId(pitemId);
            int	quantity		 = rs.getInt("q");
            item.setQuantity(quantity);
            int	count		 = rs.getInt("c");
            item.setCount(count);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
