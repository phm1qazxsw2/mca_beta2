package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SanumberMgr extends Manager
{
    private static SanumberMgr _instance = null;

    SanumberMgr() {}

    public synchronized static SanumberMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SanumberMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "sanumber";
    }

    protected Object makeBean()
    {
        return new Sanumber();
    }

    protected int getBeanId(Object obj)
    {
        return ((Sanumber)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Sanumber item = (Sanumber) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	sanumberDate		 = rs.getTimestamp("sanumberDate");
            int	sanumberTotal		 = rs.getInt("sanumberTotal");

            item
            .init(id, created, modified
            , sanumberDate, sanumberTotal);
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
        Sanumber item = (Sanumber) obj;

        String ret = "modified=NOW()"
            + ",sanumberDate=" + (((d=item.getSanumberDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",sanumberTotal=" + item.getSanumberTotal()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, sanumberDate, sanumberTotal";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Sanumber item = (Sanumber) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getSanumberDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSanumberTotal()
        ;
        return ret;
    }
}
