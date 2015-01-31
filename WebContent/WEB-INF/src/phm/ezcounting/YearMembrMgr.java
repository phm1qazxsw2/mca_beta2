package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class YearMembrMgr extends dbo.Manager<YearMembr>
{
    private static YearMembrMgr _instance = null;

    YearMembrMgr() {}

    public synchronized static YearMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new YearMembrMgr();
        }
        return _instance;
    }

    public YearMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "yearmembr";
    }

    protected Object makeBean()
    {
        return new YearMembr();
    }

    protected String getIdentifier(Object obj)
    {
        YearMembr o = (YearMembr) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        YearMembr item = (YearMembr) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	yearHolidayId		 = rs.getInt("yearHolidayId");
            item.setYearHolidayId(yearHolidayId);
            int	mins		 = rs.getInt("mins");
            item.setMins(mins);
            int	overtime		 = rs.getInt("overtime");
            item.setOvertime(overtime);
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
        YearMembr item = (YearMembr) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",membrId=" + item.getMembrId()
            + ",yearHolidayId=" + item.getYearHolidayId()
            + ",mins=" + item.getMins()
            + ",overtime=" + item.getOvertime()
            + ",userId=" + item.getUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,membrId,yearHolidayId,mins,overtime,userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        YearMembr item = (YearMembr) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMembrId()
            + "," + item.getYearHolidayId()
            + "," + item.getMins()
            + "," + item.getOvertime()
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
        YearMembr o = (YearMembr) obj;
        o.setId(auto_id);
    }
}
