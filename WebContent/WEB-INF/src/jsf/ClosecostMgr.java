package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClosecostMgr extends Manager
{
    private static ClosecostMgr _instance = null;

    ClosecostMgr() {}

    public synchronized static ClosecostMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClosecostMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "closecost";
    }

    protected Object makeBean()
    {
        return new Closecost();
    }

    protected int getBeanId(Object obj)
    {
        return ((Closecost)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Closecost item = (Closecost) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	closecostMonth		 = rs.getTimestamp("closecostMonth");
            int	closecostType		 = rs.getInt("closecostType");
            int	closecostStatus		 = rs.getInt("closecostStatus");
            int	closecostCbId		 = rs.getInt("closecostCbId");
            int	closecostCbCheckId		 = rs.getInt("closecostCbCheckId");
            int	closecostNum		 = rs.getInt("closecostNum");

            item
            .init(id, created, modified
            , closecostMonth, closecostType, closecostStatus
            , closecostCbId, closecostCbCheckId, closecostNum
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
        Closecost item = (Closecost) obj;

        String ret = "modified=NOW()"
            + ",closecostMonth=" + (((d=item.getClosecostMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closecostType=" + item.getClosecostType()
            + ",closecostStatus=" + item.getClosecostStatus()
            + ",closecostCbId=" + item.getClosecostCbId()
            + ",closecostCbCheckId=" + item.getClosecostCbCheckId()
            + ",closecostNum=" + item.getClosecostNum()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, closecostMonth, closecostType, closecostStatus, closecostCbId, closecostCbCheckId, closecostNum";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Closecost item = (Closecost) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getClosecostMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosecostType()
            + "," + item.getClosecostStatus()
            + "," + item.getClosecostCbId()
            + "," + item.getClosecostCbCheckId()
            + "," + item.getClosecostNum()
        ;
        return ret;
    }
}
