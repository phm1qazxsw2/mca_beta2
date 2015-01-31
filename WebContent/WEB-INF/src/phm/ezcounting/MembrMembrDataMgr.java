package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrMembrDataMgr extends dbo.Manager<MembrMembrData>
{
    private static MembrMembrDataMgr _instance = null;

    MembrMembrDataMgr() {}

    public synchronized static MembrMembrDataMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrMembrDataMgr();
        }
        return _instance;
    }

    public MembrMembrDataMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membrmembr join membr";
    }

    protected Object makeBean()
    {
        return new MembrMembrData();
    }

    protected String JoinSpace()
    {
         return "membrmembr.m2Id=membr.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrMembrData item = (MembrMembrData) obj;
        try {
            int	m1Id		 = rs.getInt("m1Id");
            item.setM1Id(m1Id);
            int	m2Id		 = rs.getInt("m2Id");
            item.setM2Id(m2Id);
            String	name		 = rs.getString("name");
            item.setName(name);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

}
