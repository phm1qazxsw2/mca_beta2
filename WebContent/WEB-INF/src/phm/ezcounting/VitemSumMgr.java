package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VitemSumMgr extends dbo.Manager<VitemSum>
{
    private static VitemSumMgr _instance = null;

    VitemSumMgr() {}

    public synchronized static VitemSumMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VitemSumMgr();
        }
        return _instance;
    }

    public VitemSumMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vitem";
    }

    protected Object makeBean()
    {
        return new VitemSum();
    }

    protected String getFieldList()
    {
         return "SUM(total) as s1,SUM(realized) as s2";
    }

    protected String getIdentifier(Object obj)
    {
        VitemSum o = (VitemSum) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        VitemSum item = (VitemSum) obj;
        try {
            int	total		 = rs.getInt("s1");
            item.setTotal(total);
            int	realized		 = rs.getInt("s2");
            item.setRealized(realized);
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
        VitemSum item = (VitemSum) obj;

        String ret = 
            "total=" + item.getTotal()
            + ",realized=" + item.getRealized()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "total,realized";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        VitemSum item = (VitemSum) obj;

        String ret = 
            "" + item.getTotal()
            + "," + item.getRealized()

        ;
        return ret;
    }
}
