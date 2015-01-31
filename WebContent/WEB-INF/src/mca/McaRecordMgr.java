package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaRecordMgr extends dbo.Manager<McaRecord>
{
    private static McaRecordMgr _instance = null;

    McaRecordMgr() {}

    public synchronized static McaRecordMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaRecordMgr();
        }
        return _instance;
    }

    public McaRecordMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_record";
    }

    protected Object makeBean()
    {
        return new McaRecord();
    }

    protected String getIdentifier(Object obj)
    {
        McaRecord o = (McaRecord) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaRecord item = (McaRecord) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	mcaFeeId		 = rs.getInt("mcaFeeId");
            item.setMcaFeeId(mcaFeeId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
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
        McaRecord item = (McaRecord) obj;

        String ret = 
            "mcaFeeId=" + item.getMcaFeeId()
            + ",billRecordId=" + item.getBillRecordId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "mcaFeeId,billRecordId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaRecord item = (McaRecord) obj;

        String ret = 
            "" + item.getMcaFeeId()
            + "," + item.getBillRecordId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        McaRecord o = (McaRecord) obj;
        o.setId(auto_id);
    }
}
