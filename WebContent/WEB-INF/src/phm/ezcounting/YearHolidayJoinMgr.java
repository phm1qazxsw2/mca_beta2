package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class YearHolidayJoinMgr extends dbo.Manager<YearHolidayJoin>
{
    private static YearHolidayJoinMgr _instance = null;

    YearHolidayJoinMgr() {}

    public synchronized static YearHolidayJoinMgr getInstance()
    {
        if (_instance==null) {
            _instance = new YearHolidayJoinMgr();
        }
        return _instance;
    }

    public YearHolidayJoinMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "yearholiday join yearmembr";
    }

    protected Object makeBean()
    {
        return new YearHolidayJoin();
    }

    protected String JoinSpace()
    {
         return "yearholiday.id=yearmembr.yearHolidayId";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        YearHolidayJoin item = (YearHolidayJoin) obj;
        try {
            int	id		 = rs.getInt("yearholiday.id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            String	name		 = rs.getString("name");
            item.setName(name);
            java.util.Date	startDate		 = rs.getTimestamp("startDate");
            item.setStartDate(startDate);
            java.util.Date	endDate		 = rs.getTimestamp("endDate");
            item.setEndDate(endDate);
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

}
