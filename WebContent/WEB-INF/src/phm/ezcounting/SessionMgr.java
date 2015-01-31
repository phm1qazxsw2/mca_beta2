package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SessionMgr extends dbo.Manager<Session>
{
    private static SessionMgr _instance = null;

    SessionMgr() {}

    public synchronized static SessionMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SessionMgr();
        }
        return _instance;
    }

    public SessionMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "session";
    }

    protected Object makeBean()
    {
        return new Session();
    }

    protected String getIdentifier(Object obj)
    {
        Session o = (Session) obj;
        return "id = '" + o.getId()+"'";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Session item = (Session) obj;
        try {
            String	id		 = rs.getString("id");
            item.setId(id);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        Session item = (Session) obj;

        String ret = 
            "id='" + ServerTool.escapeString(item.getId()) + "'"
            + ",bunitId=" + item.getBunitId()
            + ",userId=" + item.getUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "id,bunitId,userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Session item = (Session) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getId()) + "'"
            + "," + item.getBunitId()
            + "," + item.getUserId()

        ;
        return ret;
    }
}
