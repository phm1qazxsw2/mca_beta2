package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class HolidayMgr extends dbo.Manager<Holiday>
{
    private static HolidayMgr _instance = null;

    HolidayMgr() {}

    public synchronized static HolidayMgr getInstance()
    {
        if (_instance==null) {
            _instance = new HolidayMgr();
        }
        return _instance;
    }

    public HolidayMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "holiday";
    }

    protected Object makeBean()
    {
        return new Holiday();
    }

    protected String getIdentifier(Object obj)
    {
        Holiday o = (Holiday) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Holiday item = (Holiday) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            int	type		 = rs.getInt("type");
            item.setType(type);
            String	name		 = rs.getString("name");
            item.setName(name);
            java.util.Date	startTime		 = rs.getTimestamp("startTime");
            item.setStartTime(startTime);
            java.util.Date	endTime		 = rs.getTimestamp("endTime");
            item.setEndTime(endTime);
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
        Holiday item = (Holiday) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",type=" + item.getType()
            + ",name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",startTime=" + (((d=item.getStartTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",endTime=" + (((d=item.getEndTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",userId=" + item.getUserId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,type,name,startTime,endTime,userId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Holiday item = (Holiday) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getType()
            + ",'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + (((d=item.getStartTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getEndTime())!=null)?("'"+df.format(d)+"'"):"NULL")
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
        Holiday o = (Holiday) obj;
        o.setId(auto_id);
    }
}
