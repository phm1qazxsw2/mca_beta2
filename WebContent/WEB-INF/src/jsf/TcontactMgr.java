package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TcontactMgr extends Manager
{
    private static TcontactMgr _instance = null;

    TcontactMgr() {}

    public synchronized static TcontactMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TcontactMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "tcontact";
    }

    protected Object makeBean()
    {
        return new Tcontact();
    }

    protected int getBeanId(Object obj)
    {
        return ((Tcontact)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Tcontact item = (Tcontact) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	tcontactStuId		 = rs.getInt("tcontactStuId");
            String	tcontactName		 = rs.getString("tcontactName");
            int	tcontactReleationId		 = rs.getInt("tcontactReleationId");
            String	tcontactPhone1		 = rs.getString("tcontactPhone1");
            String	tcontactPhone2		 = rs.getString("tcontactPhone2");
            String	tcontactMobile		 = rs.getString("tcontactMobile");
            String	tcontactPs		 = rs.getString("tcontactPs");

            item
            .init(id, created, modified
            , tcontactStuId, tcontactName, tcontactReleationId
            , tcontactPhone1, tcontactPhone2, tcontactMobile
            , tcontactPs);
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
        Tcontact item = (Tcontact) obj;

        String ret = "modified=NOW()"
            + ",tcontactStuId=" + item.getTcontactStuId()
            + ",tcontactName='" + ServerTool.escapeString(item.getTcontactName()) + "'"
            + ",tcontactReleationId=" + item.getTcontactReleationId()
            + ",tcontactPhone1='" + ServerTool.escapeString(item.getTcontactPhone1()) + "'"
            + ",tcontactPhone2='" + ServerTool.escapeString(item.getTcontactPhone2()) + "'"
            + ",tcontactMobile='" + ServerTool.escapeString(item.getTcontactMobile()) + "'"
            + ",tcontactPs='" + ServerTool.escapeString(item.getTcontactPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, tcontactStuId, tcontactName, tcontactReleationId, tcontactPhone1, tcontactPhone2, tcontactMobile, tcontactPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Tcontact item = (Tcontact) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTcontactStuId()
            + ",'" + ServerTool.escapeString(item.getTcontactName()) + "'"
            + "," + item.getTcontactReleationId()
            + ",'" + ServerTool.escapeString(item.getTcontactPhone1()) + "'"
            + ",'" + ServerTool.escapeString(item.getTcontactPhone2()) + "'"
            + ",'" + ServerTool.escapeString(item.getTcontactMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getTcontactPs()) + "'"
        ;
        return ret;
    }
}
