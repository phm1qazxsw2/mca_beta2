package mca;


import dbo.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class McaAuthorizerMgr extends dbo.Manager<McaAuthorizer>
{
    private static McaAuthorizerMgr _instance = null;

    McaAuthorizerMgr() {}

    public synchronized static McaAuthorizerMgr getInstance()
    {
        if (_instance==null) {
            _instance = new McaAuthorizerMgr();
        }
        return _instance;
    }

    public McaAuthorizerMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "Authorizers";
    }

    protected Object makeBean()
    {
        return new McaAuthorizer();
    }

    protected String getIdentifier(Object obj)
    {
        McaAuthorizer o = (McaAuthorizer) obj;
        return null;
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        McaAuthorizer item = (McaAuthorizer) obj;
        try {
            int	Account_Number		 = rs.getInt("Account_Number");
            item.setAccount_Number(Account_Number);
            int	Sub_Account		 = rs.getInt("Sub_Account");
            item.setSub_Account(Sub_Account);
            String	Account_Name		 = rs.getString("Account_Name");
            item.setAccount_Name(Account_Name);
            String	Description1		 = rs.getString("Description1");
            item.setDescription1(Description1);
            String	Description2		 = rs.getString("Description2");
            item.setDescription2(Description2);
            int	Primary_Authorizer		 = rs.getInt("Primary_Authorizer");
            item.setPrimary_Authorizer(Primary_Authorizer);
            int	Secondary_Authorizer		 = rs.getInt("Secondary_Authorizer");
            item.setSecondary_Authorizer(Secondary_Authorizer);
            int	Budget		 = rs.getInt("Budget");
            item.setBudget(Budget);
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
        McaAuthorizer item = (McaAuthorizer) obj;

        String ret = 
            "Account_Number=" + item.getAccount_Number()
            + ",Sub_Account=" + item.getSub_Account()
            + ",Account_Name='" + ServerTool.escapeString(item.getAccount_Name()) + "'"
            + ",Description1='" + ServerTool.escapeString(item.getDescription1()) + "'"
            + ",Description2='" + ServerTool.escapeString(item.getDescription2()) + "'"
            + ",Primary_Authorizer=" + item.getPrimary_Authorizer()
            + ",Secondary_Authorizer=" + item.getSecondary_Authorizer()
            + ",Budget=" + item.getBudget()

        ;
        return ret;
    }

    protected String getInsertString()
    {
         return  "Account_Number,Sub_Account,Account_Name,Description1,Description2,Primary_Authorizer,Secondary_Authorizer,Budget";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        McaAuthorizer item = (McaAuthorizer) obj;

        String ret = 
            "" + item.getAccount_Number()
            + "," + item.getSub_Account()
            + ",'" + ServerTool.escapeString(item.getAccount_Name()) + "'"
            + ",'" + ServerTool.escapeString(item.getDescription1()) + "'"
            + ",'" + ServerTool.escapeString(item.getDescription2()) + "'"
            + "," + item.getPrimary_Authorizer()
            + "," + item.getSecondary_Authorizer()
            + "," + item.getBudget()

        ;
        return ret;
    }
}
