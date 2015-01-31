package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BillPayInfoMgr extends dbo.Manager<BillPayInfo>
{
    private static BillPayInfoMgr _instance = null;

    BillPayInfoMgr() {}

    public synchronized static BillPayInfoMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BillPayInfoMgr();
        }
        return _instance;
    }

    public BillPayInfoMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "billpay";
    }

    protected Object makeBean()
    {
        return new BillPayInfo();
    }

    protected String getFieldList()
    {
         return "billpay.id,via,recordTime,createTime,amount,remain,membrId,userId,billSourceId,membr.name,chequeId,pending,refundCostPayId,exportDate,exportUserId,verifyStatus,verifyId,verifyDate,note,threadId";
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BillPayInfo item = (BillPayInfo) obj;
        try {
            int	id		 = rs.getInt("billpay.id");
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
            String	membrName		 = rs.getString("membr.name");
            item.setMembrName(membrName);
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
        BillPayInfo item = (BillPayInfo) obj;

        String ret = 
            "id=" + item.getId()
            + ",via=" + item.getVia()
            + ",recordTime=" + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",createTime=" + (((d=item.getCreateTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",amount=" + item.getAmount()
            + ",remain=" + item.getRemain()
            + ",membrId=" + item.getMembrId()
            + ",userId=" + item.getUserId()
            + ",billSourceId=" + item.getBillSourceId()
            + ",membrName='" + ServerTool.escapeString(item.getMembrName()) + "'"
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

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "id,via,recordTime,createTime,amount,remain,membrId,userId,billSourceId,membrName,chequeId,pending,refundCostPayId,exportDate,exportUserId,verifyStatus,verifyId,verifyDate,note,threadId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BillPayInfo item = (BillPayInfo) obj;

        String ret = 
            "" + item.getId()
            + "," + item.getVia()
            + "," + (((d=item.getRecordTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getCreateTime())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getAmount()
            + "," + item.getRemain()
            + "," + item.getMembrId()
            + "," + item.getUserId()
            + "," + item.getBillSourceId()
            + ",'" + ServerTool.escapeString(item.getMembrName()) + "'"
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

        ;
        return ret;
    }
    protected String getLeftJoins()
    {
        String ret = "";
        ret += "LEFT JOIN (membr) ON membrId=membr.id ";
        return ret;
    }
}
