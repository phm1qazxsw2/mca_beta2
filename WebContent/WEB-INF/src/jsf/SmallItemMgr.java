package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SmallItemMgr extends Manager
{
    private static SmallItemMgr _instance = null;

    SmallItemMgr() {}

    public synchronized static SmallItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SmallItemMgr();
        }
        return _instance;
    }

    public SmallItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "smallitem";
    }

    protected Object makeBean()
    {
        return new SmallItem();
    }

    protected int getBeanId(Object obj)
    {
        return ((SmallItem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SmallItem item = (SmallItem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	acctCode		 = rs.getString("acctCode");
            String	smallItemName		 = rs.getString("smallItemName");
            int	smallItemActive		 = rs.getInt("smallItemActive");
            int	smallItemBigItemId		 = rs.getInt("smallItemBigItemId");

            item
            .init(id, created, modified
            , acctCode, smallItemName, smallItemActive
            , smallItemBigItemId);
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
        SmallItem item = (SmallItem) obj;

        String ret = "modified=NOW()"
            + ",acctCode='" + ServerTool.escapeString(item.getAcctCode()) + "'"
            + ",smallItemName='" + ServerTool.escapeString(item.getSmallItemName()) + "'"
            + ",smallItemActive=" + item.getSmallItemActive()
            + ",smallItemBigItemId=" + item.getSmallItemBigItemId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, acctCode, smallItemName, smallItemActive, smallItemBigItemId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SmallItem item = (SmallItem) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getAcctCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getSmallItemName()) + "'"
            + "," + item.getSmallItemActive()
            + "," + item.getSmallItemBigItemId()
        ;
        return ret;
    }
}
