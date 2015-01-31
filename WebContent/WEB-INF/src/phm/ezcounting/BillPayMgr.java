package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillPayMgr extends dbo.Manager<BillPay>
{
    private static BillPayMgr _instance = null;

    BillPayMgr() {}

    public synchronized static BillPayMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillPayMgr();
        }
        return _instance;
    }

    public BillPayMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billpay";
    }

    protected Object makeBean()
    {
        return new BillPay();
    }

    protected String getIdentifier(Object obj)
    {
        BillPay o = (BillPay) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillPay item = (BillPay) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            int	via		 = rs.getInt("via");
            item.setVia(via);
            java.util.Date	recordTime		 = rs.getTimestamp("recordTime");
            item.setRecordTime(recordTime);
            java.util.Date	createTime		 = rs.getTimestamp("createTime");
            item.setCreateTime(createTime);
            int	amount		 = rs.getInt("amount");
            item.setAmount(amount);
            int	remain		 = rs.getInt("remain");
            item.setRemain(remain);
            int	membrId		 = rs.getInt("membrId");
            item.setMembrId(membrId);
            int	userId		 = rs.getInt("userId");
            item.setUserId(userId);
            int	billSourceId		 = rs.getInt("billSourceId");
            item.setBillSourceId(billSourceId);
            int	chequeId		 = rs.getInt("chequeId");
            item.setChequeId(chequeId);
            int	pending		 = rs.getInt("pending");
            item.setPending(pending);
            int	refundCostPayId		 = rs.getInt("refundCostPayId");
            item.setRefundCostPayId(refundCostPayId);
            long	exportDate		 = 0;try { exportDate = Long.parseLong(new String(rs.getBytes("exportDate"))); } catch (Exception ee) {}
            item.setExportDate(exportDate);
            int	exportUserId		 = rs.getInt("exportUserId");
            item.setExportUserId(exportUserId);
            int	verifyStatus		 = rs.getInt("verifyStatus");
            item.setVerifyStatus(verifyStatus);
            int	verifyId		 = rs.getInt("verifyId");
            item.setVerifyId(verifyId);
            java.util.Date	verifyDate		 = rs.getTimestamp("verifyDate");
            item.setVerifyDate(verifyDate);
            String	note		 = rs.getString("note");
            item.setNote(note);
            int	threadId		 = rs.getInt("threadId");
            item.setThreadId(threadId);
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
        BillPay item = (BillPay) obj;

        String ret = 
            "via=" + item.getVia()
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",createTime=" + (((d=item.getCreateTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",amount=" + item.getAmount()
            + ",remain=" + item.getRemain()
            + ",membrId=" + item.getMembrId()
            + ",userId=" + item.getUserId()
            + ",billSourceId=" + item.getBillSourceId()
            + ",chequeId=" + item.getChequeId()
            + ",pending=" + item.getPending()
            + ",refundCostPayId=" + item.getRefundCostPayId()
            + ",exportDate=" + item.getExportDate()
            + ",exportUserId=" + item.getExportUserId()
            + ",verifyStatus=" + item.getVerifyStatus()
            + ",verifyId=" + item.getVerifyId()
            + ",verifyDate=" + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",note='" + ServerTool.escapeString(item.getNote()) + "'"
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "via,recordTime,createTime,amount,remain,membrId,userId,billSourceId,chequeId,pending,refundCostPayId,exportDate,exportUserId,verifyStatus,verifyId,verifyDate,note,threadId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillPay item = (BillPay) obj;

        String ret = 
            "" + item.getVia()
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getCreateTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getAmount()
            + "," + item.getRemain()
            + "," + item.getMembrId()
            + "," + item.getUserId()
            + "," + item.getBillSourceId()
            + "," + item.getChequeId()
            + "," + item.getPending()
            + "," + item.getRefundCostPayId()
            + "," + item.getExportDate()
            + "," + item.getExportUserId()
            + "," + item.getVerifyStatus()
            + "," + item.getVerifyId()
            + "," + (((d=item.getVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getNote()) + "'"
            + "," + item.getThreadId()
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
        BillPay o = (BillPay) obj;
        o.setId(auto_id);
    }
}
