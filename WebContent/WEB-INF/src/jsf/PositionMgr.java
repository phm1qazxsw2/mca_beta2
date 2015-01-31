package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PositionMgr extends Manager
{
    private static PositionMgr _instance = null;

    PositionMgr() {}

    public synchronized static PositionMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PositionMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "position";
    }

    protected Object makeBean()
    {
        return new Position();
    }

    protected int getBeanId(Object obj)
    {
        return ((Position)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Position item = (Position) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	PositionName		 = rs.getString("PositionName");
            int	PositionActive		 = rs.getInt("PositionActive");
            int	PositionPriority		 = rs.getInt("PositionPriority");

            item
            .init(id, created, modified
            , PositionName, PositionActive, PositionPriority
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
        Position item = (Position) obj;

        String ret = "modified=NOW()"
            + ",PositionName='" + ServerTool.escapeString(item.getPositionName()) + "'"
            + ",PositionActive=" + item.getPositionActive()
            + ",PositionPriority=" + item.getPositionPriority()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, PositionName, PositionActive, PositionPriority";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Position item = (Position) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getPositionName()) + "'"
            + "," + item.getPositionActive()
            + "," + item.getPositionPriority()
        ;
        return ret;
    }
}
