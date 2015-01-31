package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TradeaccountMgr extends Manager
{
    private static TradeaccountMgr _instance = null;

    TradeaccountMgr() {}

    public synchronized static TradeaccountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TradeaccountMgr();
        }
        return _instance;
    }

    public TradeaccountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "tradeaccount";
    }

    protected Object makeBean()
    {
        return new Tradeaccount();
    }

    protected int getBeanId(Object obj)
    {
        return ((Tradeaccount)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Tradeaccount item = (Tradeaccount) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	TradeaccountName		 = rs.getString("TradeaccountName");
            int	TradeaccountActive		 = rs.getInt("TradeaccountActive");
            int	TradeaccountUserId		 = rs.getInt("TradeaccountUserId");
            int	TradeaccountAuth		 = rs.getInt("TradeaccountAuth");
            int	tradeAccountOrder		 = rs.getInt("tradeAccountOrder");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , TradeaccountName, TradeaccountActive, TradeaccountUserId
            , TradeaccountAuth, tradeAccountOrder, bunitId
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
        Tradeaccount item = (Tradeaccount) obj;

        String ret = "modified=NOW()"
            + ",TradeaccountName='" + ServerTool.escapeString(item.getTradeaccountName()) + "'"
            + ",TradeaccountActive=" + item.getTradeaccountActive()
            + ",TradeaccountUserId=" + item.getTradeaccountUserId()
            + ",TradeaccountAuth=" + item.getTradeaccountAuth()
            + ",tradeAccountOrder=" + item.getTradeAccountOrder()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, TradeaccountName, TradeaccountActive, TradeaccountUserId, TradeaccountAuth, tradeAccountOrder, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Tradeaccount item = (Tradeaccount) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getTradeaccountName()) + "'"
            + "," + item.getTradeaccountActive()
            + "," + item.getTradeaccountUserId()
            + "," + item.getTradeaccountAuth()
            + "," + item.getTradeAccountOrder()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
