package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class IncomeBigItemMgr extends Manager
{
    private static IncomeBigItemMgr _instance = null;

    IncomeBigItemMgr() {}

    public synchronized static IncomeBigItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new IncomeBigItemMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "incomebigitem";
    }

    protected Object makeBean()
    {
        return new IncomeBigItem();
    }

    protected int getBeanId(Object obj)
    {
        return ((IncomeBigItem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        IncomeBigItem item = (IncomeBigItem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	incomeBigItemName		 = rs.getString("incomeBigItemName");
            int	incomeBigItemActive		 = rs.getInt("incomeBigItemActive");

            item
            .init(id, created, modified
            , incomeBigItemName, incomeBigItemActive);
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
        IncomeBigItem item = (IncomeBigItem) obj;

        String ret = "modified=NOW()"
            + ",incomeBigItemName='" + ServerTool.escapeString(item.getIncomeBigItemName()) + "'"
            + ",incomeBigItemActive=" + item.getIncomeBigItemActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, incomeBigItemName, incomeBigItemActive";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        IncomeBigItem item = (IncomeBigItem) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getIncomeBigItemName()) + "'"
            + "," + item.getIncomeBigItemActive()
        ;
        return ret;
    }
}
