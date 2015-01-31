package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillRecordInfoMgr extends dbo.Manager<BillRecordInfo>
{
    private static BillRecordInfoMgr _instance = null;

    BillRecordInfoMgr() {}

    public synchronized static BillRecordInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillRecordInfoMgr();
        }
        return _instance;
    }

    public BillRecordInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billrecord join bill";
    }

    protected Object makeBean()
    {
        return new BillRecordInfo();
    }

    protected String JoinSpace()
    {
         return "billrecord.billId=bill.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillRecordInfo item = (BillRecordInfo) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	billId		 = rs.getInt("billId");
            item.setBillId(billId);
            String	name		 = rs.getString("name");
            item.setName(name);
            int	confirmed		 = rs.getInt("confirmed");
            item.setConfirmed(confirmed);
            java.util.Date	month		 = rs.getTimestamp("month");
            item.setMonth(month);
            java.util.Date	billDate		 = rs.getTimestamp("billDate");
            item.setBillDate(billDate);
            int	billType		 = rs.getInt("billType");
            item.setBillType(billType);
            int	privLevel		 = rs.getInt("privLevel");
            item.setPrivLevel(privLevel);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            String	billName		 = rs.getString("bill.name");
            item.setBillName(billName);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
