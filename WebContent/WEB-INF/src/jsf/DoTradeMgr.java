package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DoTradeMgr extends Manager
{
    private static DoTradeMgr _instance = null;

    DoTradeMgr() {}

    public synchronized static DoTradeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DoTradeMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "dotrade";
    }

    protected Object makeBean()
    {
        return new DoTrade();
    }

    protected int getBeanId(Object obj)
    {
        return ((DoTrade)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        DoTrade item = (DoTrade) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	doTradedDate		 = rs.getTimestamp("doTradedDate");
            int	doTradeClientAccountId		 = rs.getInt("doTradeClientAccountId");
            int	doTradeCostpayId		 = rs.getInt("doTradeCostpayId");
            int	doTradeUserId		 = rs.getInt("doTradeUserId");
            int	doTradeStatus		 = rs.getInt("doTradeStatus");
            int	doTradeFromAccountType		 = rs.getInt("doTradeFromAccountType");
            int	doTradeFromAccountId		 = rs.getInt("doTradeFromAccountId");

            item
            .init(id, created, modified
            , doTradedDate, doTradeClientAccountId, doTradeCostpayId
            , doTradeUserId, doTradeStatus, doTradeFromAccountType
            , doTradeFromAccountId);
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
        DoTrade item = (DoTrade) obj;

        String ret = "modified=NOW()"
            + ",doTradedDate=" + (((d=item.getDoTradedDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",doTradeClientAccountId=" + item.getDoTradeClientAccountId()
            + ",doTradeCostpayId=" + item.getDoTradeCostpayId()
            + ",doTradeUserId=" + item.getDoTradeUserId()
            + ",doTradeStatus=" + item.getDoTradeStatus()
            + ",doTradeFromAccountType=" + item.getDoTradeFromAccountType()
            + ",doTradeFromAccountId=" + item.getDoTradeFromAccountId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, doTradedDate, doTradeClientAccountId, doTradeCostpayId, doTradeUserId, doTradeStatus, doTradeFromAccountType, doTradeFromAccountId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        DoTrade item = (DoTrade) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getDoTradedDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getDoTradeClientAccountId()
            + "," + item.getDoTradeCostpayId()
            + "," + item.getDoTradeUserId()
            + "," + item.getDoTradeStatus()
            + "," + item.getDoTradeFromAccountType()
            + "," + item.getDoTradeFromAccountId()
        ;
        return ret;
    }
}
