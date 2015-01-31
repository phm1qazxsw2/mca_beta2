package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class FreezeMgr extends dbo.Manager<Freeze>
{
    private static FreezeMgr _instance = null;

    FreezeMgr() {}

    public synchronized static FreezeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new FreezeMgr();
        }
        return _instance;
    }

    public FreezeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "freeze";
    }

    protected Object makeBean()
    {
        return new Freeze();
    }

    protected String getIdentifier(Object obj)
    {
        Freeze o = (Freeze) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Freeze item = (Freeze) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	freezeTime		 = rs.getTimestamp("freezeTime");
            item.setFreezeTime(freezeTime);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
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
        Freeze item = (Freeze) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",freezeTime=" + (((d=item.getFreezeTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",userId=" + item.getUserId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,freezeTime,userId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Freeze item = (Freeze) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getFreezeTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getUserId()
            + "," + item.getBunitId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Freeze o = (Freeze) obj;
        o.setId(auto_id);
    }
}
