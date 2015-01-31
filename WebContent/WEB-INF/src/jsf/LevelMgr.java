package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class LevelMgr extends Manager
{
    private static LevelMgr _instance = null;

    LevelMgr() {}

    public synchronized static LevelMgr getInstance()
    {
        if (_instance==null) {
            _instance = new LevelMgr();
        }
        return _instance;
    }

    public LevelMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "level";
    }

    protected Object makeBean()
    {
        return new Level();
    }

    protected int getBeanId(Object obj)
    {
        return ((Level)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Level item = (Level) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	levelName		 = rs.getString("levelName");
            int	levelActive		 = rs.getInt("levelActive");

            item
            .init(id, created, modified
            , levelName, levelActive);
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
        Level item = (Level) obj;

        String ret = "modified=NOW()"
            + ",levelName='" + ServerTool.escapeString(item.getLevelName()) + "'"
            + ",levelActive=" + item.getLevelActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, levelName, levelActive";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Level item = (Level) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getLevelName()) + "'"
            + "," + item.getLevelActive()
        ;
        return ret;
    }
}
