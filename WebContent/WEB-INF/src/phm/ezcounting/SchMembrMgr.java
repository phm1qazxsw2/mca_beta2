package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchMembrMgr extends dbo.Manager<SchMembr>
{
    private static SchMembrMgr _instance = null;

    SchMembrMgr() {}

    public synchronized static SchMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchMembrMgr();
        }
        return _instance;
    }

    public SchMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "schmembr";
    }

    protected Object makeBean()
    {
        return new SchMembr();
    }

    protected String getIdentifier(Object obj)
    {
        SchMembr o = (SchMembr) obj;
        return "membrId = " + o.getMembrId() + " and " + "schdefId = " + o.getSchdefId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchMembr item = (SchMembr) obj;
        try {
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	schdefId		 = rs.getInt("schdefId");
            item.setSchdefId(schdefId);
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
        SchMembr item = (SchMembr) obj;

        String ret = 
            "membrId=" + item.getMembrId()
            + ",schdefId=" + item.getSchdefId()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "membrId,schdefId,note";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchMembr item = (SchMembr) obj;

        String ret = 
            "" + item.getMembrId()
            + "," + item.getSchdefId()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"

        ;
        return ret;
    }
}
