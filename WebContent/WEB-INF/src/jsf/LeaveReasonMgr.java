package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class LeaveReasonMgr extends Manager
{
    private static LeaveReasonMgr _instance = null;

    LeaveReasonMgr() {}

    public synchronized static LeaveReasonMgr getInstance()
    {
        if (_instance==null) {
            _instance = new LeaveReasonMgr();
        }
        return _instance;
    }

    public LeaveReasonMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "leavereason";
    }

    protected Object makeBean()
    {
        return new LeaveReason();
    }

    protected int getBeanId(Object obj)
    {
        return ((LeaveReason)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        LeaveReason item = (LeaveReason) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	leaveReasonName		 = rs.getString("leaveReasonName");
            int	leaveReasonActive		 = rs.getInt("leaveReasonActive");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , leaveReasonName, leaveReasonActive, bunitId
            );
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
        LeaveReason item = (LeaveReason) obj;

        String ret = "modified=NOW()"
            + ",leaveReasonName='" + ServerTool.escapeString(item.getLeaveReasonName()) + "'"
            + ",leaveReasonActive=" + item.getLeaveReasonActive()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, leaveReasonName, leaveReasonActive, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        LeaveReason item = (LeaveReason) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getLeaveReasonName()) + "'"
            + "," + item.getLeaveReasonActive()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
