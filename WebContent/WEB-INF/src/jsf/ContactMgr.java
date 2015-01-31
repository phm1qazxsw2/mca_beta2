package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ContactMgr extends Manager
{
    private static ContactMgr _instance = null;

    ContactMgr() {}

    public synchronized static ContactMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ContactMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "contact";
    }

    protected Object makeBean()
    {
        return new Contact();
    }

    protected int getBeanId(Object obj)
    {
        return ((Contact)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Contact item = (Contact) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	contactStuId		 = rs.getInt("contactStuId");
            String	contactName		 = rs.getString("contactName");
            int	contactReleationId		 = rs.getInt("contactReleationId");
            String	contactPhone1		 = rs.getString("contactPhone1");
            String	contactPhone2		 = rs.getString("contactPhone2");
            String	contactMobile		 = rs.getString("contactMobile");
            String	contactPs		 = rs.getString("contactPs");

            item
            .init(id, created, modified
            , contactStuId, contactName, contactReleationId
            , contactPhone1, contactPhone2, contactMobile
            , contactPs);
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
        Contact item = (Contact) obj;

        String ret = "modified=NOW()"
            + ",contactStuId=" + item.getContactStuId()
            + ",contactName='" + ServerTool.escapeString(item.getContactName()) + "'"
            + ",contactReleationId=" + item.getContactReleationId()
            + ",contactPhone1='" + ServerTool.escapeString(item.getContactPhone1()) + "'"
            + ",contactPhone2='" + ServerTool.escapeString(item.getContactPhone2()) + "'"
            + ",contactMobile='" + ServerTool.escapeString(item.getContactMobile()) + "'"
            + ",contactPs='" + ServerTool.escapeString(item.getContactPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, contactStuId, contactName, contactReleationId, contactPhone1, contactPhone2, contactMobile, contactPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Contact item = (Contact) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getContactStuId()
            + ",'" + ServerTool.escapeString(item.getContactName()) + "'"
            + "," + item.getContactReleationId()
            + ",'" + ServerTool.escapeString(item.getContactPhone1()) + "'"
            + ",'" + ServerTool.escapeString(item.getContactPhone2()) + "'"
            + ",'" + ServerTool.escapeString(item.getContactMobile()) + "'"
            + ",'" + ServerTool.escapeString(item.getContactPs()) + "'"
        ;
        return ret;
    }
}
