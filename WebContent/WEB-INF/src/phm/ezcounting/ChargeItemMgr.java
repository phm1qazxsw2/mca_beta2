package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ChargeItemMgr extends dbo.Manager<ChargeItem>
{
    private static ChargeItemMgr _instance = null;

    ChargeItemMgr() {}

    public synchronized static ChargeItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ChargeItemMgr();
        }
        return _instance;
    }

    public ChargeItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "chargeitem";
    }

    protected Object makeBean()
    {
        return new ChargeItem();
    }

    protected String getIdentifier(Object obj)
    {
        ChargeItem o = (ChargeItem) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ChargeItem item = (ChargeItem) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	billItemId		 = rs.getInt("billItemId");
            item.setBillItemId(billItemId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            int	smallItemId		 = rs.getInt("smallItemId");
            item.setSmallItemId(smallItemId);
            int	chargeAmount		 = rs.getInt("chargeAmount");
            item.setChargeAmount(chargeAmount);
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
        ChargeItem item = (ChargeItem) obj;

        String ret = 
            "billItemId=" + item.getBillItemId()
            + ",billRecordId=" + item.getBillRecordId()
            + ",smallItemId=" + item.getSmallItemId()
            + ",chargeAmount=" + item.getChargeAmount()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "billItemId,billRecordId,smallItemId,chargeAmount";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ChargeItem item = (ChargeItem) obj;

        String ret = 
            "" + item.getBillItemId()
            + "," + item.getBillRecordId()
            + "," + item.getSmallItemId()
            + "," + item.getChargeAmount()

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        ChargeItem o = (ChargeItem) obj;
        o.setId(auto_id);
    }
}
