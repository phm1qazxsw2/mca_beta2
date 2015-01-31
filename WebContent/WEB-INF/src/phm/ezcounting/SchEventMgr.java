package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchEventMgr extends dbo.Manager<SchEvent>
{
    private static SchEventMgr _instance = null;

    SchEventMgr() {}

    public synchronized static SchEventMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchEventMgr();
        }
        return _instance;
    }

    public SchEventMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schevent";
    }

    protected Object makeBean()
    {
        return new SchEvent();
    }

    protected String getIdentifier(Object obj)
    {
        SchEvent o = (SchEvent) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchEvent item = (SchEvent) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            java.util.Date	modifyTime		 = rs.getTimestamp("modifyTime");
            item.setModifyTime(modifyTime);
            java.util.Date	startTime		 = rs.getTimestamp("startTime");
            item.setStartTime(startTime);
            java.util.Date	endTime		 = rs.getTimestamp("endTime");
            item.setEndTime(endTime);
            int	lastingHours		 = rs.getInt("lastingHours");
            item.setLastingHours(lastingHours);
            int	lastingMins		 = rs.getInt("lastingMins");
            item.setLastingMins(lastingMins);
            int	restMins		 = rs.getInt("restMins");
            item.setRestMins(restMins);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	type		 = rs.getInt("type");
            item.setType(type);
            int	schdefId		 = rs.getInt("schdefId");
            item.setSchdefId(schdefId);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            int	holidayId		 = rs.getInt("holidayId");
            item.setHolidayId(holidayId);
            int	verifystatus		 = rs.getInt("verifystatus");
            item.setVerifystatus(verifystatus);
            String	verifyPs		 = rs.getString("verifyPs");
            item.setVerifyPs(verifyPs);
            java.util.Date	verifyDate		 = rs.getTimestamp("verifyDate");
            item.setVerifyDate(verifyDate);
            int	verifyUserId		 = rs.getInt("verifyUserId");
            item.setVerifyUserId(verifyUserId);
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
        SchEvent item = (SchEvent) obj;

        String ret = 
            "membrId=" + item.getMembrId()
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modifyTime=" + (((d=item.getModifyTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",startTime=" + (((d=item.getStartTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endTime=" + (((d=item.getEndTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",lastingHours=" + item.getLastingHours()
            + ",lastingMins=" + item.getLastingMins()
            + ",restMins=" + item.getRestMins()
            + ",userId=" + item.getUserId()
            + ",type=" + item.getType()
            + ",schdefId=" + item.getSchdefId()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",status=" + item.getStatus()
            + ",holidayId=" + item.getHolidayId()
            + ",verifystatus=" + item.getVerifystatus()
            + ",verifyPs='" + ServerTool.escapeString(item.getVerifyPs()) + "'"
            + ",verifyDate=" + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",verifyUserId=" + item.getVerifyUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "membrId,recordTime,modifyTime,startTime,endTime,lastingHours,lastingMins,restMins,userId,type,schdefId,note,status,holidayId,verifystatus,verifyPs,verifyDate,verifyUserId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchEvent item = (SchEvent) obj;

        String ret = 
            "" + item.getMembrId()
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModifyTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getStartTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getLastingHours()
            + "," + item.getLastingMins()
            + "," + item.getRestMins()
            + "," + item.getUserId()
            + "," + item.getType()
            + "," + item.getSchdefId()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getStatus()
            + "," + item.getHolidayId()
            + "," + item.getVerifystatus()
            + ",'" + ServerTool.escapeString(item.getVerifyPs()) + "'"
            + "," + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getVerifyUserId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        SchEvent o = (SchEvent) obj;
        o.setId(auto_id);
    }
}
