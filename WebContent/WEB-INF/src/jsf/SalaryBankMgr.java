package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryBankMgr extends Manager
{
    private static SalaryBankMgr _instance = null;

    SalaryBankMgr() {}

    public synchronized static SalaryBankMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryBankMgr();
        }
        return _instance;
    }

    public SalaryBankMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "salarybank";
    }

    protected Object makeBean()
    {
        return new SalaryBank();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryBank)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryBank item = (SalaryBank) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	salaryBankMonth		 = rs.getTimestamp("salaryBankMonth");
            int	salaryBankTeacherId		 = rs.getInt("salaryBankTeacherId");
            int	salaryBankSanumber		 = rs.getInt("salaryBankSanumber");
            int	salaryBankDeportId		 = rs.getInt("salaryBankDeportId");
            int	salaryBankPositionId		 = rs.getInt("salaryBankPositionId");
            int	salaryBankClassesId		 = rs.getInt("salaryBankClassesId");
            int	salaryBankMoney		 = rs.getInt("salaryBankMoney");
            int	salaryBankBankNumberId		 = rs.getInt("salaryBankBankNumberId");
            int	salaryBankStatus		 = rs.getInt("salaryBankStatus");
            java.util.Date	salaryBankPayDate		 = rs.getTimestamp("salaryBankPayDate");
            int	salaryBankPayWay		 = rs.getInt("salaryBankPayWay");
            int	salaryBankPayAccountType		 = rs.getInt("salaryBankPayAccountType");
            int	salaryBankPayAccountId		 = rs.getInt("salaryBankPayAccountId");
            int	salaryBankToId		 = rs.getInt("salaryBankToId");
            String	salaryBankToAccount		 = rs.getString("salaryBankToAccount");
            int	salaryBankLogId		 = rs.getInt("salaryBankLogId");
            String	salaryBankLogPs		 = rs.getString("salaryBankLogPs");
            int	salaryBankVerifyStatus		 = rs.getInt("salaryBankVerifyStatus");
            int	salaryBankVerifyId		 = rs.getInt("salaryBankVerifyId");
            java.util.Date	salaryBankVerifyDate		 = rs.getTimestamp("salaryBankVerifyDate");
            String	salaryBankVerifyPs		 = rs.getString("salaryBankVerifyPs");

            item
            .init(id, created, modified
            , salaryBankMonth, salaryBankTeacherId, salaryBankSanumber
            , salaryBankDeportId, salaryBankPositionId, salaryBankClassesId
            , salaryBankMoney, salaryBankBankNumberId, salaryBankStatus
            , salaryBankPayDate, salaryBankPayWay, salaryBankPayAccountType
            , salaryBankPayAccountId, salaryBankToId, salaryBankToAccount
            , salaryBankLogId, salaryBankLogPs, salaryBankVerifyStatus
            , salaryBankVerifyId, salaryBankVerifyDate, salaryBankVerifyPs
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
        SalaryBank item = (SalaryBank) obj;

        String ret = "modified=NOW()"
            + ",salaryBankMonth=" + (((d=item.getSalaryBankMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryBankTeacherId=" + item.getSalaryBankTeacherId()
            + ",salaryBankSanumber=" + item.getSalaryBankSanumber()
            + ",salaryBankDeportId=" + item.getSalaryBankDeportId()
            + ",salaryBankPositionId=" + item.getSalaryBankPositionId()
            + ",salaryBankClassesId=" + item.getSalaryBankClassesId()
            + ",salaryBankMoney=" + item.getSalaryBankMoney()
            + ",salaryBankBankNumberId=" + item.getSalaryBankBankNumberId()
            + ",salaryBankStatus=" + item.getSalaryBankStatus()
            + ",salaryBankPayDate=" + (((d=item.getSalaryBankPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryBankPayWay=" + item.getSalaryBankPayWay()
            + ",salaryBankPayAccountType=" + item.getSalaryBankPayAccountType()
            + ",salaryBankPayAccountId=" + item.getSalaryBankPayAccountId()
            + ",salaryBankToId=" + item.getSalaryBankToId()
            + ",salaryBankToAccount='" + ServerTool.escapeString(item.getSalaryBankToAccount()) + "'"
            + ",salaryBankLogId=" + item.getSalaryBankLogId()
            + ",salaryBankLogPs='" + ServerTool.escapeString(item.getSalaryBankLogPs()) + "'"
            + ",salaryBankVerifyStatus=" + item.getSalaryBankVerifyStatus()
            + ",salaryBankVerifyId=" + item.getSalaryBankVerifyId()
            + ",salaryBankVerifyDate=" + (((d=item.getSalaryBankVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryBankVerifyPs='" + ServerTool.escapeString(item.getSalaryBankVerifyPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryBankMonth, salaryBankTeacherId, salaryBankSanumber, salaryBankDeportId, salaryBankPositionId, salaryBankClassesId, salaryBankMoney, salaryBankBankNumberId, salaryBankStatus, salaryBankPayDate, salaryBankPayWay, salaryBankPayAccountType, salaryBankPayAccountId, salaryBankToId, salaryBankToAccount, salaryBankLogId, salaryBankLogPs, salaryBankVerifyStatus, salaryBankVerifyId, salaryBankVerifyDate, salaryBankVerifyPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryBank item = (SalaryBank) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getSalaryBankMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryBankTeacherId()
            + "," + item.getSalaryBankSanumber()
            + "," + item.getSalaryBankDeportId()
            + "," + item.getSalaryBankPositionId()
            + "," + item.getSalaryBankClassesId()
            + "," + item.getSalaryBankMoney()
            + "," + item.getSalaryBankBankNumberId()
            + "," + item.getSalaryBankStatus()
            + "," + (((d=item.getSalaryBankPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryBankPayWay()
            + "," + item.getSalaryBankPayAccountType()
            + "," + item.getSalaryBankPayAccountId()
            + "," + item.getSalaryBankToId()
            + ",'" + ServerTool.escapeString(item.getSalaryBankToAccount()) + "'"
            + "," + item.getSalaryBankLogId()
            + ",'" + ServerTool.escapeString(item.getSalaryBankLogPs()) + "'"
            + "," + item.getSalaryBankVerifyStatus()
            + "," + item.getSalaryBankVerifyId()
            + "," + (((d=item.getSalaryBankVerifyDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getSalaryBankVerifyPs()) + "'"
        ;
        return ret;
    }
}
