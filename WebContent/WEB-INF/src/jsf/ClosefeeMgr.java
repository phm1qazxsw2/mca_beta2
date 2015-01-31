package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClosefeeMgr extends Manager
{
    private static ClosefeeMgr _instance = null;

    ClosefeeMgr() {}

    public synchronized static ClosefeeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClosefeeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "closefee";
    }

    protected Object makeBean()
    {
        return new Closefee();
    }

    protected int getBeanId(Object obj)
    {
        return ((Closefee)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Closefee item = (Closefee) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	closefeeMonth		 = rs.getTimestamp("closefeeMonth");
            int	closefeeType		 = rs.getInt("closefeeType");
            int	closefeeStatus		 = rs.getInt("closefeeStatus");
            int	closefeeFtId		 = rs.getInt("closefeeFtId");
            int	closefeeFeenumberId		 = rs.getInt("closefeeFeenumberId");
            int	closefeeNum		 = rs.getInt("closefeeNum");

            item
            .init(id, created, modified
            , closefeeMonth, closefeeType, closefeeStatus
            , closefeeFtId, closefeeFeenumberId, closefeeNum
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
        Closefee item = (Closefee) obj;

        String ret = "modified=NOW()"
            + ",closefeeMonth=" + (((d=item.getClosefeeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closefeeType=" + item.getClosefeeType()
            + ",closefeeStatus=" + item.getClosefeeStatus()
            + ",closefeeFtId=" + item.getClosefeeFtId()
            + ",closefeeFeenumberId=" + item.getClosefeeFeenumberId()
            + ",closefeeNum=" + item.getClosefeeNum()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, closefeeMonth, closefeeType, closefeeStatus, closefeeFtId, closefeeFeenumberId, closefeeNum";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Closefee item = (Closefee) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getClosefeeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosefeeType()
            + "," + item.getClosefeeStatus()
            + "," + item.getClosefeeFtId()
            + "," + item.getClosefeeFeenumberId()
            + "," + item.getClosefeeNum()
        ;
        return ret;
    }
}
