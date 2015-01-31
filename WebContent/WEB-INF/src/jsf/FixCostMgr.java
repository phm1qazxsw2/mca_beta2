package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class FixCostMgr extends Manager
{
    private static FixCostMgr _instance = null;

    FixCostMgr() {}

    public synchronized static FixCostMgr getInstance()
    {
        if (_instance==null) {
            _instance = new FixCostMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "fixcost";
    }

    protected Object makeBean()
    {
        return new FixCost();
    }

    protected int getBeanId(Object obj)
    {
        return ((FixCost)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        FixCost item = (FixCost) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	fixCostCostId		 = rs.getInt("fixCostCostId");
            int	fixCostUserid		 = rs.getInt("fixCostUserid");
            int	fixCostActive		 = rs.getInt("fixCostActive");
            int	fixCostLastUserid		 = rs.getInt("fixCostLastUserid");
            java.util.Date	fixCostLastDate		 = rs.getTimestamp("fixCostLastDate");
            String	fixCostLastTitle		 = rs.getString("fixCostLastTitle");
            int	fixCostLastId		 = rs.getInt("fixCostLastId");

            item
            .init(id, created, modified
            , fixCostCostId, fixCostUserid, fixCostActive
            , fixCostLastUserid, fixCostLastDate, fixCostLastTitle
            , fixCostLastId);
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
        FixCost item = (FixCost) obj;

        String ret = "modified=NOW()"
            + ",fixCostCostId=" + item.getFixCostCostId()
            + ",fixCostUserid=" + item.getFixCostUserid()
            + ",fixCostActive=" + item.getFixCostActive()
            + ",fixCostLastUserid=" + item.getFixCostLastUserid()
            + ",fixCostLastDate=" + (((d=item.getFixCostLastDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",fixCostLastTitle='" + ServerTool.escapeString(item.getFixCostLastTitle()) + "'"
            + ",fixCostLastId=" + item.getFixCostLastId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, fixCostCostId, fixCostUserid, fixCostActive, fixCostLastUserid, fixCostLastDate, fixCostLastTitle, fixCostLastId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        FixCost item = (FixCost) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getFixCostCostId()
            + "," + item.getFixCostUserid()
            + "," + item.getFixCostActive()
            + "," + item.getFixCostLastUserid()
            + "," + (((d=item.getFixCostLastDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getFixCostLastTitle()) + "'"
            + "," + item.getFixCostLastId()
        ;
        return ret;
    }
}
