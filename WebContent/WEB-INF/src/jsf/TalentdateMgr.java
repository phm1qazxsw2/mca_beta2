package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TalentdateMgr extends Manager
{
    private static TalentdateMgr _instance = null;

    TalentdateMgr() {}

    public synchronized static TalentdateMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TalentdateMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "talentdate";
    }

    protected Object makeBean()
    {
        return new Talentdate();
    }

    protected int getBeanId(Object obj)
    {
        return ((Talentdate)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Talentdate item = (Talentdate) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	talentdateTalentId		 = rs.getInt("talentdateTalentId");
            java.util.Date	talentdateStartDate		 = rs.getTimestamp("talentdateStartDate");
            java.util.Date	talentdateEndDate		 = rs.getTimestamp("talentdateEndDate");
            String	talentdatePlan		 = rs.getString("talentdatePlan");
            String	talentdatePicFile		 = rs.getString("talentdatePicFile");
            int	talentdateStatus		 = rs.getInt("talentdateStatus");
            int	talentdateNotice		 = rs.getInt("talentdateNotice");
            int	talentdatePresent		 = rs.getInt("talentdatePresent");
            int	talentdateUserId		 = rs.getInt("talentdateUserId");
            String	talentdatePrepare		 = rs.getString("talentdatePrepare");

            item
            .init(id, created, modified
            , talentdateTalentId, talentdateStartDate, talentdateEndDate
            , talentdatePlan, talentdatePicFile, talentdateStatus
            , talentdateNotice, talentdatePresent, talentdateUserId
            , talentdatePrepare);
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
        Talentdate item = (Talentdate) obj;

        String ret = "modified=NOW()"
            + ",talentdateTalentId=" + item.getTalentdateTalentId()
            + ",talentdateStartDate=" + (((d=item.getTalentdateStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",talentdateEndDate=" + (((d=item.getTalentdateEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",talentdatePlan='" + ServerTool.escapeString(item.getTalentdatePlan()) + "'"
            + ",talentdatePicFile='" + ServerTool.escapeString(item.getTalentdatePicFile()) + "'"
            + ",talentdateStatus=" + item.getTalentdateStatus()
            + ",talentdateNotice=" + item.getTalentdateNotice()
            + ",talentdatePresent=" + item.getTalentdatePresent()
            + ",talentdateUserId=" + item.getTalentdateUserId()
            + ",talentdatePrepare='" + ServerTool.escapeString(item.getTalentdatePrepare()) + "'"
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, talentdateTalentId, talentdateStartDate, talentdateEndDate, talentdatePlan, talentdatePicFile, talentdateStatus, talentdateNotice, talentdatePresent, talentdateUserId, talentdatePrepare";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Talentdate item = (Talentdate) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTalentdateTalentId()
            + "," + (((d=item.getTalentdateStartDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + (((d=item.getTalentdateEndDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getTalentdatePlan()) + "'"
            + ",'" + ServerTool.escapeString(item.getTalentdatePicFile()) + "'"
            + "," + item.getTalentdateStatus()
            + "," + item.getTalentdateNotice()
            + "," + item.getTalentdatePresent()
            + "," + item.getTalentdateUserId()
            + ",'" + ServerTool.escapeString(item.getTalentdatePrepare()) + "'"
        ;
        return ret;
    }
}
