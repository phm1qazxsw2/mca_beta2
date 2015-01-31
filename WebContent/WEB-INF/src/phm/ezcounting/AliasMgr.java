package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AliasMgr extends dbo.Manager<Alias>
{
    private static AliasMgr _instance = null;

    AliasMgr() {}

    public synchronized static AliasMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AliasMgr();
        }
        return _instance;
    }

    public AliasMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "itemalias";
    }

    protected Object makeBean()
    {
        return new Alias();
    }

    protected String getIdentifier(Object obj)
    {
        Alias o = (Alias) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Alias item = (Alias) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	name		 = rs.getString("name");
            item.setName(name);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
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
        Alias item = (Alias) obj;

        String ret = 
            "name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",status=" + item.getStatus()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name,status,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Alias item = (Alias) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getStatus()
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
        Alias o = (Alias) obj;
        o.setId(auto_id);
    }
}
