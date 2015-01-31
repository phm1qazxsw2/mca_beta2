package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillRecordMgr extends dbo.Manager<BillRecord>
{
    private static BillRecordMgr _instance = null;

    BillRecordMgr() {}

    public synchronized static BillRecordMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillRecordMgr();
        }
        return _instance;
    }

    public BillRecordMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billrecord";
    }

    protected Object makeBean()
    {
        return new BillRecord();
    }

    protected String getIdentifier(Object obj)
    {
        BillRecord o = (BillRecord) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillRecord item = (BillRecord) obj;
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
        BillRecord item = (BillRecord) obj;

        String ret = 
            "billId=" + item.getBillId()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",confirmed=" + item.getConfirmed()
            + ",month=" + (((d=item.getMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",billDate=" + (((d=item.getBillDate())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "billId,name,confirmed,month,billDate";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillRecord item = (BillRecord) obj;

        String ret = 
            "" + item.getBillId()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getConfirmed()
            + "," + (((d=item.getMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getBillDate())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        BillRecord o = (BillRecord) obj;
        o.setId(auto_id);
    }
}
