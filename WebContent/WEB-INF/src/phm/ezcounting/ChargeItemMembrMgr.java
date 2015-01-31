package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ChargeItemMembrMgr extends dbo.Manager<ChargeItemMembr>
{
    private static ChargeItemMembrMgr _instance = null;

    ChargeItemMembrMgr() {}

    public synchronized static ChargeItemMembrMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ChargeItemMembrMgr();
        }
        return _instance;
    }

    public ChargeItemMembrMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "chargeitem join charge join membr";
    }

    protected Object makeBean()
    {
        return new ChargeItemMembr();
    }

    protected String JoinSpace()
    {
         return "charge.chargeItemId=chargeitem.id and charge.membrId=membr.id";
    }

    protected String getFieldList()
    {
         return "membr.id,chargeItemId,chargeitem.billRecordId,billItemId,chargeAmount,charge.amount,billitem.name,userLoginId,charge.note,membr.name,paidStatus,printDate,ticketId,chargeitem.smallItemId,tagId,tag.name,billType,pitemNum,pitemId,aliasId,templateVchrId,userId,receivable,received,copyStatus";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ChargeItemMembr item = (ChargeItemMembr) obj;
        try {
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            int	chargeItemId		 = rs.getInt("chargeItemId");
            item.setChargeItemId(chargeItemId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            int	billItemId		 = rs.getInt("billItemId");
            item.setBillItemId(billItemId);
            int	chargeAmount		 = rs.getInt("chargeAmount");
            item.setChargeAmount(chargeAmount);
            int	amount		 = rs.getInt("charge.amount");
            item.setAmount(amount);
            String	chargeName_		 = rs.getString("billitem.name");
            item.setChargeName_(chargeName_);
            String	userLoginId		 = rs.getString("userLoginId");
            item.setUserLoginId(userLoginId);
            String	note		 = rs.getString("charge.note");
            item.setNote(note);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
            int	paidStatus		 = rs.getInt("paidStatus");
            item.setPaidStatus(paidStatus);
            long	printDate		 = 0;try { printDate = Long.parseLong(new String(rs.getBytes("printDate"))); } catch (Exception ee) {}
            item.setPrintDate(printDate);
            String	ticketId		 = rs.getString("ticketId");
            item.setTicketId(ticketId);
            int	smallItemId		 = rs.getInt("smallItemId");
            item.setSmallItemId(smallItemId);
            int	tagId		 = rs.getInt("tagId");
            item.setTagId(tagId);
            String	tagName		 = rs.getString("tag.name");
            item.setTagName(tagName);
            int	billType		 = rs.getInt("billType");
            item.setBillType(billType);
            int	pitemNum		 = rs.getInt("pitemNum");
            item.setPitemNum(pitemNum);
            int	pitemId		 = rs.getInt("pitemId");
            item.setPitemId(pitemId);
            int	aliasId		 = rs.getInt("aliasId");
            item.setAliasId(aliasId);
            int	templateVchrId		 = rs.getInt("templateVchrId");
            item.setTemplateVchrId(templateVchrId);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	receivable		 = rs.getInt("receivable");
            item.setReceivable(receivable);
            int	received		 = rs.getInt("received");
            item.setReceived(received);
            int	copyStatus		 = rs.getInt("copyStatus");
            item.setCopyStatus(copyStatus);
        }
        catch (Exception e)
        {
            throw e;
        }
    }

    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (membrbillrecord) ON chargeitem.billRecordId=membrbillrecord.billRecordId and membr.id=membrbillrecord.membrId ";
        ret += "LEFT JOIN (user) ON charge.userId=user.id ";
        ret += "LEFT JOIN (tag) ON tagId=tag.id ";
        ret += "LEFT JOIN (billitem) ON chargeitem.billItemId=billitem.id ";
        ret += "LEFT JOIN (bill) ON bill.id=billitem.billId ";
        return ret;
    }
}
