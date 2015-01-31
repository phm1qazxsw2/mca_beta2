package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalarybankAuthMgr extends Manager
{
    private static SalarybankAuthMgr _instance = null;

    SalarybankAuthMgr() {}

    public synchronized static SalarybankAuthMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalarybankAuthMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "salarybankauth";
    }

    protected Object makeBean()
    {
        return new SalarybankAuth();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalarybankAuth)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalarybankAuth item = (SalarybankAuth) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	salarybankAuthId		 = rs.getInt("salarybankAuthId");
            int	salarybankAuthUserID		 = rs.getInt("salarybankAuthUserID");
            int	salarybankAuthActive		 = rs.getInt("salarybankAuthActive");
            int	salarybankLoginId		 = rs.getInt("salarybankLoginId");

            item
            .init(id, created, modified
            , salarybankAuthId, salarybankAuthUserID, salarybankAuthActive
            , salarybankLoginId);
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
        SalarybankAuth item = (SalarybankAuth) obj;

        String ret = "modified=NOW()"
            + ",salarybankAuthId=" + item.getSalarybankAuthId()
            + ",salarybankAuthUserID=" + item.getSalarybankAuthUserID()
            + ",salarybankAuthActive=" + item.getSalarybankAuthActive()
            + ",salarybankLoginId=" + item.getSalarybankLoginId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salarybankAuthId, salarybankAuthUserID, salarybankAuthActive, salarybankLoginId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalarybankAuth item = (SalarybankAuth) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getSalarybankAuthId()
            + "," + item.getSalarybankAuthUserID()
            + "," + item.getSalarybankAuthActive()
            + "," + item.getSalarybankLoginId()
        ;
        return ret;
    }
}
