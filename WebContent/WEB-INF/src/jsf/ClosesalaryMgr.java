package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class ClosesalaryMgr extends Manager
{
    private static ClosesalaryMgr _instance = null;

    ClosesalaryMgr() {}

    public synchronized static ClosesalaryMgr getInstance()
    {
        if (_instance==null) {
            _instance = new ClosesalaryMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "closesalary";
    }

    protected Object makeBean()
    {
        return new Closesalary();
    }

    protected int getBeanId(Object obj)
    {
        return ((Closesalary)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Closesalary item = (Closesalary) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	closesalaryMonth		 = rs.getTimestamp("closesalaryMonth");
            int	closesalaryType		 = rs.getInt("closesalaryType");
            int	closesalaryStatus		 = rs.getInt("closesalaryStatus");
            int	closesalarySalaryId		 = rs.getInt("closesalarySalaryId");
            int	closesalarySalaryNum		 = rs.getInt("closesalarySalaryNum");
            int	closesalaryNum		 = rs.getInt("closesalaryNum");

            item
            .init(id, created, modified
            , closesalaryMonth, closesalaryType, closesalaryStatus
            , closesalarySalaryId, closesalarySalaryNum, closesalaryNum
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
        Closesalary item = (Closesalary) obj;

        String ret = "modified=NOW()"
            + ",closesalaryMonth=" + (((d=item.getClosesalaryMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",closesalaryType=" + item.getClosesalaryType()
            + ",closesalaryStatus=" + item.getClosesalaryStatus()
            + ",closesalarySalaryId=" + item.getClosesalarySalaryId()
            + ",closesalarySalaryNum=" + item.getClosesalarySalaryNum()
            + ",closesalaryNum=" + item.getClosesalaryNum()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, closesalaryMonth, closesalaryType, closesalaryStatus, closesalarySalaryId, closesalarySalaryNum, closesalaryNum";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Closesalary item = (Closesalary) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getClosesalaryMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getClosesalaryType()
            + "," + item.getClosesalaryStatus()
            + "," + item.getClosesalarySalaryId()
            + "," + item.getClosesalarySalaryNum()
            + "," + item.getClosesalaryNum()
        ;
        return ret;
    }
}
