package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class StudentAccountMgr extends Manager
{
    private static StudentAccountMgr _instance = null;

    StudentAccountMgr() {}

    public synchronized static StudentAccountMgr getInstance()
    {
        if (_instance==null) {
            _instance = new StudentAccountMgr();
        }
        return _instance;
    }

    public StudentAccountMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "studentaccount";
    }

    protected Object makeBean()
    {
        return new StudentAccount();
    }

    protected int getBeanId(Object obj)
    {
        return ((StudentAccount)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        StudentAccount item = (StudentAccount) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	studentAccountStuId		 = rs.getInt("studentAccountStuId");
            int	studentAccountIncomeType		 = rs.getInt("studentAccountIncomeType");
            int	studentAccountMoney		 = rs.getInt("studentAccountMoney");
            int	studentAccountSourceType		 = rs.getInt("studentAccountSourceType");
            int	studentAccountSourceId		 = rs.getInt("studentAccountSourceId");
            int	studentAccountLogId		 = rs.getInt("studentAccountLogId");
            java.util.Date	studentAccountLogDate		 = rs.getTimestamp("studentAccountLogDate");
            String	studentAccountNumber		 = rs.getString("studentAccountNumber");
            int	studentAccountPayFeeId		 = rs.getInt("studentAccountPayFeeId");
            int	studentAccountRootSAId		 = rs.getInt("studentAccountRootSAId");
            int	studentAccountCostpayID		 = rs.getInt("studentAccountCostpayID");
            String	studentAccountPs		 = rs.getString("studentAccountPs");

            item
            .init(id, created, modified
            , studentAccountStuId, studentAccountIncomeType, studentAccountMoney
            , studentAccountSourceType, studentAccountSourceId, studentAccountLogId
            , studentAccountLogDate, studentAccountNumber, studentAccountPayFeeId
            , studentAccountRootSAId, studentAccountCostpayID, studentAccountPs
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
        StudentAccount item = (StudentAccount) obj;

        String ret = "modified=NOW()"
            + ",studentAccountStuId=" + item.getStudentAccountStuId()
            + ",studentAccountIncomeType=" + item.getStudentAccountIncomeType()
            + ",studentAccountMoney=" + item.getStudentAccountMoney()
            + ",studentAccountSourceType=" + item.getStudentAccountSourceType()
            + ",studentAccountSourceId=" + item.getStudentAccountSourceId()
            + ",studentAccountLogId=" + item.getStudentAccountLogId()
            + ",studentAccountLogDate=" + (((d=item.getStudentAccountLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",studentAccountNumber='" + ServerTool.escapeString(item.getStudentAccountNumber()) + "'"
            + ",studentAccountPayFeeId=" + item.getStudentAccountPayFeeId()
            + ",studentAccountRootSAId=" + item.getStudentAccountRootSAId()
            + ",studentAccountCostpayID=" + item.getStudentAccountCostpayID()
            + ",studentAccountPs='" + ServerTool.escapeString(item.getStudentAccountPs()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, studentAccountStuId, studentAccountIncomeType, studentAccountMoney, studentAccountSourceType, studentAccountSourceId, studentAccountLogId, studentAccountLogDate, studentAccountNumber, studentAccountPayFeeId, studentAccountRootSAId, studentAccountCostpayID, studentAccountPs";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        StudentAccount item = (StudentAccount) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getStudentAccountStuId()
            + "," + item.getStudentAccountIncomeType()
            + "," + item.getStudentAccountMoney()
            + "," + item.getStudentAccountSourceType()
            + "," + item.getStudentAccountSourceId()
            + "," + item.getStudentAccountLogId()
            + "," + (((d=item.getStudentAccountLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getStudentAccountNumber()) + "'"
            + "," + item.getStudentAccountPayFeeId()
            + "," + item.getStudentAccountRootSAId()
            + "," + item.getStudentAccountCostpayID()
            + ",'" + ServerTool.escapeString(item.getStudentAccountPs()) + "'"
        ;
        return ret;
    }
}
