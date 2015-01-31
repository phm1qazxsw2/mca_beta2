package web;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class WebsetupMgr extends Manager
{
    private static WebsetupMgr _instance = null;

    WebsetupMgr() {}

    public synchronized static WebsetupMgr getInstance()
    {
        if (_instance==null) {
            _instance = new WebsetupMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "websetup";
    }

    protected Object makeBean()
    {
        return new Websetup();
    }

    protected int getBeanId(Object obj)
    {
        return ((Websetup)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Websetup item = (Websetup) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	websetupShareIp		 = rs.getString("websetupShareIp");
            String	websetupWebaddress		 = rs.getString("websetupWebaddress");
            String	websetupAuthodCode		 = rs.getString("websetupAuthodCode");
            String	websetupCompanyname		 = rs.getString("websetupCompanyname");

            item
            .init(id, created, modified
            , websetupShareIp, websetupWebaddress, websetupAuthodCode
            , websetupCompanyname);
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
        Websetup item = (Websetup) obj;

        String ret = "modified=NOW()"
            + ",websetupShareIp='" + ServerTool.escapeString(item.getWebsetupShareIp()) + "'"
            + ",websetupWebaddress='" + ServerTool.escapeString(item.getWebsetupWebaddress()) + "'"
            + ",websetupAuthodCode='" + ServerTool.escapeString(item.getWebsetupAuthodCode()) + "'"
            + ",websetupCompanyname='" + ServerTool.escapeString(item.getWebsetupCompanyname()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, websetupShareIp, websetupWebaddress, websetupAuthodCode, websetupCompanyname";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Websetup item = (Websetup) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getWebsetupShareIp()) + "'"
            + ",'" + ServerTool.escapeString(item.getWebsetupWebaddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getWebsetupAuthodCode()) + "'"
            + ",'" + ServerTool.escapeString(item.getWebsetupCompanyname()) + "'"
        ;
        return ret;
    }
}
