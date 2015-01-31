package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CmxLogMgr extends Manager
{
    private static CmxLogMgr _instance = null;

    CmxLogMgr() {}

    public synchronized static CmxLogMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CmxLogMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "cmxlog";
    }

    protected Object makeBean()
    {
        return new CmxLog();
    }

    protected int getBeanId(Object obj)
    {
        return ((CmxLog)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CmxLog item = (CmxLog) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	cmxLogCategory		 = rs.getInt("cmxLogCategory");
            int	cmxLogCMid		 = rs.getInt("cmxLogCMid");
            int	cmxLogXId		 = rs.getInt("cmxLogXId");
            int	cmxLogYId		 = rs.getInt("cmxLogYId");
            int	cmxLogActive		 = rs.getInt("cmxLogActive");

            item
            .init(id, created, modified
            , cmxLogCategory, cmxLogCMid, cmxLogXId
            , cmxLogYId, cmxLogActive);
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
        CmxLog item = (CmxLog) obj;

        String ret = "modified=NOW()"
            + ",cmxLogCategory=" + item.getCmxLogCategory()
            + ",cmxLogCMid=" + item.getCmxLogCMid()
            + ",cmxLogXId=" + item.getCmxLogXId()
            + ",cmxLogYId=" + item.getCmxLogYId()
            + ",cmxLogActive=" + item.getCmxLogActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, cmxLogCategory, cmxLogCMid, cmxLogXId, cmxLogYId, cmxLogActive";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        CmxLog item = (CmxLog) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getCmxLogCategory()
            + "," + item.getCmxLogCMid()
            + "," + item.getCmxLogXId()
            + "," + item.getCmxLogYId()
            + "," + item.getCmxLogActive()
        ;
        return ret;
    }
}
