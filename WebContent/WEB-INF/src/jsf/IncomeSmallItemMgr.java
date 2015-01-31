package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class IncomeSmallItemMgr extends Manager
{
    private static IncomeSmallItemMgr _instance = null;

    IncomeSmallItemMgr() {}

    public synchronized static IncomeSmallItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new IncomeSmallItemMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "incomesmallitem";
    }

    protected Object makeBean()
    {
        return new IncomeSmallItem();
    }

    protected int getBeanId(Object obj)
    {
        return ((IncomeSmallItem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        IncomeSmallItem item = (IncomeSmallItem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	incomeSmallItemName		 = rs.getString("incomeSmallItemName");
            int	incomeSmallItemActive		 = rs.getInt("incomeSmallItemActive");
            int	incomeSmallItemIncomeBigItemId		 = rs.getInt("incomeSmallItemIncomeBigItemId");

            item
            .init(id, created, modified
            , incomeSmallItemName, incomeSmallItemActive, incomeSmallItemIncomeBigItemId
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
        IncomeSmallItem item = (IncomeSmallItem) obj;

        String ret = "modified=NOW()"
            + ",incomeSmallItemName='" + ServerTool.escapeString(item.getIncomeSmallItemName()) + "'"
            + ",incomeSmallItemActive=" + item.getIncomeSmallItemActive()
            + ",incomeSmallItemIncomeBigItemId=" + item.getIncomeSmallItemIncomeBigItemId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, incomeSmallItemName, incomeSmallItemActive, incomeSmallItemIncomeBigItemId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        IncomeSmallItem item = (IncomeSmallItem) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getIncomeSmallItemName()) + "'"
            + "," + item.getIncomeSmallItemActive()
            + "," + item.getIncomeSmallItemIncomeBigItemId()
        ;
        return ret;
    }
}
