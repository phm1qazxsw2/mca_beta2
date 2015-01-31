package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VchrThreadMgr extends dbo.Manager<VchrThread>
{
    private static VchrThreadMgr _instance = null;

    VchrThreadMgr() {}

    public synchronized static VchrThreadMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VchrThreadMgr();
        }
        return _instance;
    }

    public VchrThreadMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vchr_thread";
    }

    protected Object makeBean()
    {
        return new VchrThread();
    }

    protected String getIdentifier(Object obj)
    {
        VchrThread o = (VchrThread) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VchrThread item = (VchrThread) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	srcType		 = rs.getInt("srcType");
            item.setSrcType(srcType);
            String	srcInfo		 = rs.getString("srcInfo");
            item.setSrcInfo(srcInfo);
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
        VchrThread item = (VchrThread) obj;

        String ret = 
            "srcType=" + item.getSrcType()
            + ",srcInfo='" + ServerTool.escapeString(item.getSrcInfo()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "srcType,srcInfo";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        VchrThread item = (VchrThread) obj;

        String ret = 
            "" + item.getSrcType()
            + ",'" + ServerTool.escapeString(item.getSrcInfo()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        VchrThread o = (VchrThread) obj;
        o.setId(auto_id);
    }
}
