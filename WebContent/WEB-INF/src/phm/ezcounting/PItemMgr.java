package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class PItemMgr extends dbo.Manager<PItem>
{
    private static PItemMgr _instance = null;

    PItemMgr() {}

    public synchronized static PItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new PItemMgr();
        }
        return _instance;
    }

    public PItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "pitem";
    }

    protected Object makeBean()
    {
        return new PItem();
    }

    protected String getIdentifier(Object obj)
    {
        PItem o = (PItem) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        PItem item = (PItem) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            String	name		 = rs.getString("name");
            item.setName(name);
            int	safetyLevel		 = rs.getInt("safetyLevel");
            item.setSafetyLevel(safetyLevel);
            int	status		 = rs.getInt("status");
            item.setStatus(status);
            int	salePrice		 = rs.getInt("salePrice");
            item.setSalePrice(salePrice);
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
        PItem item = (PItem) obj;

        String ret = 
            "name='" + ServerTool.escapeString(item.getName()) + "'"
            + ",safetyLevel=" + item.getSafetyLevel()
            + ",status=" + item.getStatus()
            + ",salePrice=" + item.getSalePrice()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name,safetyLevel,status,salePrice,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        PItem item = (PItem) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getName()) + "'"
            + "," + item.getSafetyLevel()
            + "," + item.getStatus()
            + "," + item.getSalePrice()
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
        PItem o = (PItem) obj;
        o.setId(auto_id);
    }
}
