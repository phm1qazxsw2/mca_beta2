package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BanknumberMgr extends Manager
{
    private static BanknumberMgr _instance = null;

    BanknumberMgr() {}

    public synchronized static BanknumberMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BanknumberMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "banknumber";
    }

    protected Object makeBean()
    {
        return new Banknumber();
    }

    protected int getBeanId(Object obj)
    {
        return ((Banknumber)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Banknumber item = (Banknumber) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	banknumberDate		 = rs.getTimestamp("banknumberDate");
            int	banknumberTotal		 = rs.getInt("banknumberTotal");

            item
            .init(id, created, modified
            , banknumberDate, banknumberTotal);
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
        Banknumber item = (Banknumber) obj;

        String ret = "modified=NOW()"
            + ",banknumberDate=" + (((d=item.getBanknumberDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",banknumberTotal=" + item.getBanknumberTotal()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, banknumberDate, banknumberTotal";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Banknumber item = (Banknumber) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getBanknumberDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getBanknumberTotal()
        ;
        return ret;
    }
}
