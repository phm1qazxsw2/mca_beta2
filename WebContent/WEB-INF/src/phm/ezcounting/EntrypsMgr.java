package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class EntrypsMgr extends dbo.Manager<Entryps>
{
    private static EntrypsMgr _instance = null;

    EntrypsMgr() {}

    public synchronized static EntrypsMgr getInstance()
    {
        if (_instance==null) {
            _instance = new EntrypsMgr();
        }
        return _instance;
    }

    public EntrypsMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "entryps";
    }

    protected Object makeBean()
    {
        return new Entryps();
    }

    protected String getIdentifier(Object obj)
    {
        Entryps o = (Entryps) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Entryps item = (Entryps) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            String	ps		 = rs.getString("ps");
            item.setPs(ps);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            java.util.Date	modifyDate		 = rs.getTimestamp("modifyDate");
            item.setModifyDate(modifyDate);
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
        Entryps item = (Entryps) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",membrId=" + item.getMembrId()
            + ",ps='" + ServerTool.escapeString(item.getPs()) + "'"
            + ",userId=" + item.getUserId()
            + ",modifyDate=" + (((d=item.getModifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,membrId,ps,userId,modifyDate";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Entryps item = (Entryps) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMembrId()
            + ",'" + ServerTool.escapeString(item.getPs()) + "'"
            + "," + item.getUserId()
            + "," + (((d=item.getModifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Entryps o = (Entryps) obj;
        o.setId(auto_id);
    }
}
