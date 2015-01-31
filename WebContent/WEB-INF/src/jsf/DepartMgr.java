package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DepartMgr extends Manager
{
    private static DepartMgr _instance = null;

    DepartMgr() {}

    public synchronized static DepartMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DepartMgr();
        }
        return _instance;
    }

    public DepartMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "depart";
    }

    protected Object makeBean()
    {
        return new Depart();
    }

    protected int getBeanId(Object obj)
    {
        return ((Depart)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Depart item = (Depart) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	departName		 = rs.getString("departName");
            int	departActive		 = rs.getInt("departActive");

            item
            .init(id, created, modified
            , departName, departActive);
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
        Depart item = (Depart) obj;

        String ret = "modified=NOW()"
            + ",departName='" + ServerTool.escapeString(item.getDepartName()) + "'"
            + ",departActive=" + item.getDepartActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, departName, departActive";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Depart item = (Depart) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getDepartName()) + "'"
            + "," + item.getDepartActive()
        ;
        return ret;
    }
}
