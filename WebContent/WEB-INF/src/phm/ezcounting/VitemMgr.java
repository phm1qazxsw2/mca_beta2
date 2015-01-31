package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class VitemMgr extends dbo.Manager<Vitem>
{
    private static VitemMgr _instance = null;

    VitemMgr() {}

    public synchronized static VitemMgr getInstance()
    {
        if (_instance==null) {
            _instance = new VitemMgr();
        }
        return _instance;
    }

    public VitemMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "vitem";
    }

    protected Object makeBean()
    {
        return new Vitem();
    }

    protected String getIdentifier(Object obj)
    {
        Vitem o = (Vitem) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Vitem item = (Vitem) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            java.util.Date	createTime		 = rs.getTimestamp("createTime");
            item.setCreateTime(createTime);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            String	title		 = rs.getString("title");
            item.setTitle(title);
            int	type		 = rs.getInt("type");
            item.setType(type);
            String	acctcode		 = rs.getString("acctcode");
            item.setAcctcode(acctcode);
            int	total		 = rs.getInt("total");
            item.setTotal(total);
            int	realized		 = rs.getInt("realized");
            item.setRealized(realized);
            int	paidstatus		 = rs.getInt("paidstatus");
            item.setPaidstatus(paidstatus);
            int	attachtype		 = rs.getInt("attachtype");
            item.setAttachtype(attachtype);
            int	verifystatus		 = rs.getInt("verifystatus");
            item.setVerifystatus(verifystatus);
            java.util.Date	verifyDate		 = rs.getTimestamp("verifyDate");
            item.setVerifyDate(verifyDate);
            int	verifyUserId		 = rs.getInt("verifyUserId");
            item.setVerifyUserId(verifyUserId);
            int	costTradeId		 = rs.getInt("costTradeId");
            item.setCostTradeId(costTradeId);
            int	voucherId		 = rs.getInt("voucherId");
            item.setVoucherId(voucherId);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	orgtype		 = rs.getInt("orgtype");
            item.setOrgtype(orgtype);
            int	orgId		 = rs.getInt("orgId");
            item.setOrgId(orgId);
            int	pending		 = rs.getInt("pending");
            item.setPending(pending);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
            int	bunitId		 = rs.getInt("bunitId");
            item.setBunitId(bunitId);
            String	receiptNo		 = rs.getString("receiptNo");
            item.setReceiptNo(receiptNo);
            String	payerName		 = rs.getString("payerName");
            item.setPayerName(payerName);
            String	cashAcct		 = rs.getString("cashAcct");
            item.setCashAcct(cashAcct);
            String	checkInfo		 = rs.getString("checkInfo");
            item.setCheckInfo(checkInfo);
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
        Vitem item = (Vitem) obj;

        String ret = 
            "userId=" + item.getUserId()
            + ",createTime=" + (((d=item.getCreateTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",title='" + ServerTool.escapeString(item.getTitle()) + "'"
            + ",type=" + item.getType()
            + ",acctcode='" + ServerTool.escapeString(item.getAcctcode()) + "'"
            + ",total=" + item.getTotal()
            + ",realized=" + item.getRealized()
            + ",paidstatus=" + item.getPaidstatus()
            + ",attachtype=" + item.getAttachtype()
            + ",verifystatus=" + item.getVerifystatus()
            + ",verifyDate=" + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",verifyUserId=" + item.getVerifyUserId()
            + ",costTradeId=" + item.getCostTradeId()
            + ",voucherId=" + item.getVoucherId()
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",orgtype=" + item.getOrgtype()
            + ",orgId=" + item.getOrgId()
            + ",pending=" + item.getPending()
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()
            + ",receiptNo='" + ServerTool.escapeString(item.getReceiptNo()) + "'"
            + ",payerName='" + ServerTool.escapeString(item.getPayerName()) + "'"
            + ",cashAcct='" + ServerTool.escapeString(item.getCashAcct()) + "'"
            + ",checkInfo='" + ServerTool.escapeString(item.getCheckInfo()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "userId,createTime,recordTime,title,type,acctcode,total,realized,paidstatus,attachtype,verifystatus,verifyDate,verifyUserId,costTradeId,voucherId,note,orgtype,orgId,pending,threadId,bunitId,receiptNo,payerName,cashAcct,checkInfo";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Vitem item = (Vitem) obj;

        String ret = 
            "" + item.getUserId()
            + "," + (((d=item.getCreateTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getTitle()) + "'"
            + "," + item.getType()
            + ",'" + ServerTool.escapeString(item.getAcctcode()) + "'"
            + "," + item.getTotal()
            + "," + item.getRealized()
            + "," + item.getPaidstatus()
            + "," + item.getAttachtype()
            + "," + item.getVerifystatus()
            + "," + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getVerifyUserId()
            + "," + item.getCostTradeId()
            + "," + item.getVoucherId()
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getOrgtype()
            + "," + item.getOrgId()
            + "," + item.getPending()
            + "," + item.getThreadId()
            + "," + item.getBunitId()
            + ",'" + ServerTool.escapeString(item.getReceiptNo()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayerName()) + "'"
            + ",'" + ServerTool.escapeString(item.getCashAcct()) + "'"
            + ",'" + ServerTool.escapeString(item.getCheckInfo()) + "'"

        ;
        return ret;
    }
    protected boolean isAutoId()
    {
        return true;
    }

    protected void setAutoId(Object obj, int auto_id)
    {
        Vitem o = (Vitem) obj;
        o.setId(auto_id);
    }
}
