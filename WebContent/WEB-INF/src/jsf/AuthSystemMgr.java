package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AuthSystemMgr extends Manager
{
    private static AuthSystemMgr _instance = null;

    AuthSystemMgr() {}

    public synchronized static AuthSystemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AuthSystemMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "authsystem";
    }

    protected Object makeBean()
    {
        return new AuthSystem();
    }

    protected int getBeanId(Object obj)
    {
        return ((AuthSystem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        AuthSystem item = (AuthSystem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	authSystemCode		 = rs.getString("authSystemCode");
            int	authSystemType		 = rs.getInt("authSystemType");
            int	authSystemStatus		 = rs.getInt("authSystemStatus");
            String	authSystemPs		 = rs.getString("authSystemPs");

            item
            .init(id, created, modified
            , authSystemCode, authSystemType, authSystemStatus
            , authSystemPs);
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
        AuthSystem item = (AuthSystem) obj;

        String ret = "modified=NOW()"
            + ",authSystemCode='" + ServerTool.escapeString(item.getAuthSystemCode()) + "'"
            + ",authSystemType=" + item.getAuthSystemType()
            + ",authSystemStatus=" + item.getAuthSystemStatus()
            + ",authSystemPs='" + ServerTool.escapeString(item.getAuthSystemPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, authSystemCode, authSystemType, authSystemStatus, authSystemPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        AuthSystem item = (AuthSystem) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getAuthSystemCode()) + "'"
            + "," + item.getAuthSystemType()
            + "," + item.getAuthSystemStatus()
            + ",'" + ServerTool.escapeString(item.getAuthSystemPs()) + "'"
        ;
        return ret;
    }
}
