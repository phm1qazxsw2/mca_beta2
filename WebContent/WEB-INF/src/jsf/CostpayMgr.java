package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CostpayMgr extends Manager
{
    private static CostpayMgr _instance = null;

    CostpayMgr() {}

    public synchronized static CostpayMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CostpayMgr();
        }
        return _instance;
    }

    public CostpayMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costpay";
    }

    protected Object makeBean()
    {
        return new Costpay();
    }

    protected int getBeanId(Object obj)
    {
        return ((Costpay)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costpay item = (Costpay) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	costpayDate		 = rs.getTimestamp("costpayDate");
            int	costpaySide		 = rs.getInt("costpaySide");
            int	costpaySideID		 = rs.getInt("costpaySideID");
            int	costpayFeeticketID		 = rs.getInt("costpayFeeticketID");
            int	costpayFeePayFeeID		 = rs.getInt("costpayFeePayFeeID");
            int	costpayOwnertradeStatus		 = rs.getInt("costpayOwnertradeStatus");
            int	costpayOwnertradeId		 = rs.getInt("costpayOwnertradeId");
            int	costpaySalaryTicketId		 = rs.getInt("costpaySalaryTicketId");
            int	costpaySalaryBankId		 = rs.getInt("costpaySalaryBankId");
            int	costpayNumberInOut		 = rs.getInt("costpayNumberInOut");
            int	costpayPayway		 = rs.getInt("costpayPayway");
            int	costpayAccountType		 = rs.getInt("costpayAccountType");
            int	costpayAccountId		 = rs.getInt("costpayAccountId");
            int	costpayCostNumber		 = rs.getInt("costpayCostNumber");
            int	costpayIncomeNumber		 = rs.getInt("costpayIncomeNumber");
            int	costpayLogWay		 = rs.getInt("costpayLogWay");
            java.util.Date	costpayLogDate		 = rs.getTimestamp("costpayLogDate");
            int	costpayLogId		 = rs.getInt("costpayLogId");
            String	costpayLogPs		 = rs.getString("costpayLogPs");
            int	costpayBanklog		 = rs.getInt("costpayBanklog");
            int	costpayChequeId		 = rs.getInt("costpayChequeId");
            int	costpayCostbookId		 = rs.getInt("costpayCostbookId");
            int	costpayCostCheckId		 = rs.getInt("costpayCostCheckId");
            int	costpayVerifyStatus		 = rs.getInt("costpayVerifyStatus");
            java.util.Date	costpayVerifyDate		 = rs.getTimestamp("costpayVerifyDate");
            int	costpayVerifyId		 = rs.getInt("costpayVerifyId");
            String	costpayVerifyPs		 = rs.getString("costpayVerifyPs");
            int	costpayStudentAccountId		 = rs.getInt("costpayStudentAccountId");
            int	exRateId		 = rs.getInt("exRateId");
            double	exrate		 = rs.getDouble("exrate");
            double	orgAmount		 = rs.getDouble("orgAmount");
            String	checkInfo		 = rs.getString("checkInfo");
            String	receiptNo		 = rs.getString("receiptNo");
            String	payerName		 = rs.getString("payerName");
            int	threadId		 = rs.getInt("threadId");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , costpayDate, costpaySide, costpaySideID
            , costpayFeeticketID, costpayFeePayFeeID, costpayOwnertradeStatus
            , costpayOwnertradeId, costpaySalaryTicketId, costpaySalaryBankId
            , costpayNumberInOut, costpayPayway, costpayAccountType
            , costpayAccountId, costpayCostNumber, costpayIncomeNumber
            , costpayLogWay, costpayLogDate, costpayLogId
            , costpayLogPs, costpayBanklog, costpayChequeId
            , costpayCostbookId, costpayCostCheckId, costpayVerifyStatus
            , costpayVerifyDate, costpayVerifyId, costpayVerifyPs
            , costpayStudentAccountId, exRateId, exrate
            , orgAmount, checkInfo, receiptNo
            , payerName, threadId, bunitId
            );
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
        Costpay item = (Costpay) obj;

        String ret = "modified=NOW()"
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
         return "created, modified, costpayDate, costpaySide, costpaySideID, costpayFeeticketID, costpayFeePayFeeID, costpayOwnertradeStatus, costpayOwnertradeId, costpaySalaryTicketId, costpaySalaryBankId, costpayNumberInOut, costpayPayway, costpayAccountType, costpayAccountId, costpayCostNumber, costpayIncomeNumber, costpayLogWay, costpayLogDate, costpayLogId, costpayLogPs, costpayBanklog, costpayChequeId, costpayCostbookId, costpayCostCheckId, costpayVerifyStatus, costpayVerifyDate, costpayVerifyId, costpayVerifyPs, costpayStudentAccountId, exRateId, exrate, orgAmount, checkInfo, receiptNo, payerName, threadId, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costpay item = (Costpay) obj;

        String ret = "NOW(), NOW()"
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
}
