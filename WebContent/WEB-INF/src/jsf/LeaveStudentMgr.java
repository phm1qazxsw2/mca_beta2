package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class LeaveStudentMgr extends Manager
{
    private static LeaveStudentMgr _instance = null;

    LeaveStudentMgr() {}

    public synchronized static LeaveStudentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new LeaveStudentMgr();
        }
        return _instance;
    }

    public LeaveStudentMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "leavestudent";
    }

    protected Object makeBean()
    {
        return new LeaveStudent();
    }

    protected int getBeanId(Object obj)
    {
        return ((LeaveStudent)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        LeaveStudent item = (LeaveStudent) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	leaveStudentStudentId		 = rs.getInt("leaveStudentStudentId");
            int	leaveStudentReasonId		 = rs.getInt("leaveStudentReasonId");
            String	leaveStudentPs		 = rs.getString("leaveStudentPs");
            int	leaveStudentLogId		 = rs.getInt("leaveStudentLogId");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , leaveStudentStudentId, leaveStudentReasonId, leaveStudentPs
            , leaveStudentLogId, bunitId);
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
        LeaveStudent item = (LeaveStudent) obj;

        String ret = "modified=NOW()"
            + ",leaveStudentStudentId=" + item.getLeaveStudentStudentId()
            + ",leaveStudentReasonId=" + item.getLeaveStudentReasonId()
            + ",leaveStudentPs='" + ServerTool.escapeString(item.getLeaveStudentPs()) + "'"
            + ",leaveStudentLogId=" + item.getLeaveStudentLogId()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, leaveStudentStudentId, leaveStudentReasonId, leaveStudentPs, leaveStudentLogId, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        LeaveStudent item = (LeaveStudent) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getLeaveStudentStudentId()
            + "," + item.getLeaveStudentReasonId()
            + ",'" + ServerTool.escapeString(item.getLeaveStudentPs()) + "'"
            + "," + item.getLeaveStudentLogId()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
