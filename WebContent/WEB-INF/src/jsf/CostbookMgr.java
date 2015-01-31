package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class CostbookMgr extends Manager
{
    private static CostbookMgr _instance = null;

    CostbookMgr() {}

    public synchronized static CostbookMgr getInstance()
    {
        if (_instance==null) {
            _instance = new CostbookMgr();
        }
        return _instance;
    }

    public CostbookMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "costbook";
    }

    protected Object makeBean()
    {
        return new Costbook();
    }

    protected int getBeanId(Object obj)
    {
        return ((Costbook)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Costbook item = (Costbook) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	costbookOutIn		 = rs.getInt("costbookOutIn");
            int	costbookCostcheckId		 = rs.getInt("costbookCostcheckId");
            java.util.Date	costbookAccountDate		 = rs.getTimestamp("costbookAccountDate");
            int	costbookCosttradeId		 = rs.getInt("costbookCosttradeId");
            String	costbookName		 = rs.getString("costbookName");
            int	costbookLogId		 = rs.getInt("costbookLogId");
            String	costbookLogPs		 = rs.getString("costbookLogPs");
            int	costbookAttachStatus		 = rs.getInt("costbookAttachStatus");
            int	costbookAttachType		 = rs.getInt("costbookAttachType");
            int	costbookTotalMoney		 = rs.getInt("costbookTotalMoney");
            int	costbookTotalNum		 = rs.getInt("costbookTotalNum");
            int	costbookPaiedMoney		 = rs.getInt("costbookPaiedMoney");
            int	costbookPaiedStatus		 = rs.getInt("costbookPaiedStatus");
            int	costbookPaidNum		 = rs.getInt("costbookPaidNum");
            int	costbookVerifyStatus		 = rs.getInt("costbookVerifyStatus");
            int	costbookVerifyId		 = rs.getInt("costbookVerifyId");
            java.util.Date	costbookVerifyDate		 = rs.getTimestamp("costbookVerifyDate");
            String	costbookVerifyPs		 = rs.getString("costbookVerifyPs");
            int	costbookActive		 = rs.getInt("costbookActive");
            String	costbookActivePs		 = rs.getString("costbookActivePs");

            item
            .init(id, created, modified
            , costbookOutIn, costbookCostcheckId, costbookAccountDate
            , costbookCosttradeId, costbookName, costbookLogId
            , costbookLogPs, costbookAttachStatus, costbookAttachType
            , costbookTotalMoney, costbookTotalNum, costbookPaiedMoney
            , costbookPaiedStatus, costbookPaidNum, costbookVerifyStatus
            , costbookVerifyId, costbookVerifyDate, costbookVerifyPs
            , costbookActive, costbookActivePs);
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
        Costbook item = (Costbook) obj;

        String ret = "modified=NOW()"
            + ",costbookOutIn=" + item.getCostbookOutIn()
            + ",costbookCostcheckId=" + item.getCostbookCostcheckId()
            + ",costbookAccountDate=" + (((d=item.getCostbookAccountDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costbookCosttradeId=" + item.getCostbookCosttradeId()
            + ",costbookName='" + ServerTool.escapeString(item.getCostbookName()) + "'"
            + ",costbookLogId=" + item.getCostbookLogId()
            + ",costbookLogPs='" + ServerTool.escapeString(item.getCostbookLogPs()) + "'"
            + ",costbookAttachStatus=" + item.getCostbookAttachStatus()
            + ",costbookAttachType=" + item.getCostbookAttachType()
            + ",costbookTotalMoney=" + item.getCostbookTotalMoney()
            + ",costbookTotalNum=" + item.getCostbookTotalNum()
            + ",costbookPaiedMoney=" + item.getCostbookPaiedMoney()
            + ",costbookPaiedStatus=" + item.getCostbookPaiedStatus()
            + ",costbookPaidNum=" + item.getCostbookPaidNum()
            + ",costbookVerifyStatus=" + item.getCostbookVerifyStatus()
            + ",costbookVerifyId=" + item.getCostbookVerifyId()
            + ",costbookVerifyDate=" + (((d=item.getCostbookVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",costbookVerifyPs='" + ServerTool.escapeString(item.getCostbookVerifyPs()) + "'"
            + ",costbookActive=" + item.getCostbookActive()
            + ",costbookActivePs='" + ServerTool.escapeString(item.getCostbookActivePs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, costbookOutIn, costbookCostcheckId, costbookAccountDate, costbookCosttradeId, costbookName, costbookLogId, costbookLogPs, costbookAttachStatus, costbookAttachType, costbookTotalMoney, costbookTotalNum, costbookPaiedMoney, costbookPaiedStatus, costbookPaidNum, costbookVerifyStatus, costbookVerifyId, costbookVerifyDate, costbookVerifyPs, costbookActive, costbookActivePs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Costbook item = (Costbook) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getCostbookOutIn()
            + "," + item.getCostbookCostcheckId()
            + "," + (((d=item.getCostbookAccountDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getCostbookCosttradeId()
            + ",'" + ServerTool.escapeString(item.getCostbookName()) + "'"
            + "," + item.getCostbookLogId()
            + ",'" + ServerTool.escapeString(item.getCostbookLogPs()) + "'"
            + "," + item.getCostbookAttachStatus()
            + "," + item.getCostbookAttachType()
            + "," + item.getCostbookTotalMoney()
            + "," + item.getCostbookTotalNum()
            + "," + item.getCostbookPaiedMoney()
            + "," + item.getCostbookPaiedStatus()
            + "," + item.getCostbookPaidNum()
            + "," + item.getCostbookVerifyStatus()
            + "," + item.getCostbookVerifyId()
            + "," + (((d=item.getCostbookVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getCostbookVerifyPs()) + "'"
            + "," + item.getCostbookActive()
            + ",'" + ServerTool.escapeString(item.getCostbookActivePs()) + "'"
        ;
        return ret;
    }
}
