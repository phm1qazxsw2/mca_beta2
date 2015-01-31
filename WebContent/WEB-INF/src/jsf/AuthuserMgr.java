package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AuthuserMgr extends Manager
{
    private static AuthuserMgr _instance = null;

    AuthuserMgr() {}

    public synchronized static AuthuserMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AuthuserMgr();
        }
        return _instance;
    }

    public AuthuserMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "authuser";
    }

    protected Object makeBean()
    {
        return new Authuser();
    }

    protected int getBeanId(Object obj)
    {
        return ((Authuser)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Authuser item = (Authuser) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	authitemId		 = rs.getInt("authitemId");
            int	userId		 = rs.getInt("userId");

            item
            .init(id, created, modified
            , authitemId, userId);
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
        Authuser item = (Authuser) obj;

        String ret = "modified=NOW()"
            + ",authitemId=" + item.getAuthitemId()
            + ",userId=" + item.getUserId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, authitemId, userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Authuser item = (Authuser) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getAuthitemId()
            + "," + item.getUserId()
        ;
        return ret;
    }
}
