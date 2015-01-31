package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrUserMgr extends dbo.Manager<MembrUser>
{
    private static MembrUserMgr _instance = null;

    MembrUserMgr() {}

    public synchronized static MembrUserMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrUserMgr();
        }
        return _instance;
    }

    public MembrUserMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membruser";
    }

    protected Object makeBean()
    {
        return new MembrUser();
    }

    protected String getIdentifier(Object obj)
    {
        MembrUser o = (MembrUser) obj;
        return "membrId = " + o.getMembrId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrUser item = (MembrUser) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
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
        MembrUser item = (MembrUser) obj;

        String ret = 
            "membrId=" + item.getMembrId()
            + ",userId=" + item.getUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "membrId,userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MembrUser item = (MembrUser) obj;

        String ret = 
            "" + item.getMembrId()
            + "," + item.getUserId()

        ;
        return ret;
    }
}
