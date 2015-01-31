package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TalentSalaryMgr extends Manager
{
    private static TalentSalaryMgr _instance = null;

    TalentSalaryMgr() {}

    public synchronized static TalentSalaryMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TalentSalaryMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "talentsalary";
    }

    protected Object makeBean()
    {
        return new TalentSalary();
    }

    protected int getBeanId(Object obj)
    {
        return ((TalentSalary)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TalentSalary item = (TalentSalary) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	talentSalaryMonth		 = rs.getTimestamp("talentSalaryMonth");
            java.util.Date	talentSalaryAccountdate		 = rs.getTimestamp("talentSalaryAccountdate");
            int	talentSalaryTalentId		 = rs.getInt("talentSalaryTalentId");
            int	talentSalaryTeacherId		 = rs.getInt("talentSalaryTeacherId");
            int	talentSalaryCostbookId		 = rs.getInt("talentSalaryCostbookId");
            int	talentSalaryCostId		 = rs.getInt("talentSalaryCostId");
            int	talentSalaryMoney		 = rs.getInt("talentSalaryMoney");
            int	talentSalaryLogId		 = rs.getInt("talentSalaryLogId");

            item
            .init(id, created, modified
            , talentSalaryMonth, talentSalaryAccountdate, talentSalaryTalentId
            , talentSalaryTeacherId, talentSalaryCostbookId, talentSalaryCostId
            , talentSalaryMoney, talentSalaryLogId);
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
        TalentSalary item = (TalentSalary) obj;

        String ret = "modified=NOW()"
            + ",talentSalaryMonth=" + (((d=item.getTalentSalaryMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",talentSalaryAccountdate=" + (((d=item.getTalentSalaryAccountdate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",talentSalaryTalentId=" + item.getTalentSalaryTalentId()
            + ",talentSalaryTeacherId=" + item.getTalentSalaryTeacherId()
            + ",talentSalaryCostbookId=" + item.getTalentSalaryCostbookId()
            + ",talentSalaryCostId=" + item.getTalentSalaryCostId()
            + ",talentSalaryMoney=" + item.getTalentSalaryMoney()
            + ",talentSalaryLogId=" + item.getTalentSalaryLogId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, talentSalaryMonth, talentSalaryAccountdate, talentSalaryTalentId, talentSalaryTeacherId, talentSalaryCostbookId, talentSalaryCostId, talentSalaryMoney, talentSalaryLogId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TalentSalary item = (TalentSalary) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getTalentSalaryMonth())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getTalentSalaryAccountdate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getTalentSalaryTalentId()
            + "," + item.getTalentSalaryTeacherId()
            + "," + item.getTalentSalaryCostbookId()
            + "," + item.getTalentSalaryCostId()
            + "," + item.getTalentSalaryMoney()
            + "," + item.getTalentSalaryLogId()
        ;
        return ret;
    }
}
