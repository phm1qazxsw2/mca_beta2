package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CloseincomeMgr extends Manager
{
    private static CloseincomeMgr _instance = null;

    CloseincomeMgr() {}

    public synchronized static CloseincomeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CloseincomeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "closeincome";
    }

    protected Object makeBean()
    {
        return new Closeincome();
    }

    protected int getBeanId(Object obj)
    {
        return ((Closeincome)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Closeincome item = (Closeincome) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	closeincomeMonth		 = rs.getTimestamp("closeincomeMonth");
            int	closeincomeType		 = rs.getInt("closeincomeType");
            int	closeincomeStatus		 = rs.getInt("closeincomeStatus");
            int	closeincomeCbId		 = rs.getInt("closeincomeCbId");
            int	closeincomeCbCheckId		 = rs.getInt("closeincomeCbCheckId");
            int	closeincomeNum		 = rs.getInt("closeincomeNum");

            item
            .init(id, created, modified
            , closeincomeMonth, closeincomeType, closeincomeStatus
            , closeincomeCbId, closeincomeCbCheckId, closeincomeNum
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
        Closeincome item = (Closeincome) obj;

        String ret = "modified=NOW()"
            + ",closeincomeMonth=" + (((d=item.getCloseincomeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closeincomeType=" + item.getCloseincomeType()
            + ",closeincomeStatus=" + item.getCloseincomeStatus()
            + ",closeincomeCbId=" + item.getCloseincomeCbId()
            + ",closeincomeCbCheckId=" + item.getCloseincomeCbCheckId()
            + ",closeincomeNum=" + item.getCloseincomeNum()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, closeincomeMonth, closeincomeType, closeincomeStatus, closeincomeCbId, closeincomeCbCheckId, closeincomeNum";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Closeincome item = (Closeincome) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getCloseincomeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCloseincomeType()
            + "," + item.getCloseincomeStatus()
            + "," + item.getCloseincomeCbId()
            + "," + item.getCloseincomeCbCheckId()
            + "," + item.getCloseincomeNum()
        ;
        return ret;
    }
}
