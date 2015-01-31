package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class FeenumberMgr extends Manager
{
    private static FeenumberMgr _instance = null;

    FeenumberMgr() {}

    public synchronized static FeenumberMgr getInstance()
    {
        if (_instance==null) {
            _instance = new FeenumberMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "feenumber";
    }

    protected Object makeBean()
    {
        return new Feenumber();
    }

    protected int getBeanId(Object obj)
    {
        return ((Feenumber)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Feenumber item = (Feenumber) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	feenumberDate		 = rs.getTimestamp("feenumberDate");
            int	feenumberTotal		 = rs.getInt("feenumberTotal");

            item
            .init(id, created, modified
            , feenumberDate, feenumberTotal);
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
        Feenumber item = (Feenumber) obj;

        String ret = "modified=NOW()"
            + ",feenumberDate=" + (((d=item.getFeenumberDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",feenumberTotal=" + item.getFeenumberTotal()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, feenumberDate, feenumberTotal";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Feenumber item = (Feenumber) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getFeenumberDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getFeenumberTotal()
        ;
        return ret;
    }
}
