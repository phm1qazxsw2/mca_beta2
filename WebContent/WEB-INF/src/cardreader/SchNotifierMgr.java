package cardreader;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SchNotifierMgr extends dbo.Manager<SchNotifier>
{
    private static SchNotifierMgr _instance = null;

    SchNotifierMgr() {}

    public synchronized static SchNotifierMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SchNotifierMgr();
        }
        return _instance;
    }

    public SchNotifierMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "sch_notifier";
    }

    protected Object makeBean()
    {
        return new SchNotifier();
    }

    protected String getIdentifier(Object obj)
    {
        SchNotifier o = (SchNotifier) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SchNotifier item = (SchNotifier) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	lastId		 = rs.getInt("lastId");
            item.setLastId(lastId);
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
        SchNotifier item = (SchNotifier) obj;

        String ret = 
            "lastId=" + item.getLastId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "lastId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SchNotifier item = (SchNotifier) obj;

        String ret = 
            "" + item.getLastId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        SchNotifier o = (SchNotifier) obj;
        o.setId(auto_id);
    }
}
