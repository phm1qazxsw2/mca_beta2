package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaFeeRecordMgr extends dbo.Manager<McaFeeRecord>
{
    private static McaFeeRecordMgr _instance = null;

    McaFeeRecordMgr() {}

    public synchronized static McaFeeRecordMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaFeeRecordMgr();
        }
        return _instance;
    }

    public McaFeeRecordMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_record join mca_fee join billrecord join bill";
    }

    protected Object makeBean()
    {
        return new McaFeeRecord();
    }

    protected String JoinSpace()
    {
         return "mca_record.mcaFeeId=mca_fee.id and mca_record.billRecordId=billrecord.id and billrecord.billId=bill.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaFeeRecord item = (McaFeeRecord) obj;
        try {
            int	id		 = rs.getInt("billrecord.id");
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
            int	feeId		 = rs.getInt("mca_fee.id");
            item.setFeeId(feeId);
            int	bunitId		 = rs.getInt("bill.bunitId");
            item.setBunitId(bunitId);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
