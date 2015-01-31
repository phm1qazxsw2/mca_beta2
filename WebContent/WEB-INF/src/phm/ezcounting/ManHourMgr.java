package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ManHourMgr extends dbo.Manager<ManHour>
{
    private static ManHourMgr _instance = null;

    ManHourMgr() {}

    public synchronized static ManHourMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ManHourMgr();
        }
        return _instance;
    }

    public ManHourMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "manhour";
    }

    protected Object makeBean()
    {
        return new ManHour();
    }

    protected String getIdentifier(Object obj)
    {
        ManHour o = (ManHour) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ManHour item = (ManHour) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	clientMembrId		 = rs.getInt("clientMembrId");
            item.setClientMembrId(clientMembrId);
            int	executeMembrId		 = rs.getInt("executeMembrId");
            item.setExecuteMembrId(executeMembrId);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            java.util.Date	modifyTime		 = rs.getTimestamp("modifyTime");
            item.setModifyTime(modifyTime);
            java.util.Date	occurDate		 = rs.getTimestamp("occurDate");
            item.setOccurDate(occurDate);
            int	billfdId		 = rs.getInt("billfdId");
            item.setBillfdId(billfdId);
            int	salaryfdId		 = rs.getInt("salaryfdId");
            item.setSalaryfdId(salaryfdId);
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
        ManHour item = (ManHour) obj;

        String ret = 
            "clientMembrId=" + item.getClientMembrId()
            + ",executeMembrId=" + item.getExecuteMembrId()
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modifyTime=" + (((d=item.getModifyTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",occurDate=" + (((d=item.getOccurDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",billfdId=" + item.getBillfdId()
            + ",salaryfdId=" + item.getSalaryfdId()
            + ",userId=" + item.getUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "clientMembrId,executeMembrId,recordTime,modifyTime,occurDate,billfdId,salaryfdId,userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ManHour item = (ManHour) obj;

        String ret = 
            "" + item.getClientMembrId()
            + "," + item.getExecuteMembrId()
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModifyTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getOccurDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getBillfdId()
            + "," + item.getSalaryfdId()
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
        ManHour o = (ManHour) obj;
        o.setId(auto_id);
    }
}
