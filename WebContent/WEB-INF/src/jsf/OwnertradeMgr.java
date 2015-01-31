package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class OwnertradeMgr extends Manager
{
    private static OwnertradeMgr _instance = null;

    OwnertradeMgr() {}

    public synchronized static OwnertradeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new OwnertradeMgr();
        }
        return _instance;
    }

    public OwnertradeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "ownertrade";
    }

    protected Object makeBean()
    {
        return new Ownertrade();
    }

    protected int getBeanId(Object obj)
    {
        return ((Ownertrade)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Ownertrade item = (Ownertrade) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	ownertradeOwnerId		 = rs.getInt("ownertradeOwnerId");
            int	ownertradeInOut		 = rs.getInt("ownertradeInOut");
            int	ownertradeNumber		 = rs.getInt("ownertradeNumber");
            int	ownertradeWay		 = rs.getInt("ownertradeWay");
            java.util.Date	ownertradeAccountDate		 = rs.getTimestamp("ownertradeAccountDate");
            int	ownertradeAccountType		 = rs.getInt("ownertradeAccountType");
            int	ownertradeAccountId		 = rs.getInt("ownertradeAccountId");
            int	ownertradeLogId		 = rs.getInt("ownertradeLogId");
            String	ownertradeLogPs		 = rs.getString("ownertradeLogPs");
            int	ownertradeCheckLog		 = rs.getInt("ownertradeCheckLog");
            int	ownertradeCheckUserId		 = rs.getInt("ownertradeCheckUserId");
            java.util.Date	ownertradeCheckDate		 = rs.getTimestamp("ownertradeCheckDate");
            String	ownertradeCheckPs		 = rs.getString("ownertradeCheckPs");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , ownertradeOwnerId, ownertradeInOut, ownertradeNumber
            , ownertradeWay, ownertradeAccountDate, ownertradeAccountType
            , ownertradeAccountId, ownertradeLogId, ownertradeLogPs
            , ownertradeCheckLog, ownertradeCheckUserId, ownertradeCheckDate
            , ownertradeCheckPs, bunitId);
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
        Ownertrade item = (Ownertrade) obj;

        String ret = "modified=NOW()"
            + ",ownertradeOwnerId=" + item.getOwnertradeOwnerId()
            + ",ownertradeInOut=" + item.getOwnertradeInOut()
            + ",ownertradeNumber=" + item.getOwnertradeNumber()
            + ",ownertradeWay=" + item.getOwnertradeWay()
            + ",ownertradeAccountDate=" + (((d=item.getOwnertradeAccountDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",ownertradeAccountType=" + item.getOwnertradeAccountType()
            + ",ownertradeAccountId=" + item.getOwnertradeAccountId()
            + ",ownertradeLogId=" + item.getOwnertradeLogId()
            + ",ownertradeLogPs='" + ServerTool.escapeString(item.getOwnertradeLogPs()) + "'"
            + ",ownertradeCheckLog=" + item.getOwnertradeCheckLog()
            + ",ownertradeCheckUserId=" + item.getOwnertradeCheckUserId()
            + ",ownertradeCheckDate=" + (((d=item.getOwnertradeCheckDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",ownertradeCheckPs='" + ServerTool.escapeString(item.getOwnertradeCheckPs()) + "'"
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, ownertradeOwnerId, ownertradeInOut, ownertradeNumber, ownertradeWay, ownertradeAccountDate, ownertradeAccountType, ownertradeAccountId, ownertradeLogId, ownertradeLogPs, ownertradeCheckLog, ownertradeCheckUserId, ownertradeCheckDate, ownertradeCheckPs, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Ownertrade item = (Ownertrade) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getOwnertradeOwnerId()
            + "," + item.getOwnertradeInOut()
            + "," + item.getOwnertradeNumber()
            + "," + item.getOwnertradeWay()
            + "," + (((d=item.getOwnertradeAccountDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getOwnertradeAccountType()
            + "," + item.getOwnertradeAccountId()
            + "," + item.getOwnertradeLogId()
            + ",'" + ServerTool.escapeString(item.getOwnertradeLogPs()) + "'"
            + "," + item.getOwnertradeCheckLog()
            + "," + item.getOwnertradeCheckUserId()
            + "," + (((d=item.getOwnertradeCheckDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getOwnertradeCheckPs()) + "'"
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
