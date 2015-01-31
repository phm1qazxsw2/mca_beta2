package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BigItemMgr extends Manager
{
    private static BigItemMgr _instance = null;

    BigItemMgr() {}

    public synchronized static BigItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BigItemMgr();
        }
        return _instance;
    }

    public BigItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bigitem";
    }

    protected Object makeBean()
    {
        return new BigItem();
    }

    protected int getBeanId(Object obj)
    {
        return ((BigItem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BigItem item = (BigItem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	acctCode		 = rs.getString("acctCode");
            String	bigItemName		 = rs.getString("bigItemName");
            int	bigItemActive		 = rs.getInt("bigItemActive");

            item
            .init(id, created, modified
            , acctCode, bigItemName, bigItemActive
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
        BigItem item = (BigItem) obj;

        String ret = "modified=NOW()"
            + ",acctCode='" + ServerTool.escapeString(item.getAcctCode()) + "'"
            + ",bigItemName='" + ServerTool.escapeString(item.getBigItemName()) + "'"
            + ",bigItemActive=" + item.getBigItemActive()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, acctCode, bigItemName, bigItemActive";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BigItem item = (BigItem) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getAcctCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getBigItemName()) + "'"
            + "," + item.getBigItemActive()
        ;
        return ret;
    }
}
