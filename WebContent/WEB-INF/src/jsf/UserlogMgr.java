package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class UserlogMgr extends Manager
{
    private static UserlogMgr _instance = null;

    UserlogMgr() {}

    public synchronized static UserlogMgr getInstance()
    {
        if (_instance==null) {
            _instance = new UserlogMgr();
        }
        return _instance;
    }

    public UserlogMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "userlog";
    }

    protected Object makeBean()
    {
        return new Userlog();
    }

    protected int getBeanId(Object obj)
    {
        return ((Userlog)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Userlog item = (Userlog) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	UserlogUserId		 = rs.getInt("UserlogUserId");
            java.util.Date	UserlogDate		 = rs.getTimestamp("UserlogDate");
            String	UserlogIP		 = rs.getString("UserlogIP");
            String	UserlogHost		 = rs.getString("UserlogHost");
            java.util.Date	UserlogOut		 = rs.getTimestamp("UserlogOut");
            String	UserlogOutPs		 = rs.getString("UserlogOutPs");
            int	userConfirm		 = rs.getInt("userConfirm");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , UserlogUserId, UserlogDate, UserlogIP
            , UserlogHost, UserlogOut, UserlogOutPs
            , userConfirm, bunitId);
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
        Userlog item = (Userlog) obj;

        String ret = "modified=NOW()"
            + ",UserlogUserId=" + item.getUserlogUserId()
            + ",UserlogDate=" + (((d=item.getUserlogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",UserlogIP='" + ServerTool.escapeString(item.getUserlogIP()) + "'"
            + ",UserlogHost='" + ServerTool.escapeString(item.getUserlogHost()) + "'"
            + ",UserlogOut=" + (((d=item.getUserlogOut())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",UserlogOutPs='" + ServerTool.escapeString(item.getUserlogOutPs()) + "'"
            + ",userConfirm=" + item.getUserConfirm()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, UserlogUserId, UserlogDate, UserlogIP, UserlogHost, UserlogOut, UserlogOutPs, userConfirm, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Userlog item = (Userlog) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getUserlogUserId()
            + "," + (((d=item.getUserlogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getUserlogIP()) + "'"
            + ",'" + ServerTool.escapeString(item.getUserlogHost()) + "'"
            + "," + (((d=item.getUserlogOut())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getUserlogOutPs()) + "'"
            + "," + item.getUserConfirm()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
