package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClsGroupMgr extends Manager
{
    private static ClsGroupMgr _instance = null;

    ClsGroupMgr() {}

    public synchronized static ClsGroupMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClsGroupMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "clsgroup";
    }

    protected Object makeBean()
    {
        return new ClsGroup();
    }

    protected int getBeanId(Object obj)
    {
        return ((ClsGroup)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ClsGroup item = (ClsGroup) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	classId		 = rs.getInt("classId");
            String	name		 = rs.getString("name");
            int	active		 = rs.getInt("active");

            item
            .init(id, created, modified
            , classId, name, active
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
        ClsGroup item = (ClsGroup) obj;

        String ret = "modified=NOW()"
            + ",classId=" + item.getClassId()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",active=" + item.getActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, classId, name, active";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ClsGroup item = (ClsGroup) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getClassId()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getActive()
        ;
        return ret;
    }
}
