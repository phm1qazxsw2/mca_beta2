package phm.ezcounting;

// need to specify billitem.id=xx and billrecord.id=yy in the query


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillChargeItemMgr extends dbo.Manager<BillChargeItem>
{
    private static BillChargeItemMgr _instance = null;

    BillChargeItemMgr() {}

    public synchronized static BillChargeItemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillChargeItemMgr();
        }
        return _instance;
    }

    public BillChargeItemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billrecord join bill";
    }

    protected Object makeBean()
    {
        return new BillChargeItem();
    }

    protected String JoinSpace()
    {
         return "billrecord.billId=bill.id";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillChargeItem item = (BillChargeItem) obj;
        try {
            int	id		 = rs.getInt("chargeitem.id");
            item.setId(id);
            int	billItemId		 = rs.getInt("billitem.id");
            item.setBillItemId(billItemId);
            int	billRecordId		 = rs.getInt("billrecord.id");
            item.setBillRecordId(billRecordId);
            int	chargeAmount		 = rs.getInt("chargeAmount");
            item.setChargeAmount(chargeAmount);
            int	billId		 = rs.getInt("billId");
            item.setBillId(billId);
            String	name		 = rs.getString("billitem.name");
            item.setName(name);
            int	aliasId		 = rs.getInt("aliasId");
            item.setAliasId(aliasId);
            int	pitemId		 = rs.getInt("pitemId");
            item.setPitemId(pitemId);
            int	mySmallItemId		 = rs.getInt("chargeitem.smallItemId");
            item.setMySmallItemId(mySmallItemId);
            int	parentSmallItemId		 = rs.getInt("billitem.smallItemId");
            item.setParentSmallItemId(parentSmallItemId);
            int	status		 = rs.getInt("billitem.status");
            item.setStatus(status);
            String	description		 = rs.getString("description");
            item.setDescription(description);
            String	billName		 = rs.getString("bill.name");
            item.setBillName(billName);
            String	billRecordName		 = rs.getString("billrecord.name");
            item.setBillRecordName(billRecordName);
            int	defaultAmount		 = rs.getInt("defaultAmount");
            item.setDefaultAmount(defaultAmount);
            java.util.Date	month		 = rs.getTimestamp("month");
            item.setMonth(month);
            String	color		 = rs.getString("color");
            item.setColor(color);
            java.util.Date	billDate		 = rs.getTimestamp("billDate");
            item.setBillDate(billDate);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (billitem) ON billitem.billId=bill.id ";
        ret += "LEFT JOIN (chargeitem) ON chargeitem.billItemId=billitem.id and chargeitem.billRecordId=billrecord.id  ";
        return ret;
    }
}
