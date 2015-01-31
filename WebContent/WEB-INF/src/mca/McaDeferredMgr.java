package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaDeferredMgr extends dbo.Manager<McaDeferred>
{
    private static McaDeferredMgr _instance = null;

    McaDeferredMgr() {}

    public synchronized static McaDeferredMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaDeferredMgr();
        }
        return _instance;
    }

    public McaDeferredMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_deferred";
    }

    protected Object makeBean()
    {
        return new McaDeferred();
    }

    protected String getIdentifier(Object obj)
    {
        McaDeferred o = (McaDeferred) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaDeferred item = (McaDeferred) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	ticketId		 = rs.getString("ticketId");
            item.setTicketId(ticketId);
            int	type		 = rs.getInt("type");
            item.setType(type);
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
        McaDeferred item = (McaDeferred) obj;

        String ret = 
            "ticketId='" + ServerTool.escapeString(item.getTicketId()) + "'"
            + ",type=" + item.getType()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "ticketId,type,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaDeferred item = (McaDeferred) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getTicketId()) + "'"
            + "," + item.getType()
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
        McaDeferred o = (McaDeferred) obj;
        o.setId(auto_id);
    }
}
