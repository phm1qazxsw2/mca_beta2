package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TagMembrBillRecordShortMgr extends dbo.Manager<TagMembrBillRecordShort>
{
    private static TagMembrBillRecordShortMgr _instance = null;

    TagMembrBillRecordShortMgr() {}

    public synchronized static TagMembrBillRecordShortMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TagMembrBillRecordShortMgr();
        }
        return _instance;
    }

    public TagMembrBillRecordShortMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "membr";
    }

    protected Object makeBean()
    {
        return new TagMembrBillRecordShort();
    }

    protected String getFieldList()
    {
         return "tag.id,membr.id,membr.name,billRecordId,receivable,received,membrbillrecord.paidStatus,billType,privLevel";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TagMembrBillRecordShort item = (TagMembrBillRecordShort) obj;
        try {
            int	tagId		 = rs.getInt("tag.id");
            item.setTagId(tagId);
            int	billRecordId		 = rs.getInt("billRecordId");
            item.setBillRecordId(billRecordId);
            int	membrId		 = rs.getInt("membr.id");
            item.setMembrId(membrId);
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
            int	receivable		 = rs.getInt("receivable");
            item.setReceivable(receivable);
            int	received		 = rs.getInt("received");
            item.setReceived(received);
            int	paidStatus		 = rs.getInt("paidStatus");
            item.setPaidStatus(paidStatus);
            int	billType		 = rs.getInt("billType");
            item.setBillType(billType);
            int	privLevel		 = rs.getInt("privLevel");
            item.setPrivLevel(privLevel);
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
        TagMembrBillRecordShort item = (TagMembrBillRecordShort) obj;

        String ret = 
            "tagId=" + item.getTagId()
            + ",billRecordId=" + item.getBillRecordId()
            + ",membrId=" + item.getMembrId()
            + ",membrName='" + ServerTool.escapeString(item.getMembrName()) + "'"
            + ",receivable=" + item.getReceivable()
            + ",received=" + item.getReceived()
            + ",paidStatus=" + item.getPaidStatus()
            + ",billType=" + item.getBillType()
            + ",privLevel=" + item.getPrivLevel()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "tagId,billRecordId,membrId,membrName,receivable,received,paidStatus,billType,privLevel";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TagMembrBillRecordShort item = (TagMembrBillRecordShort) obj;

        String ret = 
            "" + item.getTagId()
            + "," + item.getBillRecordId()
            + "," + item.getMembrId()
            + ",'" + ServerTool.escapeString(item.getMembrName()) + "'"
            + "," + item.getReceivable()
            + "," + item.getReceived()
            + "," + item.getPaidStatus()
            + "," + item.getBillType()
            + "," + item.getPrivLevel()

        ;
        return ret;
    }
    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (membrbillrecord) ON membr.id=membrbillrecord.membrId ";
        ret += "LEFT JOIN (tag,tagmembr) ON tagmembr.tagId=tag.id and tagmembr.membrId=membr.id ";
        ret += "LEFT JOIN (bill,billrecord) ON membrbillrecord.billRecordId=billrecord.id and billrecord.billId=bill.id ";
        return ret;
    }
}
