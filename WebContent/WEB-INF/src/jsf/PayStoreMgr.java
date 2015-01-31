package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PayStoreMgr extends Manager
{
    private static PayStoreMgr _instance = null;

    PayStoreMgr() {}

    public synchronized static PayStoreMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PayStoreMgr();
        }
        return _instance;
    }

    public PayStoreMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "paystore";
    }

    protected Object makeBean()
    {
        return new PayStore();
    }

    protected int getBeanId(Object obj)
    {
        return ((PayStore)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PayStore item = (PayStore) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	payStoreUpdateDate		 = rs.getTimestamp("payStoreUpdateDate");
            java.util.Date	payStorePayDate		 = rs.getTimestamp("payStorePayDate");
            int	payStoreFeeticketId		 = rs.getInt("payStoreFeeticketId");
            int	payStorePayMoney		 = rs.getInt("payStorePayMoney");
            java.util.Date	payStoreMonth		 = rs.getTimestamp("payStoreMonth");
            String	payStoreId		 = rs.getString("payStoreId");
            String	payStoreAccountId		 = rs.getString("payStoreAccountId");
            String	payStoreSource		 = rs.getString("payStoreSource");
            int	payStoreStatus		 = rs.getInt("payStoreStatus");
            String	payStorePs		 = rs.getString("payStorePs");
            String	payStoreException		 = rs.getString("payStoreException");

            item
            .init(id, created, modified
            , payStoreUpdateDate, payStorePayDate, payStoreFeeticketId
            , payStorePayMoney, payStoreMonth, payStoreId
            , payStoreAccountId, payStoreSource, payStoreStatus
            , payStorePs, payStoreException);
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
        PayStore item = (PayStore) obj;

        String ret = "modified=NOW()"
            + ",payStoreUpdateDate=" + (((d=item.getPayStoreUpdateDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payStorePayDate=" + (((d=item.getPayStorePayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payStoreFeeticketId=" + item.getPayStoreFeeticketId()
            + ",payStorePayMoney=" + item.getPayStorePayMoney()
            + ",payStoreMonth=" + (((d=item.getPayStoreMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",payStoreId='" + ServerTool.escapeString(item.getPayStoreId()) + "'"
            + ",payStoreAccountId='" + ServerTool.escapeString(item.getPayStoreAccountId()) + "'"
            + ",payStoreSource='" + ServerTool.escapeString(item.getPayStoreSource()) + "'"
            + ",payStoreStatus=" + item.getPayStoreStatus()
            + ",payStorePs='" + ServerTool.escapeString(item.getPayStorePs()) + "'"
            + ",payStoreException='" + ServerTool.escapeString(item.getPayStoreException()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, payStoreUpdateDate, payStorePayDate, payStoreFeeticketId, payStorePayMoney, payStoreMonth, payStoreId, payStoreAccountId, payStoreSource, payStoreStatus, payStorePs, payStoreException";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        PayStore item = (PayStore) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getPayStoreUpdateDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getPayStorePayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getPayStoreFeeticketId()
            + "," + item.getPayStorePayMoney()
            + "," + (((d=item.getPayStoreMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getPayStoreId()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayStoreAccountId()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayStoreSource()) + "'"
            + "," + item.getPayStoreStatus()
            + ",'" + ServerTool.escapeString(item.getPayStorePs()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayStoreException()) + "'"
        ;
        return ret;
    }
}
