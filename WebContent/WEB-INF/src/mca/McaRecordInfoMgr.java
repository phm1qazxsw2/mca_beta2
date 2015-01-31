package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaRecordInfoMgr extends dbo.Manager<McaRecordInfo>
{
    private static McaRecordInfoMgr _instance = null;

    McaRecordInfoMgr() {}

    public synchronized static McaRecordInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaRecordInfoMgr();
        }
        return _instance;
    }

    public McaRecordInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_record join mca_fee";
    }

    protected Object makeBean()
    {
        return new McaRecordInfo();
    }

    protected String JoinSpace()
    {
         return "mcaFeeId=mca_fee.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaRecordInfo item = (McaRecordInfo) obj;
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

}
