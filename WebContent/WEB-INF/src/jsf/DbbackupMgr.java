package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DbbackupMgr extends Manager
{
    private static DbbackupMgr _instance = null;

    DbbackupMgr() {}

    public synchronized static DbbackupMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DbbackupMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "dbbackup";
    }

    protected Object makeBean()
    {
        return new Dbbackup();
    }

    protected int getBeanId(Object obj)
    {
        return ((Dbbackup)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Dbbackup item = (Dbbackup) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	dbbackupPs		 = rs.getString("dbbackupPs");
            int	dbbackupUserId		 = rs.getInt("dbbackupUserId");
            String	dbbackupFilePath		 = rs.getString("dbbackupFilePath");
            String	dbbackupFileName		 = rs.getString("dbbackupFileName");

            item
            .init(id, created, modified
            , dbbackupPs, dbbackupUserId, dbbackupFilePath
            , dbbackupFileName);
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
        Dbbackup item = (Dbbackup) obj;

        String ret = "modified=NOW()"
            + ",dbbackupPs='" + ServerTool.escapeString(item.getDbbackupPs()) + "'"
            + ",dbbackupUserId=" + item.getDbbackupUserId()
            + ",dbbackupFilePath='" + ServerTool.escapeString(item.getDbbackupFilePath()) + "'"
            + ",dbbackupFileName='" + ServerTool.escapeString(item.getDbbackupFileName()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, dbbackupPs, dbbackupUserId, dbbackupFilePath, dbbackupFileName";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Dbbackup item = (Dbbackup) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getDbbackupPs()) + "'"
            + "," + item.getDbbackupUserId()
            + ",'" + ServerTool.escapeString(item.getDbbackupFilePath()) + "'"
            + ",'" + ServerTool.escapeString(item.getDbbackupFileName()) + "'"
        ;
        return ret;
    }
}
