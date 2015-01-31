package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillSourceMgr extends dbo.Manager<BillSource>
{
    private static BillSourceMgr _instance = null;

    BillSourceMgr() {}

    public synchronized static BillSourceMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillSourceMgr();
        }
        return _instance;
    }

    public BillSourceMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billsource";
    }

    protected Object makeBean()
    {
        return new BillSource();
    }

    protected String getIdentifier(Object obj)
    {
        BillSource o = (BillSource) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillSource item = (BillSource) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	line		 = rs.getString("line");
            item.setLine(line);
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
        BillSource item = (BillSource) obj;

        String ret = 
            "line='" + ServerTool.escapeString(item.getLine()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "line";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillSource item = (BillSource) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getLine()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        BillSource o = (BillSource) obj;
        o.setId(auto_id);
    }
}
