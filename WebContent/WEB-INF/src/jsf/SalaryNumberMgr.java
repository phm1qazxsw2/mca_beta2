package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class SalaryNumberMgr extends Manager
{
    private static SalaryNumberMgr _instance = null;

    SalaryNumberMgr() {}

    public synchronized static SalaryNumberMgr getInstance()
    {
        if (_instance==null) {
            _instance = new SalaryNumberMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "salarynumber";
    }

    protected Object makeBean()
    {
        return new SalaryNumber();
    }

    protected int getBeanId(Object obj)
    {
        return ((SalaryNumber)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        SalaryNumber item = (SalaryNumber) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	salaryNumberTypeId		 = rs.getInt("salaryNumberTypeId");
            int	salaryNumberTeacherId		 = rs.getInt("salaryNumberTeacherId");
            int	salaryNumberMoneyNumber		 = rs.getInt("salaryNumberMoneyNumber");
            int	salaryNumberLogId		 = rs.getInt("salaryNumberLogId");
            java.util.Date	salaryNumberLogDate		 = rs.getTimestamp("salaryNumberLogDate");
            String	salaryNumberPs		 = rs.getString("salaryNumberPs");

            item
            .init(id, created, modified
            , salaryNumberTypeId, salaryNumberTeacherId, salaryNumberMoneyNumber
            , salaryNumberLogId, salaryNumberLogDate, salaryNumberPs
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
        SalaryNumber item = (SalaryNumber) obj;

        String ret = "modified=NOW()"
            + ",salaryNumberTypeId=" + item.getSalaryNumberTypeId()
            + ",salaryNumberTeacherId=" + item.getSalaryNumberTeacherId()
            + ",salaryNumberMoneyNumber=" + item.getSalaryNumberMoneyNumber()
            + ",salaryNumberLogId=" + item.getSalaryNumberLogId()
            + ",salaryNumberLogDate=" + (((d=item.getSalaryNumberLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",salaryNumberPs='" + ServerTool.escapeString(item.getSalaryNumberPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, salaryNumberTypeId, salaryNumberTeacherId, salaryNumberMoneyNumber, salaryNumberLogId, salaryNumberLogDate, salaryNumberPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        SalaryNumber item = (SalaryNumber) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getSalaryNumberTypeId()
            + "," + item.getSalaryNumberTeacherId()
            + "," + item.getSalaryNumberMoneyNumber()
            + "," + item.getSalaryNumberLogId()
            + "," + (((d=item.getSalaryNumberLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getSalaryNumberPs()) + "'"
        ;
        return ret;
    }
}
