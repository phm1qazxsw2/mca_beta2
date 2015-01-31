package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaExRateMgr extends dbo.Manager<McaExRate>
{
    private static McaExRateMgr _instance = null;

    McaExRateMgr() {}

    public synchronized static McaExRateMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaExRateMgr();
        }
        return _instance;
    }

    public McaExRateMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_exrate";
    }

    protected Object makeBean()
    {
        return new McaExRate();
    }

    protected String getIdentifier(Object obj)
    {
        McaExRate o = (McaExRate) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaExRate item = (McaExRate) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            double	rate		 = rs.getDouble("rate");
            item.setRate(rate);
            java.util.Date	start		 = rs.getTimestamp("start");
            item.setStart(start);
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
        McaExRate item = (McaExRate) obj;

        String ret = 
            "rate=" + item.getRate()
            + ",start=" + (((d=item.getStart())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "rate,start";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaExRate item = (McaExRate) obj;

        String ret = 
            "" + item.getRate()
            + "," + (((d=item.getStart())!=null)?("'"+df.format(d)+"'"):"NULL")

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        McaExRate o = (McaExRate) obj;
        o.setId(auto_id);
    }
}
