package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class DiscountMgr extends dbo.Manager<Discount>
{
    private static DiscountMgr _instance = null;

    DiscountMgr() {}

    public synchronized static DiscountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new DiscountMgr();
        }
        return _instance;
    }

    public DiscountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "discount";
    }

    protected Object makeBean()
    {
        return new Discount();
    }

    protected String getIdentifier(Object obj)
    {
        Discount o = (Discount) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Discount item = (Discount) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
            int	type		 = rs.getInt("type");
            item.setType(type);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	copy		 = rs.getInt("copy");
            item.setCopy(copy);
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
        Discount item = (Discount) obj;

        String ret = 
            "chargeItemId=" + item.getChargeItemId()
            + ",membrId=" + item.getMembrId()
            + ",userId=" + item.getUserId()
            + ",amount=" + item.getAmount()
            + ",type=" + item.getType()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",copy=" + item.getCopy()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "chargeItemId,membrId,userId,amount,type,note,copy";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Discount item = (Discount) obj;

        String ret = 
            "" + item.getChargeItemId()
            + "," + item.getMembrId()
            + "," + item.getUserId()
            + "," + item.getAmount()
            + "," + item.getType()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getCopy()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Discount o = (Discount) obj;
        o.setId(auto_id);
    }
}
