package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class OwnerMgr extends Manager
{
    private static OwnerMgr _instance = null;

    OwnerMgr() {}

    public synchronized static OwnerMgr getInstance()
    {
        if (_instance==null) {
            _instance = new OwnerMgr();
        }
        return _instance;
    }

    public OwnerMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "owner";
    }

    protected Object makeBean()
    {
        return new Owner();
    }

    protected int getBeanId(Object obj)
    {
        return ((Owner)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Owner item = (Owner) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	ownerName		 = rs.getString("ownerName");
            String	ownerPs		 = rs.getString("ownerPs");
            int	ownerStatus		 = rs.getInt("ownerStatus");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , ownerName, ownerPs, ownerStatus
            , bunitId);
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
        Owner item = (Owner) obj;

        String ret = "modified=NOW()"
            + ",ownerName='" + ServerTool.escapeString(item.getOwnerName()) + "'"
            + ",ownerPs='" + ServerTool.escapeString(item.getOwnerPs()) + "'"
            + ",ownerStatus=" + item.getOwnerStatus()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, ownerName, ownerPs, ownerStatus, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Owner item = (Owner) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getOwnerName()) + "'"
            + ",'" + ServerTool.escapeString(item.getOwnerPs()) + "'"
            + "," + item.getOwnerStatus()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
