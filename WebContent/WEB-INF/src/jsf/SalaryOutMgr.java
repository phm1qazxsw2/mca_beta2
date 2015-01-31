package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryOutMgr extends Manager
{
    private static SalaryOutMgr _instance = null;

    SalaryOutMgr() {}

    public synchronized static SalaryOutMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryOutMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "salaryout";
    }

    protected Object makeBean()
    {
        return new SalaryOut();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryOut)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryOut item = (SalaryOut) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	salaryOutMonth		 = rs.getTimestamp("salaryOutMonth");
            int	salaryOutBanknumber		 = rs.getInt("salaryOutBanknumber");
            int	salaryOutBankAccountId		 = rs.getInt("salaryOutBankAccountId");
            int	salaryOutStatus		 = rs.getInt("salaryOutStatus");
            String	salaryOutPs		 = rs.getString("salaryOutPs");
            java.util.Date	salaryOutPayDate		 = rs.getTimestamp("salaryOutPayDate");
            int	salaryOutPayUser		 = rs.getInt("salaryOutPayUser");
            String	salaryOutPayPs		 = rs.getString("salaryOutPayPs");

            item
            .init(id, created, modified
            , salaryOutMonth, salaryOutBanknumber, salaryOutBankAccountId
            , salaryOutStatus, salaryOutPs, salaryOutPayDate
            , salaryOutPayUser, salaryOutPayPs);
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
        SalaryOut item = (SalaryOut) obj;

        String ret = "modified=NOW()"
            + ",salaryOutMonth=" + (((d=item.getSalaryOutMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryOutBanknumber=" + item.getSalaryOutBanknumber()
            + ",salaryOutBankAccountId=" + item.getSalaryOutBankAccountId()
            + ",salaryOutStatus=" + item.getSalaryOutStatus()
            + ",salaryOutPs='" + ServerTool.escapeString(item.getSalaryOutPs()) + "'"
            + ",salaryOutPayDate=" + (((d=item.getSalaryOutPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryOutPayUser=" + item.getSalaryOutPayUser()
            + ",salaryOutPayPs='" + ServerTool.escapeString(item.getSalaryOutPayPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryOutMonth, salaryOutBanknumber, salaryOutBankAccountId, salaryOutStatus, salaryOutPs, salaryOutPayDate, salaryOutPayUser, salaryOutPayPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryOut item = (SalaryOut) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getSalaryOutMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryOutBanknumber()
            + "," + item.getSalaryOutBankAccountId()
            + "," + item.getSalaryOutStatus()
            + ",'" + ServerTool.escapeString(item.getSalaryOutPs()) + "'"
            + "," + (((d=item.getSalaryOutPayDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getSalaryOutPayUser()
            + ",'" + ServerTool.escapeString(item.getSalaryOutPayPs()) + "'"
        ;
        return ret;
    }
}
