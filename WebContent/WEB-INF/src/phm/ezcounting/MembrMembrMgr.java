package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrMembrMgr extends dbo.Manager<MembrMembr>
{
    private static MembrMembrMgr _instance = null;

    MembrMembrMgr() {}

    public synchronized static MembrMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrMembrMgr();
        }
        return _instance;
    }

    public MembrMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membrmembr";
    }

    protected Object makeBean()
    {
        return new MembrMembr();
    }

    protected String getIdentifier(Object obj)
    {
        MembrMembr o = (MembrMembr) obj;
        return "m1Id = " + o.getM1Id() + " and " + "m2Id = " + o.getM2Id();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrMembr item = (MembrMembr) obj;
        try {
            int	m1Id		 = rs.getInt("m1Id");
            item.setM1Id(m1Id);
            int	m2Id		 = rs.getInt("m2Id");
            item.setM2Id(m2Id);
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
        MembrMembr item = (MembrMembr) obj;

        String ret = 
            "m1Id=" + item.getM1Id()
            + ",m2Id=" + item.getM2Id()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "m1Id,m2Id";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MembrMembr item = (MembrMembr) obj;

        String ret = 
            "" + item.getM1Id()
            + "," + item.getM2Id()

        ;
        return ret;
    }
}
