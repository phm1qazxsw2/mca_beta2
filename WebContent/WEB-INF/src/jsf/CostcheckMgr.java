package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CostcheckMgr extends Manager
{
    private static CostcheckMgr _instance = null;

    CostcheckMgr() {}

    public synchronized static CostcheckMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CostcheckMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "costcheck";
    }

    protected Object makeBean()
    {
        return new Costcheck();
    }

    protected int getBeanId(Object obj)
    {
        return ((Costcheck)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costcheck item = (Costcheck) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	CostcheckDate		 = rs.getTimestamp("CostcheckDate");
            int	CostcheckTotal		 = rs.getInt("CostcheckTotal");

            item
            .init(id, created, modified
            , CostcheckDate, CostcheckTotal);
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
        Costcheck item = (Costcheck) obj;

        String ret = "modified=NOW()"
            + ",CostcheckDate=" + (((d=item.getCostcheckDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",CostcheckTotal=" + item.getCostcheckTotal()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, CostcheckDate, CostcheckTotal";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costcheck item = (Costcheck) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getCostcheckDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCostcheckTotal()
        ;
        return ret;
    }
}
