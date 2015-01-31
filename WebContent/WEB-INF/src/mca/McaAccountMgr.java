package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaAccountMgr extends dbo.Manager<McaAccount>
{
    private static McaAccountMgr _instance = null;

    McaAccountMgr() {}

    public synchronized static McaAccountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaAccountMgr();
        }
        return _instance;
    }

    public McaAccountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "PaymentAccounts";
    }

    protected Object makeBean()
    {
        return new McaAccount();
    }

    protected String getIdentifier(Object obj)
    {
        McaAccount o = (McaAccount) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaAccount item = (McaAccount) obj;
        try {
            String	Account		 = rs.getString("Account");
            item.setAccount(Account);
            String	Location		 = rs.getString("Location");
            item.setLocation(Location);
            String	Currency		 = rs.getString("Currency");
            item.setCurrency(Currency);
            String	Payment_Type		 = rs.getString("Payment_Type");
            item.setPayment_Type(Payment_Type);
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
        McaAccount item = (McaAccount) obj;

        String ret = 
            "Account='" + ServerTool.escapeString(item.getAccount()) + "'"
            + ",Location='" + ServerTool.escapeString(item.getLocation()) + "'"
            + ",Currency='" + ServerTool.escapeString(item.getCurrency()) + "'"
            + ",Payment_Type='" + ServerTool.escapeString(item.getPayment_Type()) + "'"

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "Account,Location,Currency,Payment_Type";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaAccount item = (McaAccount) obj;

        String ret = 
            "'" + ServerTool.escapeString(item.getAccount()) + "'"
            + ",'" + ServerTool.escapeString(item.getLocation()) + "'"
            + ",'" + ServerTool.escapeString(item.getCurrency()) + "'"
            + ",'" + ServerTool.escapeString(item.getPayment_Type()) + "'"

        ;
        return ret;
    }
}
