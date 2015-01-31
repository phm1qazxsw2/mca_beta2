package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BunitMgr extends dbo.Manager<Bunit>
{
    private static BunitMgr _instance = null;

    BunitMgr() {}

    public synchronized static BunitMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BunitMgr();
        }
        return _instance;
    }

    public BunitMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bunit";
    }

    protected Object makeBean()
    {
        return new Bunit();
    }

    protected String getIdentifier(Object obj)
    {
        Bunit o = (Bunit) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Bunit item = (Bunit) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	label		 = rs.getString("label");
            item.setLabel(label);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            int	flag		 = rs.getInt("flag");
            item.setFlag(flag);
            int	buId		 = rs.getInt("buId");
            item.setBuId(buId);
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
        Bunit item = (Bunit) obj;

        String ret = 
            "label='" + ServerTool.escapeString(item.getLabel()) + "'"
            + ",status=" + item.getStatus()
            + ",flag=" + item.getFlag()
            + ",buId=" + item.getBuId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "label,status,flag,buId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Bunit item = (Bunit) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getLabel()) + "'"
            + "," + item.getStatus()
            + "," + item.getFlag()
            + "," + item.getBuId()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Bunit o = (Bunit) obj;
        o.setId(auto_id);
    }
}
