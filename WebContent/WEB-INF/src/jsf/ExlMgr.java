package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ExlMgr extends Manager
{
    private static ExlMgr _instance = null;

    ExlMgr() {}

    public synchronized static ExlMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ExlMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "exl";
    }

    protected Object makeBean()
    {
        return new Exl();
    }

    protected int getBeanId(Object obj)
    {
        return ((Exl)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Exl item = (Exl) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	exlFileName		 = rs.getString("exlFileName");
            String	exlTitle		 = rs.getString("exlTitle");
            int	exlType		 = rs.getInt("exlType");
            String	exlPs		 = rs.getString("exlPs");

            item
            .init(id, created, modified
            , exlFileName, exlTitle, exlType
            , exlPs);
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
        Exl item = (Exl) obj;

        String ret = "modified=NOW()"
            + ",exlFileName='" + ServerTool.escapeString(item.getExlFileName()) + "'"
            + ",exlTitle='" + ServerTool.escapeString(item.getExlTitle()) + "'"
            + ",exlType=" + item.getExlType()
            + ",exlPs='" + ServerTool.escapeString(item.getExlPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, exlFileName, exlTitle, exlType, exlPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Exl item = (Exl) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getExlFileName()) + "'"
            + ",'" + ServerTool.escapeString(item.getExlTitle()) + "'"
            + "," + item.getExlType()
            + ",'" + ServerTool.escapeString(item.getExlPs()) + "'"
        ;
        return ret;
    }
}
