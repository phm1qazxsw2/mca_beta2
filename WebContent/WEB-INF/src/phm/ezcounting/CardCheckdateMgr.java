package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CardCheckdateMgr extends dbo.Manager<CardCheckdate>
{
    private static CardCheckdateMgr _instance = null;

    CardCheckdateMgr() {}

    public synchronized static CardCheckdateMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CardCheckdateMgr();
        }
        return _instance;
    }

    public CardCheckdateMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "cardcheckdate";
    }

    protected Object makeBean()
    {
        return new CardCheckdate();
    }

    protected String getIdentifier(Object obj)
    {
        CardCheckdate o = (CardCheckdate) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        CardCheckdate item = (CardCheckdate) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	checkdate		 = rs.getTimestamp("checkdate");
            item.setCheckdate(checkdate);
            int	checkUser		 = rs.getInt("checkUser");
            item.setCheckUser(checkUser);
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
        CardCheckdate item = (CardCheckdate) obj;

        String ret = 
            "checkdate=" + (((d=item.getCheckdate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",checkUser=" + item.getCheckUser()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "checkdate,checkUser";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        CardCheckdate item = (CardCheckdate) obj;

        String ret = 
            "" + (((d=item.getCheckdate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCheckUser()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        CardCheckdate o = (CardCheckdate) obj;
        o.setId(auto_id);
    }
}
