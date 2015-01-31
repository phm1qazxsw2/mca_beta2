package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ChargeMgr extends dbo.Manager<Charge>
{
    private static ChargeMgr _instance = null;

    ChargeMgr() {}

    public synchronized static ChargeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ChargeMgr();
        }
        return _instance;
    }

    public ChargeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "charge";
    }

    protected Object makeBean()
    {
        return new Charge();
    }

    protected String getIdentifier(Object obj)
    {
        Charge o = (Charge) obj;
        return "chargeItemId = " + o.getChargeItemId() + " and " + "membrId = " + o.getMembrId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Charge item = (Charge) obj;
        try {
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            int	pitemNum		 = rs.getInt("pitemNum");
            item.setPitemNum(pitemNum);
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
        Charge item = (Charge) obj;

        String ret = 
            "chargeItemId=" + item.getChargeItemId()
            + ",membrId=" + item.getMembrId()
            + ",amount=" + item.getAmount()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",userId=" + item.getUserId()
            + ",tagId=" + item.getTagId()
            + ",pitemNum=" + item.getPitemNum()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "chargeItemId,membrId,amount,note,userId,tagId,pitemNum";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Charge item = (Charge) obj;

        String ret = 
            "" + item.getChargeItemId()
            + "," + item.getMembrId()
            + "," + item.getAmount()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getUserId()
            + "," + item.getTagId()
            + "," + item.getPitemNum()

        ;
        return ret;
    }
}
