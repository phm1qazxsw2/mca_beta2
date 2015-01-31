package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClientAccountMgr extends Manager
{
    private static ClientAccountMgr _instance = null;

    ClientAccountMgr() {}

    public synchronized static ClientAccountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClientAccountMgr();
        }
        return _instance;
    }

    public ClientAccountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "clientaccount";
    }

    protected Object makeBean()
    {
        return new ClientAccount();
    }

    protected int getBeanId(Object obj)
    {
        return ((ClientAccount)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        ClientAccount item = (ClientAccount) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	clientAccountBankOwner		 = rs.getString("clientAccountBankOwner");
            String	clientAccountBankName		 = rs.getString("clientAccountBankName");
            String	clientAccountBankBranchName		 = rs.getString("clientAccountBankBranchName");
            String	clientAccountBankNum		 = rs.getString("clientAccountBankNum");
            String	clientAccountAccountNum		 = rs.getString("clientAccountAccountNum");
            String	clientAccountAccountName		 = rs.getString("clientAccountAccountName");
            String	clientAccountBankIdPs		 = rs.getString("clientAccountBankIdPs");
            int	clientAccountActive		 = rs.getInt("clientAccountActive");
            int	clientAccountCosttrade		 = rs.getInt("clientAccountCosttrade");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , clientAccountBankOwner, clientAccountBankName, clientAccountBankBranchName
            , clientAccountBankNum, clientAccountAccountNum, clientAccountAccountName
            , clientAccountBankIdPs, clientAccountActive, clientAccountCosttrade
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
        ClientAccount item = (ClientAccount) obj;

        String ret = "modified=NOW()"
            + ",clientAccountBankOwner='" + ServerTool.escapeString(item.getClientAccountBankOwner()) + "'"
            + ",clientAccountBankName='" + ServerTool.escapeString(item.getClientAccountBankName()) + "'"
            + ",clientAccountBankBranchName='" + ServerTool.escapeString(item.getClientAccountBankBranchName()) + "'"
            + ",clientAccountBankNum='" + ServerTool.escapeString(item.getClientAccountBankNum()) + "'"
            + ",clientAccountAccountNum='" + ServerTool.escapeString(item.getClientAccountAccountNum()) + "'"
            + ",clientAccountAccountName='" + ServerTool.escapeString(item.getClientAccountAccountName()) + "'"
            + ",clientAccountBankIdPs='" + ServerTool.escapeString(item.getClientAccountBankIdPs()) + "'"
            + ",clientAccountActive=" + item.getClientAccountActive()
            + ",clientAccountCosttrade=" + item.getClientAccountCosttrade()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, clientAccountBankOwner, clientAccountBankName, clientAccountBankBranchName, clientAccountBankNum, clientAccountAccountNum, clientAccountAccountName, clientAccountBankIdPs, clientAccountActive, clientAccountCosttrade, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        ClientAccount item = (ClientAccount) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getClientAccountBankOwner()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientAccountBankName()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientAccountBankBranchName()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientAccountBankNum()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientAccountAccountNum()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientAccountAccountName()) + "'"
            + ",'" + ServerTool.escapeString(item.getClientAccountBankIdPs()) + "'"
            + "," + item.getClientAccountActive()
            + "," + item.getClientAccountCosttrade()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
