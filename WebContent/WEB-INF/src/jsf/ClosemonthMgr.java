package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClosemonthMgr extends Manager
{
    private static ClosemonthMgr _instance = null;

    ClosemonthMgr() {}

    public synchronized static ClosemonthMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClosemonthMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "closemonth";
    }

    protected Object makeBean()
    {
        return new Closemonth();
    }

    protected int getBeanId(Object obj)
    {
        return ((Closemonth)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Closemonth item = (Closemonth) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	closemonthMonth		 = rs.getTimestamp("closemonthMonth");
            int	closemonthStatus		 = rs.getInt("closemonthStatus");
            int	closemonthUserId		 = rs.getInt("closemonthUserId");
            String	closemonthPs		 = rs.getString("closemonthPs");
            int	closemonthFeesNum		 = rs.getInt("closemonthFeesNum");
            int	closemonthFeesNotNum		 = rs.getInt("closemonthFeesNotNum");
            int	closemonthFeestatus		 = rs.getInt("closemonthFeestatus");
            java.util.Date	closemonthFeeDate		 = rs.getTimestamp("closemonthFeeDate");
            int	closemonthFeeUserId		 = rs.getInt("closemonthFeeUserId");
            String	closemonthFeePs		 = rs.getString("closemonthFeePs");
            int	closemonthIncomestatus		 = rs.getInt("closemonthIncomestatus");
            int	closemonthIncomeNum		 = rs.getInt("closemonthIncomeNum");
            int	closemonthIncomeNotNum		 = rs.getInt("closemonthIncomeNotNum");
            java.util.Date	closemonthIncomeDate		 = rs.getTimestamp("closemonthIncomeDate");
            int	closemonthIncomeUserId		 = rs.getInt("closemonthIncomeUserId");
            String	closemonthIncomePs		 = rs.getString("closemonthIncomePs");
            int	closemonthSalarystatus		 = rs.getInt("closemonthSalarystatus");
            int	closemonthSalaryNum		 = rs.getInt("closemonthSalaryNum");
            int	closemonthSalaryNotNum		 = rs.getInt("closemonthSalaryNotNum");
            java.util.Date	closemonthSalaryDate		 = rs.getTimestamp("closemonthSalaryDate");
            int	closemonthSalaryUserId		 = rs.getInt("closemonthSalaryUserId");
            String	closemonthSalaryPs		 = rs.getString("closemonthSalaryPs");
            int	closemonthCoststatus		 = rs.getInt("closemonthCoststatus");
            int	closemonthCostNum		 = rs.getInt("closemonthCostNum");
            int	closemonthCostNotNum		 = rs.getInt("closemonthCostNotNum");
            java.util.Date	closemonthCostDate		 = rs.getTimestamp("closemonthCostDate");
            int	closemonthCostUserId		 = rs.getInt("closemonthCostUserId");
            String	closemonthCostPs		 = rs.getString("closemonthCostPs");
            int	closemonthFeePrepay		 = rs.getInt("closemonthFeePrepay");

            item
            .init(id, created, modified
            , closemonthMonth, closemonthStatus, closemonthUserId
            , closemonthPs, closemonthFeesNum, closemonthFeesNotNum
            , closemonthFeestatus, closemonthFeeDate, closemonthFeeUserId
            , closemonthFeePs, closemonthIncomestatus, closemonthIncomeNum
            , closemonthIncomeNotNum, closemonthIncomeDate, closemonthIncomeUserId
            , closemonthIncomePs, closemonthSalarystatus, closemonthSalaryNum
            , closemonthSalaryNotNum, closemonthSalaryDate, closemonthSalaryUserId
            , closemonthSalaryPs, closemonthCoststatus, closemonthCostNum
            , closemonthCostNotNum, closemonthCostDate, closemonthCostUserId
            , closemonthCostPs, closemonthFeePrepay);
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
        Closemonth item = (Closemonth) obj;

        String ret = "modified=NOW()"
            + ",closemonthMonth=" + (((d=item.getClosemonthMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closemonthStatus=" + item.getClosemonthStatus()
            + ",closemonthUserId=" + item.getClosemonthUserId()
            + ",closemonthPs='" + ServerTool.escapeString(item.getClosemonthPs()) + "'"
            + ",closemonthFeesNum=" + item.getClosemonthFeesNum()
            + ",closemonthFeesNotNum=" + item.getClosemonthFeesNotNum()
            + ",closemonthFeestatus=" + item.getClosemonthFeestatus()
            + ",closemonthFeeDate=" + (((d=item.getClosemonthFeeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closemonthFeeUserId=" + item.getClosemonthFeeUserId()
            + ",closemonthFeePs='" + ServerTool.escapeString(item.getClosemonthFeePs()) + "'"
            + ",closemonthIncomestatus=" + item.getClosemonthIncomestatus()
            + ",closemonthIncomeNum=" + item.getClosemonthIncomeNum()
            + ",closemonthIncomeNotNum=" + item.getClosemonthIncomeNotNum()
            + ",closemonthIncomeDate=" + (((d=item.getClosemonthIncomeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closemonthIncomeUserId=" + item.getClosemonthIncomeUserId()
            + ",closemonthIncomePs='" + ServerTool.escapeString(item.getClosemonthIncomePs()) + "'"
            + ",closemonthSalarystatus=" + item.getClosemonthSalarystatus()
            + ",closemonthSalaryNum=" + item.getClosemonthSalaryNum()
            + ",closemonthSalaryNotNum=" + item.getClosemonthSalaryNotNum()
            + ",closemonthSalaryDate=" + (((d=item.getClosemonthSalaryDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closemonthSalaryUserId=" + item.getClosemonthSalaryUserId()
            + ",closemonthSalaryPs='" + ServerTool.escapeString(item.getClosemonthSalaryPs()) + "'"
            + ",closemonthCoststatus=" + item.getClosemonthCoststatus()
            + ",closemonthCostNum=" + item.getClosemonthCostNum()
            + ",closemonthCostNotNum=" + item.getClosemonthCostNotNum()
            + ",closemonthCostDate=" + (((d=item.getClosemonthCostDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closemonthCostUserId=" + item.getClosemonthCostUserId()
            + ",closemonthCostPs='" + ServerTool.escapeString(item.getClosemonthCostPs()) + "'"
            + ",closemonthFeePrepay=" + item.getClosemonthFeePrepay()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, closemonthMonth, closemonthStatus, closemonthUserId, closemonthPs, closemonthFeesNum, closemonthFeesNotNum, closemonthFeestatus, closemonthFeeDate, closemonthFeeUserId, closemonthFeePs, closemonthIncomestatus, closemonthIncomeNum, closemonthIncomeNotNum, closemonthIncomeDate, closemonthIncomeUserId, closemonthIncomePs, closemonthSalarystatus, closemonthSalaryNum, closemonthSalaryNotNum, closemonthSalaryDate, closemonthSalaryUserId, closemonthSalaryPs, closemonthCoststatus, closemonthCostNum, closemonthCostNotNum, closemonthCostDate, closemonthCostUserId, closemonthCostPs, closemonthFeePrepay";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Closemonth item = (Closemonth) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getClosemonthMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosemonthStatus()
            + "," + item.getClosemonthUserId()
            + ",'" + ServerTool.escapeString(item.getClosemonthPs()) + "'"
            + "," + item.getClosemonthFeesNum()
            + "," + item.getClosemonthFeesNotNum()
            + "," + item.getClosemonthFeestatus()
            + "," + (((d=item.getClosemonthFeeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosemonthFeeUserId()
            + ",'" + ServerTool.escapeString(item.getClosemonthFeePs()) + "'"
            + "," + item.getClosemonthIncomestatus()
            + "," + item.getClosemonthIncomeNum()
            + "," + item.getClosemonthIncomeNotNum()
            + "," + (((d=item.getClosemonthIncomeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosemonthIncomeUserId()
            + ",'" + ServerTool.escapeString(item.getClosemonthIncomePs()) + "'"
            + "," + item.getClosemonthSalarystatus()
            + "," + item.getClosemonthSalaryNum()
            + "," + item.getClosemonthSalaryNotNum()
            + "," + (((d=item.getClosemonthSalaryDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosemonthSalaryUserId()
            + ",'" + ServerTool.escapeString(item.getClosemonthSalaryPs()) + "'"
            + "," + item.getClosemonthCoststatus()
            + "," + item.getClosemonthCostNum()
            + "," + item.getClosemonthCostNotNum()
            + "," + (((d=item.getClosemonthCostDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosemonthCostUserId()
            + ",'" + ServerTool.escapeString(item.getClosemonthCostPs()) + "'"
            + "," + item.getClosemonthFeePrepay()
        ;
        return ret;
    }
}
