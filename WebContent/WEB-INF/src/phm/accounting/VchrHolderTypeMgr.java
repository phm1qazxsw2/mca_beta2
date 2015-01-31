package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VchrHolderTypeMgr extends dbo.Manager<VchrHolderType>
{
    private static VchrHolderTypeMgr _instance = null;

    VchrHolderTypeMgr() {}

    public synchronized static VchrHolderTypeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VchrHolderTypeMgr();
        }
        return _instance;
    }

    public VchrHolderTypeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vchr_holder join vchr_thread";
    }

    protected Object makeBean()
    {
        return new VchrHolderType();
    }

    protected String JoinSpace()
    {
         return "threadId=vchr_thread.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VchrHolderType item = (VchrHolderType) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	registerDate		 = rs.getTimestamp("registerDate");
            item.setRegisterDate(registerDate);
            String	serial		 = rs.getString("serial");
            item.setSerial(serial);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	type		 = rs.getInt("type");
            item.setType(type);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            int	note		 = rs.getInt("note");
            item.setNote(note);
            int	buId		 = rs.getInt("buId");
            item.setBuId(buId);
            int	srcType		 = rs.getInt("srcType");
            item.setSrcType(srcType);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
