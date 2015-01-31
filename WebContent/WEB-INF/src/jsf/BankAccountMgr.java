package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class BankAccountMgr extends Manager
{
    private static BankAccountMgr _instance = null;

    BankAccountMgr() {}

    public synchronized static BankAccountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new BankAccountMgr();
        }
        return _instance;
    }

    public BankAccountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "bankaccount";
    }

    protected Object makeBean()
    {
        return new BankAccount();
    }

    protected int getBeanId(Object obj)
    {
        return ((BankAccount)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        BankAccount item = (BankAccount) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	bankAccountName		 = rs.getString("bankAccountName");
            String	bankAccountId		 = rs.getString("bankAccountId");
            String	bankAccountAccount		 = rs.getString("bankAccountAccount");
            String	bankAccountAccountName		 = rs.getString("bankAccountAccountName");
            int	bankAccountLogUseId		 = rs.getInt("bankAccountLogUseId");
            java.util.Date	bankAccountLogDate		 = rs.getTimestamp("bankAccountLogDate");
            String	bankAccountLogPs		 = rs.getString("bankAccountLogPs");
            int	bankAccountNumber		 = rs.getInt("bankAccountNumber");
            int	bankAccountActive		 = rs.getInt("bankAccountActive");
            String	bankAccount2client		 = rs.getString("bankAccount2client");
            String	bankAccountPayDate		 = rs.getString("bankAccountPayDate");
            String	bankAccountWebAddress		 = rs.getString("bankAccountWebAddress");
            String	bankAccountWeb1		 = rs.getString("bankAccountWeb1");
            String	bankAccountWeb2		 = rs.getString("bankAccountWeb2");
            String	bankAccountWeb3		 = rs.getString("bankAccountWeb3");
            int	bankAccountATMActive		 = rs.getInt("bankAccountATMActive");
            String	bankAccountRealName		 = rs.getString("bankAccountRealName");
            String	bankAccountBranchName		 = rs.getString("bankAccountBranchName");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , bankAccountName, bankAccountId, bankAccountAccount
            , bankAccountAccountName, bankAccountLogUseId, bankAccountLogDate
            , bankAccountLogPs, bankAccountNumber, bankAccountActive
            , bankAccount2client, bankAccountPayDate, bankAccountWebAddress
            , bankAccountWeb1, bankAccountWeb2, bankAccountWeb3
            , bankAccountATMActive, bankAccountRealName, bankAccountBranchName
            , bunitId);
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
        BankAccount item = (BankAccount) obj;

        String ret = "modified=NOW()"
            + ",bankAccountName='" + ServerTool.escapeString(item.getBankAccountName()) + "'"
            + ",bankAccountId='" + ServerTool.escapeString(item.getBankAccountId()) + "'"
            + ",bankAccountAccount='" + ServerTool.escapeString(item.getBankAccountAccount()) + "'"
            + ",bankAccountAccountName='" + ServerTool.escapeString(item.getBankAccountAccountName()) + "'"
            + ",bankAccountLogUseId=" + item.getBankAccountLogUseId()
            + ",bankAccountLogDate=" + (((d=item.getBankAccountLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",bankAccountLogPs='" + ServerTool.escapeString(item.getBankAccountLogPs()) + "'"
            + ",bankAccountNumber=" + item.getBankAccountNumber()
            + ",bankAccountActive=" + item.getBankAccountActive()
            + ",bankAccount2client='" + ServerTool.escapeString(item.getBankAccount2client()) + "'"
            + ",bankAccountPayDate='" + ServerTool.escapeString(item.getBankAccountPayDate()) + "'"
            + ",bankAccountWebAddress='" + ServerTool.escapeString(item.getBankAccountWebAddress()) + "'"
            + ",bankAccountWeb1='" + ServerTool.escapeString(item.getBankAccountWeb1()) + "'"
            + ",bankAccountWeb2='" + ServerTool.escapeString(item.getBankAccountWeb2()) + "'"
            + ",bankAccountWeb3='" + ServerTool.escapeString(item.getBankAccountWeb3()) + "'"
            + ",bankAccountATMActive=" + item.getBankAccountATMActive()
            + ",bankAccountRealName='" + ServerTool.escapeString(item.getBankAccountRealName()) + "'"
            + ",bankAccountBranchName='" + ServerTool.escapeString(item.getBankAccountBranchName()) + "'"
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, bankAccountName, bankAccountId, bankAccountAccount, bankAccountAccountName, bankAccountLogUseId, bankAccountLogDate, bankAccountLogPs, bankAccountNumber, bankAccountActive, bankAccount2client, bankAccountPayDate, bankAccountWebAddress, bankAccountWeb1, bankAccountWeb2, bankAccountWeb3, bankAccountATMActive, bankAccountRealName, bankAccountBranchName, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        BankAccount item = (BankAccount) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getBankAccountName()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountId()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountAccount()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountAccountName()) + "'"
            + "," + item.getBankAccountLogUseId()
            + "," + (((d=item.getBankAccountLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getBankAccountLogPs()) + "'"
            + "," + item.getBankAccountNumber()
            + "," + item.getBankAccountActive()
            + ",'" + ServerTool.escapeString(item.getBankAccount2client()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountPayDate()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountWebAddress()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountWeb1()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountWeb2()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountWeb3()) + "'"
            + "," + item.getBankAccountATMActive()
            + ",'" + ServerTool.escapeString(item.getBankAccountRealName()) + "'"
            + ",'" + ServerTool.escapeString(item.getBankAccountBranchName()) + "'"
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
