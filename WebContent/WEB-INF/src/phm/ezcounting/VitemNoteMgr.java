package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VitemNoteMgr extends dbo.Manager<VitemNote>
{
    private static VitemNoteMgr _instance = null;

    VitemNoteMgr() {}

    public synchronized static VitemNoteMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VitemNoteMgr();
        }
        return _instance;
    }

    public VitemNoteMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vitem_note";
    }

    protected Object makeBean()
    {
        return new VitemNote();
    }

    protected String getIdentifier(Object obj)
    {
        VitemNote o = (VitemNote) obj;
        return "vitemId = " + o.getVitemId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VitemNote item = (VitemNote) obj;
        try {
            int	vitemId		 = rs.getInt("vitemId");
            item.setVitemId(vitemId);
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
        VitemNote item = (VitemNote) obj;

        String ret = 
            "vitemId=" + item.getVitemId()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "vitemId,note";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        VitemNote item = (VitemNote) obj;

        String ret = 
            "" + item.getVitemId()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"

        ;
        return ret;
    }
}
