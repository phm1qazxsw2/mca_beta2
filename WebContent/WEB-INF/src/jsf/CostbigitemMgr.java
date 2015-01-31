package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CostbigitemMgr extends Manager
{
    private static CostbigitemMgr _instance = null;

    CostbigitemMgr() {}

    public synchronized static CostbigitemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CostbigitemMgr();
        }
        return _instance;
    }

    public CostbigitemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costbigitem";
    }

    protected Object makeBean()
    {
        return new Costbigitem();
    }

    protected int getBeanId(Object obj)
    {
        return ((Costbigitem)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costbigitem item = (Costbigitem) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	costtradeId		 = rs.getInt("costtradeId");
            int	bigitemId		 = rs.getInt("bigitemId");

            item
            .init(id, created, modified
            , costtradeId, bigitemId);
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
        Costbigitem item = (Costbigitem) obj;

        String ret = "modified=NOW()"
            + ",costtradeId=" + item.getCosttradeId()
            + ",bigitemId=" + item.getBigitemId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, costtradeId, bigitemId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costbigitem item = (Costbigitem) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getCosttradeId()
            + "," + item.getBigitemId()
        ;
        return ret;
    }
}
