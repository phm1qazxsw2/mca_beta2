package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryFeeMgr extends Manager
{
    private static SalaryFeeMgr _instance = null;

    SalaryFeeMgr() {}

    public synchronized static SalaryFeeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryFeeMgr();
        }
        return _instance;
    }

    public SalaryFeeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "salaryfee";
    }

    protected Object makeBean()
    {
        return new SalaryFee();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryFee)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryFee item = (SalaryFee) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	salaryFeeSanumberId		 = rs.getInt("salaryFeeSanumberId");
            java.util.Date	salaryFeeMonth		 = rs.getTimestamp("salaryFeeMonth");
            int	salaryFeeTeacherId		 = rs.getInt("salaryFeeTeacherId");
            int	salaryFeeDeportId		 = rs.getInt("salaryFeeDeportId");
            int	salaryFeePositionId		 = rs.getInt("salaryFeePositionId");
            int	salaryFeeClassesId		 = rs.getInt("salaryFeeClassesId");
            int	salaryFeeType		 = rs.getInt("salaryFeeType");
            int	salaryFeeTypeId		 = rs.getInt("salaryFeeTypeId");
            int	salaryFeeNumber		 = rs.getInt("salaryFeeNumber");
            int	salaryFeePrintNeed		 = rs.getInt("salaryFeePrintNeed");
            int	salaryFeeLogId		 = rs.getInt("salaryFeeLogId");
            String	salaryFeeLogPs		 = rs.getString("salaryFeeLogPs");
            int	salaryFeeVNeed		 = rs.getInt("salaryFeeVNeed");
            int	salaryFeeVUserId		 = rs.getInt("salaryFeeVUserId");
            java.util.Date	salaryFeeVDate		 = rs.getTimestamp("salaryFeeVDate");
            String	salaryFeeVPs		 = rs.getString("salaryFeeVPs");
            int	salaryFeeStatus		 = rs.getInt("salaryFeeStatus");

            item
            .init(id, created, modified
            , salaryFeeSanumberId, salaryFeeMonth, salaryFeeTeacherId
            , salaryFeeDeportId, salaryFeePositionId, salaryFeeClassesId
            , salaryFeeType, salaryFeeTypeId, salaryFeeNumber
            , salaryFeePrintNeed, salaryFeeLogId, salaryFeeLogPs
            , salaryFeeVNeed, salaryFeeVUserId, salaryFeeVDate
            , salaryFeeVPs, salaryFeeStatus);
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
        SalaryFee item = (SalaryFee) obj;

        String ret = "modified=NOW()"
            + ",salaryFeeSanumberId=" + item.getSalaryFeeSanumberId()
            + ",salaryFeeMonth=" + (((d=item.getSalaryFeeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryFeeTeacherId=" + item.getSalaryFeeTeacherId()
            + ",salaryFeeDeportId=" + item.getSalaryFeeDeportId()
            + ",salaryFeePositionId=" + item.getSalaryFeePositionId()
            + ",salaryFeeClassesId=" + item.getSalaryFeeClassesId()
            + ",salaryFeeType=" + item.getSalaryFeeType()
            + ",salaryFeeTypeId=" + item.getSalaryFeeTypeId()
            + ",salaryFeeNumber=" + item.getSalaryFeeNumber()
            + ",salaryFeePrintNeed=" + item.getSalaryFeePrintNeed()
            + ",salaryFeeLogId=" + item.getSalaryFeeLogId()
            + ",salaryFeeLogPs='" + ServerTool.escapeString(item.getSalaryFeeLogPs()) + "'"
            + ",salaryFeeVNeed=" + item.getSalaryFeeVNeed()
            + ",salaryFeeVUserId=" + item.getSalaryFeeVUserId()
            + ",salaryFeeVDate=" + (((d=item.getSalaryFeeVDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryFeeVPs='" + ServerTool.escapeString(item.getSalaryFeeVPs()) + "'"
            + ",salaryFeeStatus=" + item.getSalaryFeeStatus()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryFeeSanumberId, salaryFeeMonth, salaryFeeTeacherId, salaryFeeDeportId, salaryFeePositionId, salaryFeeClassesId, salaryFeeType, salaryFeeTypeId, salaryFeeNumber, salaryFeePrintNeed, salaryFeeLogId, salaryFeeLogPs, salaryFeeVNeed, salaryFeeVUserId, salaryFeeVDate, salaryFeeVPs, salaryFeeStatus";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryFee item = (SalaryFee) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getSalaryFeeSanumberId()
            + "," + (((d=item.getSalaryFeeMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryFeeTeacherId()
            + "," + item.getSalaryFeeDeportId()
            + "," + item.getSalaryFeePositionId()
            + "," + item.getSalaryFeeClassesId()
            + "," + item.getSalaryFeeType()
            + "," + item.getSalaryFeeTypeId()
            + "," + item.getSalaryFeeNumber()
            + "," + item.getSalaryFeePrintNeed()
            + "," + item.getSalaryFeeLogId()
            + ",'" + ServerTool.escapeString(item.getSalaryFeeLogPs()) + "'"
            + "," + item.getSalaryFeeVNeed()
            + "," + item.getSalaryFeeVUserId()
            + "," + (((d=item.getSalaryFeeVDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getSalaryFeeVPs()) + "'"
            + "," + item.getSalaryFeeStatus()
        ;
        return ret;
    }
}
