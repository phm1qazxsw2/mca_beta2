package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AuthitemMgr extends Manager
{
    private static AuthitemMgr _instance = null;

    AuthitemMgr() {}

    public synchronized static AuthitemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AuthitemMgr();
        }
        return _instance;
    }

    public AuthitemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "authitem";
    }

    protected Object makeBean()
    {
        return new Authitem();
    }

    protected int getBeanId(Object obj)
    {
        return ((Authitem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Authitem item = (Authitem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	authId		 = rs.getInt("authId");
            int	number		 = rs.getInt("number");
            String	pagename		 = rs.getString("pagename");

            item
            .init(id, created, modified
            , authId, number, pagename
            );
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
        Authitem item = (Authitem) obj;

        String ret = "modified=NOW()"
            + ",authId=" + item.getAuthId()
            + ",number=" + item.getNumber()
            + ",pagename='" + ServerTool.escapeString(item.getPagename()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, authId, number, pagename";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Authitem item = (Authitem) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getAuthId()
            + "," + item.getNumber()
            + ",'" + ServerTool.escapeString(item.getPagename()) + "'"
        ;
        return ret;
    }
}
