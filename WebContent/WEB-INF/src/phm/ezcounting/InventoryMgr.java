package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class InventoryMgr extends dbo.Manager<Inventory>
{
    private static InventoryMgr _instance = null;

    InventoryMgr() {}

    public synchronized static InventoryMgr getInstance()
    {
        if (_instance==null) {
            _instance = new InventoryMgr();
        }
        return _instance;
    }

    public InventoryMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "inventory";
    }

    protected Object makeBean()
    {
        return new Inventory();
    }

    protected String getIdentifier(Object obj)
    {
        Inventory o = (Inventory) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Inventory item = (Inventory) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	pitemId		 = rs.getInt("pitemId");
            item.setPitemId(pitemId);
            java.util.Date	orderDate		 = rs.getTimestamp("orderDate");
            item.setOrderDate(orderDate);
            int	quantity		 = rs.getInt("quantity");
            item.setQuantity(quantity);
            int	totalPrice		 = rs.getInt("totalPrice");
            item.setTotalPrice(totalPrice);
            int	traderId		 = rs.getInt("traderId");
            item.setTraderId(traderId);
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
        Inventory item = (Inventory) obj;

        String ret = 
            "pitemId=" + item.getPitemId()
            + ",orderDate=" + (((d=item.getOrderDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",quantity=" + item.getQuantity()
            + ",totalPrice=" + item.getTotalPrice()
            + ",traderId=" + item.getTraderId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "pitemId,orderDate,quantity,totalPrice,traderId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Inventory item = (Inventory) obj;

        String ret = 
            "" + item.getPitemId()
            + "," + (((d=item.getOrderDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getQuantity()
            + "," + item.getTotalPrice()
            + "," + item.getTraderId()
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
        Inventory o = (Inventory) obj;
        o.setId(auto_id);
    }
}
