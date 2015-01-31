package phm.ezcounting;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class Costpay2Mgr extends dbo.Manager<Costpay2>
{
    private static Costpay2Mgr _instance = null;

    Costpay2Mgr() {}

    public synchronized static Costpay2Mgr getInstance()
    {
        if (_instance==null) {
            _instance = new Costpay2Mgr();
        }
        return _instance;
    }

    public Costpay2Mgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costpay";
    }

    protected Object makeBean()
    {
        return new Costpay2();
    }

    protected String getIdentifier(Object obj)
    {
        Costpay2 o = (Costpay2) obj;
        return "id = " + o.getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costpay2 item = (Costpay2) obj;
        try {
            int	id		 = rs.getInt("id");
            item.setId(id);
            java.util.Date	created		 = rs.getTimestamp("created");
            item.setCreated(created);
            java.util.Date	modified		 = rs.getTimestamp("modified");
            item.setModified(modified);
            java.util.Date	costpayDate		 = rs.getTimestamp("costpayDate");
            item.setCostpayDate(costpayDate);
            int	costpaySide		 = rs.getInt("costpaySide");
            item.setCostpaySide(costpaySide);
            int	costpaySideID		 = rs.getInt("costpaySideID");
            item.setCostpaySideID(costpaySideID);
            int	costpayFeeticketID		 = rs.getInt("costpayFeeticketID");
            item.setCostpayFeeticketID(costpayFeeticketID);
            int	costpayFeePayFeeID		 = rs.getInt("costpayFeePayFeeID");
            item.setCostpayFeePayFeeID(costpayFeePayFeeID);
            int	costpayOwnertradeStatus		 = rs.getInt("costpayOwnertradeStatus");
            item.setCostpayOwnertradeStatus(costpayOwnertradeStatus);
            int	costpayOwnertradeId		 = rs.getInt("costpayOwnertradeId");
            item.setCostpayOwnertradeId(costpayOwnertradeId);
            int	costpaySalaryTicketId		 = rs.getInt("costpaySalaryTicketId");
            item.setCostpaySalaryTicketId(costpaySalaryTicketId);
            int	costpaySalaryBankId		 = rs.getInt("costpaySalaryBankId");
            item.setCostpaySalaryBankId(costpaySalaryBankId);
            int	costpayNumberInOut		 = rs.getInt("costpayNumberInOut");
            item.setCostpayNumberInOut(costpayNumberInOut);
            int	costpayPayway		 = rs.getInt("costpayPayway");
            item.setCostpayPayway(costpayPayway);
            int	costpayAccountType		 = rs.getInt("costpayAccountType");
            item.setCostpayAccountType(costpayAccountType);
            int	costpayAccountId		 = rs.getInt("costpayAccountId");
            item.setCostpayAccountId(costpayAccountId);
            int	costpayCostNumber		 = rs.getInt("costpayCostNumber");
            item.setCostpayCostNumber(costpayCostNumber);
            int	costpayIncomeNumber		 = rs.getInt("costpayIncomeNumber");
            item.setCostpayIncomeNumber(costpayIncomeNumber);
            int	costpayLogWay		 = rs.getInt("costpayLogWay");
            item.setCostpayLogWay(costpayLogWay);
            java.util.Date	costpayLogDate		 = rs.getTimestamp("costpayLogDate");
            item.setCostpayLogDate(costpayLogDate);
            int	costpayLogId		 = rs.getInt("costpayLogId");
            item.setCostpayLogId(costpayLogId);
            String	costpayLogPs		 = rs.getString("costpayLogPs");
            item.setCostpayLogPs(costpayLogPs);
            int	costpayBanklog		 = rs.getInt("costpayBanklog");
            item.setCostpayBanklog(costpayBanklog);
            int	costpayChequeId		 = rs.getInt("costpayChequeId");
            item.setCostpayChequeId(costpayChequeId);
            int	costpayCostbookId		 = rs.getInt("costpayCostbookId");
            item.setCostpayCostbookId(costpayCostbookId);
            int	costpayCostCheckId		 = rs.getInt("costpayCostCheckId");
            item.setCostpayCostCheckId(costpayCostCheckId);
            int	costpayVerifyStatus		 = rs.getInt("costpayVerifyStatus");
            item.setCostpayVerifyStatus(costpayVerifyStatus);
            java.util.Date	costpayVerifyDate		 = rs.getTimestamp("costpayVerifyDate");
            item.setCostpayVerifyDate(costpayVerifyDate);
            int	costpayVerifyId		 = rs.getInt("costpayVerifyId");
            item.setCostpayVerifyId(costpayVerifyId);
            String	costpayVerifyPs		 = rs.getString("costpayVerifyPs");
            item.setCostpayVerifyPs(costpayVerifyPs);
            int	costpayStudentAccountId		 = rs.getInt("costpayStudentAccountId");
            item.setCostpayStudentAccountId(costpayStudentAccountId);
            int	exRateId		 = rs.getInt("exRateId");
            item.setExRateId(exRateId);
            double	exrate		 = rs.getDouble("exrate");
            item.setExrate(exrate);
            double	orgAmount		 = rs.getDouble("orgAmount");
            item.setOrgAmount(orgAmount);
            String	checkInfo		 = rs.getString("checkInfo");
            item.setCheckInfo(checkInfo);
            String	receiptNo		 = rs.getString("receiptNo");
            item.setReceiptNo(receiptNo);
            String	payerName		 = rs.getString("payerName");
            item.setPayerName(payerName);
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
        Costpay2 item = (Costpay2) obj;

        String ret = 
            "created=" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",modified=" + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costpayDate=" + (((d=item.getCostpayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costpaySide=" + item.getCostpaySide()
            + ",costpaySideID=" + item.getCostpaySideID()
            + ",costpayFeeticketID=" + item.getCostpayFeeticketID()
            + ",costpayFeePayFeeID=" + item.getCostpayFeePayFeeID()
            + ",costpayOwnertradeStatus=" + item.getCostpayOwnertradeStatus()
            + ",costpayOwnertradeId=" + item.getCostpayOwnertradeId()
            + ",costpaySalaryTicketId=" + item.getCostpaySalaryTicketId()
            + ",costpaySalaryBankId=" + item.getCostpaySalaryBankId()
            + ",costpayNumberInOut=" + item.getCostpayNumberInOut()
            + ",costpayPayway=" + item.getCostpayPayway()
            + ",costpayAccountType=" + item.getCostpayAccountType()
            + ",costpayAccountId=" + item.getCostpayAccountId()
            + ",costpayCostNumber=" + item.getCostpayCostNumber()
            + ",costpayIncomeNumber=" + item.getCostpayIncomeNumber()
            + ",costpayLogWay=" + item.getCostpayLogWay()
            + ",costpayLogDate=" + (((d=item.getCostpayLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costpayLogId=" + item.getCostpayLogId()
            + ",costpayLogPs='" + ServerTool.escapeString(item.getCostpayLogPs()) + "'"
            + ",costpayBanklog=" + item.getCostpayBanklog()
            + ",costpayChequeId=" + item.getCostpayChequeId()
            + ",costpayCostbookId=" + item.getCostpayCostbookId()
            + ",costpayCostCheckId=" + item.getCostpayCostCheckId()
            + ",costpayVerifyStatus=" + item.getCostpayVerifyStatus()
            + ",costpayVerifyDate=" + (((d=item.getCostpayVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costpayVerifyId=" + item.getCostpayVerifyId()
            + ",costpayVerifyPs='" + ServerTool.escapeString(item.getCostpayVerifyPs()) + "'"
            + ",costpayStudentAccountId=" + item.getCostpayStudentAccountId()
            + ",exRateId=" + item.getExRateId()
            + ",exrate=" + item.getExrate()
            + ",orgAmount=" + item.getOrgAmount()
            + ",checkInfo='" + ServerTool.escapeString(item.getCheckInfo()) + "'"
            + ",receiptNo='" + ServerTool.escapeString(item.getReceiptNo()) + "'"
            + ",payerName='" + ServerTool.escapeString(item.getPayerName()) + "'"
            + ",threadId=" + item.getThreadId()
            + ",bunitId=" + item.getBunitId()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "created,modified,costpayDate,costpaySide,costpaySideID,costpayFeeticketID,costpayFeePayFeeID,costpayOwnertradeStatus,costpayOwnertradeId,costpaySalaryTicketId,costpaySalaryBankId,costpayNumberInOut,costpayPayway,costpayAccountType,costpayAccountId,costpayCostNumber,costpayIncomeNumber,costpayLogWay,costpayLogDate,costpayLogId,costpayLogPs,costpayBanklog,costpayChequeId,costpayCostbookId,costpayCostCheckId,costpayVerifyStatus,costpayVerifyDate,costpayVerifyId,costpayVerifyPs,costpayStudentAccountId,exRateId,exrate,orgAmount,checkInfo,receiptNo,payerName,threadId,bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costpay2 item = (Costpay2) obj;

        String ret = 
            "" + (((d=item.getCreated())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getModified())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getCostpayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCostpaySide()
            + "," + item.getCostpaySideID()
            + "," + item.getCostpayFeeticketID()
            + "," + item.getCostpayFeePayFeeID()
            + "," + item.getCostpayOwnertradeStatus()
            + "," + item.getCostpayOwnertradeId()
            + "," + item.getCostpaySalaryTicketId()
            + "," + item.getCostpaySalaryBankId()
            + "," + item.getCostpayNumberInOut()
            + "," + item.getCostpayPayway()
            + "," + item.getCostpayAccountType()
            + "," + item.getCostpayAccountId()
            + "," + item.getCostpayCostNumber()
            + "," + item.getCostpayIncomeNumber()
            + "," + item.getCostpayLogWay()
            + "," + (((d=item.getCostpayLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCostpayLogId()
            + ",'" + ServerTool.escapeString(item.getCostpayLogPs()) + "'"
            + "," + item.getCostpayBanklog()
            + "," + item.getCostpayChequeId()
            + "," + item.getCostpayCostbookId()
            + "," + item.getCostpayCostCheckId()
            + "," + item.getCostpayVerifyStatus()
            + "," + (((d=item.getCostpayVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCostpayVerifyId()
            + ",'" + ServerTool.escapeString(item.getCostpayVerifyPs()) + "'"
            + "," + item.getCostpayStudentAccountId()
            + "," + item.getExRateId()
            + "," + item.getExrate()
            + "," + item.getOrgAmount()
            + ",'" + ServerTool.escapeString(item.getCheckInfo()) + "'"
            + ",'" + ServerTool.escapeString(item.getReceiptNo()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayerName()) + "'"
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
        Costpay2 o = (Costpay2) obj;
        o.setId(auto_id);
    }
}
