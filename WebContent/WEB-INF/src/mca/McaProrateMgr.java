package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaProrateMgr extends dbo.Manager<McaProrate>
{
    private static McaProrateMgr _instance = null;

    McaProrateMgr() {}

    public synchronized static McaProrateMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaProrateMgr();
        }
        return _instance;
    }

    public McaProrateMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "mca_prorate";
    }

    protected Object makeBean()
    {
        return new McaProrate();
    }

    protected String getIdentifier(Object obj)
    {
        McaProrate o = (McaProrate) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaProrate item = (McaProrate) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	mcaFeeId		 = rs.getInt("mcaFeeId");
            item.setMcaFeeId(mcaFeeId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            java.util.Date	prorateDate		 = rs.getTimestamp("prorateDate");
            item.setProrateDate(prorateDate);
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
        McaProrate item = (McaProrate) obj;

        String ret = 
            "mcaFeeId=" + item.getMcaFeeId()
            + ",membrId=" + item.getMembrId()
            + ",prorateDate=" + (((d=item.getProrateDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "mcaFeeId,membrId,prorateDate,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaProrate item = (McaProrate) obj;

        String ret = 
            "" + item.getMcaFeeId()
            + "," + item.getMembrId()
            + "," + (((d=item.getProrateDate())!=null)?("'"+df.format(d)+"'"):"NULL")
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
        McaProrate o = (McaProrate) obj;
        o.setId(auto_id);
    }
}
