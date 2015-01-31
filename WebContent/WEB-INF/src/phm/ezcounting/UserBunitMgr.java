package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class UserBunitMgr extends dbo.Manager<UserBunit>
{
    private static UserBunitMgr _instance = null;

    UserBunitMgr() {}

    public synchronized static UserBunitMgr getInstance()
    {
        if (_instance==null) {
            _instance = new UserBunitMgr();
        }
        return _instance;
    }

    public UserBunitMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "userbunit";
    }

    protected Object makeBean()
    {
        return new UserBunit();
    }

    protected String getIdentifier(Object obj)
    {
        UserBunit o = (UserBunit) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        UserBunit item = (UserBunit) obj;
        try {
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        UserBunit item = (UserBunit) obj;

        String ret = 
            "userId=" + item.getUserId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "userId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        UserBunit item = (UserBunit) obj;

        String ret = 
            "" + item.getUserId()
            + "," + item.getBunitId()

        ;
        return ret;
    }
}
