package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CostMgr extends Manager
{
    private static CostMgr _instance = null;

    CostMgr() {}

    public synchronized static CostMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CostMgr();
        }
        return _instance;
    }

    public CostMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cost";
    }

    protected Object makeBean()
    {
        return new Cost();
    }

    protected int getBeanId(Object obj)
    {
        return ((Cost)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Cost item = (Cost) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	costAccountDate		 = rs.getTimestamp("costAccountDate");
            int	costOutIn		 = rs.getInt("costOutIn");
            String	costName		 = rs.getString("costName");
            int	costMoney		 = rs.getInt("costMoney");
            int	costLogId		 = rs.getInt("costLogId");
            int	costBigItem		 = rs.getInt("costBigItem");
            int	costSmallItem		 = rs.getInt("costSmallItem");
            int	costCostbookId		 = rs.getInt("costCostbookId");
            int	costCostCheckId		 = rs.getInt("costCostCheckId");
            String	costPs		 = rs.getString("costPs");

            item
            .init(id, created, modified
            , costAccountDate, costOutIn, costName
            , costMoney, costLogId, costBigItem
            , costSmallItem, costCostbookId, costCostCheckId
            , costPs);
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
        Cost item = (Cost) obj;

        String ret = "modified=NOW()"
            + ",costAccountDate=" + (((d=item.getCostAccountDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costOutIn=" + item.getCostOutIn()
            + ",costName='" + ServerTool.escapeString(item.getCostName()) + "'"
            + ",costMoney=" + item.getCostMoney()
            + ",costLogId=" + item.getCostLogId()
            + ",costBigItem=" + item.getCostBigItem()
            + ",costSmallItem=" + item.getCostSmallItem()
            + ",costCostbookId=" + item.getCostCostbookId()
            + ",costCostCheckId=" + item.getCostCostCheckId()
            + ",costPs='" + ServerTool.escapeString(item.getCostPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, costAccountDate, costOutIn, costName, costMoney, costLogId, costBigItem, costSmallItem, costCostbookId, costCostCheckId, costPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Cost item = (Cost) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getCostAccountDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCostOutIn()
            + ",'" + ServerTool.escapeString(item.getCostName()) + "'"
            + "," + item.getCostMoney()
            + "," + item.getCostLogId()
            + "," + item.getCostBigItem()
            + "," + item.getCostSmallItem()
            + "," + item.getCostCostbookId()
            + "," + item.getCostCostCheckId()
            + ",'" + ServerTool.escapeString(item.getCostPs()) + "'"
        ;
        return ret;
    }
}
