package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchswMgr extends dbo.Manager<Schsw>
{
    private static SchswMgr _instance = null;

    SchswMgr() {}

    public synchronized static SchswMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchswMgr();
        }
        return _instance;
    }

    public SchswMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schsw";
    }

    protected Object makeBean()
    {
        return new Schsw();
    }

    protected String getIdentifier(Object obj)
    {
        Schsw o = (Schsw) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Schsw item = (Schsw) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	reqMembrId		 = rs.getInt("reqMembrId");
            item.setReqMembrId(reqMembrId);
            int	verifystatus		 = rs.getInt("verifystatus");
            item.setVerifystatus(verifystatus);
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
        Schsw item = (Schsw) obj;

        String ret = 
            "recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",userId=" + item.getUserId()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",reqMembrId=" + item.getReqMembrId()
            + ",verifystatus=" + item.getVerifystatus()
            + ",verifyDate=" + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",verifyUserId=" + item.getVerifyUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "recordTime,userId,note,reqMembrId,verifystatus,verifyDate,verifyUserId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Schsw item = (Schsw) obj;

        String ret = 
            "" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getUserId()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getReqMembrId()
            + "," + item.getVerifystatus()
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
        Schsw o = (Schsw) obj;
        o.setId(auto_id);
    }
}
