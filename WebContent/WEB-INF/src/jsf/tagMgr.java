package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class tagMgr extends Manager
{
    private static tagMgr _instance = null;

    tagMgr() {}

    public synchronized static tagMgr getInstance()
    {
        if (_instance==null) {
            _instance = new tagMgr();
        }
        return _instance;
    }

    public tagMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tag";
    }

    protected Object makeBean()
    {
        return new tag();
    }

    protected int getBeanId(Object obj)
    {
        return ((tag)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        tag item = (tag) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	name		 = rs.getString("name");

            item
            .init(id, created, modified
            , name);
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
        tag item = (tag) obj;

        String ret = "modified=NOW()"
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, name";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        tag item = (tag) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
        ;
        return ret;
    }
}
