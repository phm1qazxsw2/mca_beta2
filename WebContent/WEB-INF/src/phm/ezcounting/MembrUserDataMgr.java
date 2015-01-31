package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MembrUserDataMgr extends dbo.Manager<MembrUserData>
{
    private static MembrUserDataMgr _instance = null;

    MembrUserDataMgr() {}

    public synchronized static MembrUserDataMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MembrUserDataMgr();
        }
        return _instance;
    }

    public MembrUserDataMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membruser join user";
    }

    protected Object makeBean()
    {
        return new MembrUserData();
    }

    protected String JoinSpace()
    {
         return "userId=user.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MembrUserData item = (MembrUserData) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            String	userLoginId		 = rs.getString("userLoginId");
            item.setUserLoginId(userLoginId);
            String	userPassword		 = rs.getString("userPassword");
            item.setUserPassword(userPassword);
            int	userActive		 = rs.getInt("userActive");
            item.setUserActive(userActive);
            String	name		 = rs.getString("membr.name");
            item.setName(name);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (membr) ON membrId=membr.id ";
        return ret;
    }
}
