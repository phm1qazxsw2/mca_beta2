package phm.accounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class AcodeCatMgr extends dbo.Manager<AcodeCat>
{
    private static AcodeCatMgr _instance = null;

    AcodeCatMgr() {}

    public synchronized static AcodeCatMgr getInstance()
    {
        if (_instance==null) {
            _instance = new AcodeCatMgr();
        }
        return _instance;
    }

    public AcodeCatMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "acode_catgory";
    }

    protected Object makeBean()
    {
        return new AcodeCat();
    }

    protected String getIdentifier(Object obj)
    {
        AcodeCat o = (AcodeCat) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        AcodeCat item = (AcodeCat) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	name1		 = rs.getInt("name1");
            item.setName1(name1);
            int	name2		 = rs.getInt("name2");
            item.setName2(name2);
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
        AcodeCat item = (AcodeCat) obj;

        String ret = 
            "name1=" + item.getName1()
            + ",name2=" + item.getName2()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "name1,name2";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        AcodeCat item = (AcodeCat) obj;

        String ret = 
            "" + item.getName1()
            + "," + item.getName2()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        AcodeCat o = (AcodeCat) obj;
        o.setId(auto_id);
    }
}
