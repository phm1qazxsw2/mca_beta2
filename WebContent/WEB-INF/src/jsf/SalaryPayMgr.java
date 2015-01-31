package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryPayMgr extends Manager
{
    private static SalaryPayMgr _instance = null;

    SalaryPayMgr() {}

    public synchronized static SalaryPayMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryPayMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "salarypay";
    }

    protected Object makeBean()
    {
        return new SalaryPay();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryPay)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryPay item = (SalaryPay) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	salaryPaySanumberId		 = rs.getInt("salaryPaySanumberId");
            java.util.Date	salaryPayMonth		 = rs.getTimestamp("salaryPayMonth");
            int	salaryPayTeacherId		 = rs.getInt("salaryPayTeacherId");
            int	salaryPayDeportId		 = rs.getInt("salaryPayDeportId");
            int	salaryPayPositionId		 = rs.getInt("salaryPayPositionId");
            int	salaryPayClassesId		 = rs.getInt("salaryPayClassesId");
            int	salaryPayWay		 = rs.getInt("salaryPayWay");
            int	salaryPayBankListId		 = rs.getInt("salaryPayBankListId");
            int	salaryPayNumber		 = rs.getInt("salaryPayNumber");
            String	salaryPayPs		 = rs.getString("salaryPayPs");
            int	salaryPayLogId		 = rs.getInt("salaryPayLogId");
            java.util.Date	salaryPayLogDate		 = rs.getTimestamp("salaryPayLogDate");
            String	salaryPayLogPs		 = rs.getString("salaryPayLogPs");
            int	salaryPayStatus		 = rs.getInt("salaryPayStatus");

            item
            .init(id, created, modified
            , salaryPaySanumberId, salaryPayMonth, salaryPayTeacherId
            , salaryPayDeportId, salaryPayPositionId, salaryPayClassesId
            , salaryPayWay, salaryPayBankListId, salaryPayNumber
            , salaryPayPs, salaryPayLogId, salaryPayLogDate
            , salaryPayLogPs, salaryPayStatus);
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
        SalaryPay item = (SalaryPay) obj;

        String ret = "modified=NOW()"
            + ",salaryPaySanumberId=" + item.getSalaryPaySanumberId()
            + ",salaryPayMonth=" + (((d=item.getSalaryPayMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryPayTeacherId=" + item.getSalaryPayTeacherId()
            + ",salaryPayDeportId=" + item.getSalaryPayDeportId()
            + ",salaryPayPositionId=" + item.getSalaryPayPositionId()
            + ",salaryPayClassesId=" + item.getSalaryPayClassesId()
            + ",salaryPayWay=" + item.getSalaryPayWay()
            + ",salaryPayBankListId=" + item.getSalaryPayBankListId()
            + ",salaryPayNumber=" + item.getSalaryPayNumber()
            + ",salaryPayPs='" + ServerTool.escapeString(item.getSalaryPayPs()) + "'"
            + ",salaryPayLogId=" + item.getSalaryPayLogId()
            + ",salaryPayLogDate=" + (((d=item.getSalaryPayLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryPayLogPs='" + ServerTool.escapeString(item.getSalaryPayLogPs()) + "'"
            + ",salaryPayStatus=" + item.getSalaryPayStatus()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryPaySanumberId, salaryPayMonth, salaryPayTeacherId, salaryPayDeportId, salaryPayPositionId, salaryPayClassesId, salaryPayWay, salaryPayBankListId, salaryPayNumber, salaryPayPs, salaryPayLogId, salaryPayLogDate, salaryPayLogPs, salaryPayStatus";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryPay item = (SalaryPay) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getSalaryPaySanumberId()
            + "," + (((d=item.getSalaryPayMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryPayTeacherId()
            + "," + item.getSalaryPayDeportId()
            + "," + item.getSalaryPayPositionId()
            + "," + item.getSalaryPayClassesId()
            + "," + item.getSalaryPayWay()
            + "," + item.getSalaryPayBankListId()
            + "," + item.getSalaryPayNumber()
            + ",'" + ServerTool.escapeString(item.getSalaryPayPs()) + "'"
            + "," + item.getSalaryPayLogId()
            + "," + (((d=item.getSalaryPayLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getSalaryPayLogPs()) + "'"
            + "," + item.getSalaryPayStatus()
        ;
        return ret;
    }
}
