package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class OvertimeMgr extends dbo.Manager<Overtime>
{
    private static OvertimeMgr _instance = null;

    OvertimeMgr() {}

    public synchronized static OvertimeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new OvertimeMgr();
        }
        return _instance;
    }

    public OvertimeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "overtime";
    }

    protected Object makeBean()
    {
        return new Overtime();
    }

    protected String getIdentifier(Object obj)
    {
        Overtime o = (Overtime) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Overtime item = (Overtime) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            java.util.Date	startDate		 = rs.getTimestamp("startDate");
            item.setStartDate(startDate);
            java.util.Date	endDate		 = rs.getTimestamp("endDate");
            item.setEndDate(endDate);
            int	mins		 = rs.getInt("mins");
            item.setMins(mins);
            String	ps		 = rs.getString("ps");
            item.setPs(ps);
            int	editUser		 = rs.getInt("editUser");
            item.setEditUser(editUser);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            int	times		 = rs.getInt("times");
            item.setTimes(times);
            int	confirmType		 = rs.getInt("confirmType");
            item.setConfirmType(confirmType);
            int	confirmMins		 = rs.getInt("confirmMins");
            item.setConfirmMins(confirmMins);
            String	confirmPs		 = rs.getString("confirmPs");
            item.setConfirmPs(confirmPs);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
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
        Overtime item = (Overtime) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",membrId=" + item.getMembrId()
            + ",startDate=" + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endDate=" + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",mins=" + item.getMins()
            + ",ps='" + ServerTool.escapeString(item.getPs()) + "'"
            + ",editUser=" + item.getEditUser()
            + ",status=" + item.getStatus()
            + ",times=" + item.getTimes()
            + ",confirmType=" + item.getConfirmType()
            + ",confirmMins=" + item.getConfirmMins()
            + ",confirmPs='" + ServerTool.escapeString(item.getConfirmPs()) + "'"
            + ",userId=" + item.getUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,membrId,startDate,endDate,mins,ps,editUser,status,times,confirmType,confirmMins,confirmPs,userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Overtime item = (Overtime) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMembrId()
            + "," + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMins()
            + ",'" + ServerTool.escapeString(item.getPs()) + "'"
            + "," + item.getEditUser()
            + "," + item.getStatus()
            + "," + item.getTimes()
            + "," + item.getConfirmType()
            + "," + item.getConfirmMins()
            + ",'" + ServerTool.escapeString(item.getConfirmPs()) + "'"
            + "," + item.getUserId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Overtime o = (Overtime) obj;
        o.setId(auto_id);
    }
}
