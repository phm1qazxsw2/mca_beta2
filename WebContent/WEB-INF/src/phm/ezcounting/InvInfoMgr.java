package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class InvInfoMgr extends dbo.Manager<InvInfo>
{
    private static InvInfoMgr _instance = null;

    InvInfoMgr() {}

    public synchronized static InvInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new InvInfoMgr();
        }
        return _instance;
    }

    public InvInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "inventory";
    }

    protected Object makeBean()
    {
        return new InvInfo();
    }

    protected String getFieldList()
    {
         return "sum(quantity) as quantity,sum(totalPrice) as cost,pitemId";
    }

    protected String getIdentifier(Object obj)
    {
        InvInfo o = (InvInfo) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        InvInfo item = (InvInfo) obj;
        try {
            int	quantity		 = rs.getInt("quantity");
            item.setQuantity(quantity);
            int	cost		 = rs.getInt("cost");
            item.setCost(cost);
            int	pitemId		 = rs.getInt("pitemId");
            item.setPitemId(pitemId);
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
        InvInfo item = (InvInfo) obj;

        String ret = 
            "quantity=" + item.getQuantity()
            + ",cost=" + item.getCost()
            + ",pitemId=" + item.getPitemId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "quantity,cost,pitemId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        InvInfo item = (InvInfo) obj;

        String ret = 
            "" + item.getQuantity()
            + "," + item.getCost()
            + "," + item.getPitemId()

        ;
        return ret;
    }
}
