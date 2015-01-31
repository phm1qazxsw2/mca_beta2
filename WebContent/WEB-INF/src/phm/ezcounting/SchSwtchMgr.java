package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchSwtchMgr extends dbo.Manager<SchSwtch>
{
    private static SchSwtchMgr _instance = null;

    SchSwtchMgr() {}

    public synchronized static SchSwtchMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchSwtchMgr();
        }
        return _instance;
    }

    public SchSwtchMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schswtch";
    }

    protected Object makeBean()
    {
        return new SchSwtch();
    }

    protected String getIdentifier(Object obj)
    {
        SchSwtch o = (SchSwtch) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchSwtch item = (SchSwtch) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	schMembrId1		 = rs.getInt("schMembrId1");
            item.setSchMembrId1(schMembrId1);
            int	schMembrId2		 = rs.getInt("schMembrId2");
            item.setSchMembrId2(schMembrId2);
            java.util.Date	date		 = rs.getTimestamp("date");
            item.setDate(date);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            String	note		 = rs.getString("note");
            item.setNote(note);
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
        SchSwtch item = (SchSwtch) obj;

        String ret = 
            "schMembrId1=" + item.getSchMembrId1()
            + ",schMembrId2=" + item.getSchMembrId2()
            + ",date=" + (((d=item.getDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",status=" + item.getStatus()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "schMembrId1,schMembrId2,date,status,note";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchSwtch item = (SchSwtch) obj;

        String ret = 
            "" + item.getSchMembrId1()
            + "," + item.getSchMembrId2()
            + "," + (((d=item.getDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getStatus()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        SchSwtch o = (SchSwtch) obj;
        o.setId(auto_id);
    }
}
