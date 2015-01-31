package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class YearHolidayMgr extends dbo.Manager<YearHoliday>
{
    private static YearHolidayMgr _instance = null;

    YearHolidayMgr() {}

    public synchronized static YearHolidayMgr getInstance()
    {
        if (_instance==null) {
            _instance = new YearHolidayMgr();
        }
        return _instance;
    }

    public YearHolidayMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "yearholiday";
    }

    protected Object makeBean()
    {
        return new YearHoliday();
    }

    protected String getIdentifier(Object obj)
    {
        YearHoliday o = (YearHoliday) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        YearHoliday item = (YearHoliday) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            String	name		 = rs.getString("name");
            item.setName(name);
            java.util.Date	startDate		 = rs.getTimestamp("startDate");
            item.setStartDate(startDate);
            java.util.Date	endDate		 = rs.getTimestamp("endDate");
            item.setEndDate(endDate);
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
        YearHoliday item = (YearHoliday) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",startDate=" + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endDate=" + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,name,startDate,endDate";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        YearHoliday item = (YearHoliday) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + (((d=item.getStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        YearHoliday o = (YearHoliday) obj;
        o.setId(auto_id);
    }
}
