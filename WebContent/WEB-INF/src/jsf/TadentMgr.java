package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TadentMgr extends Manager
{
    private static TadentMgr _instance = null;

    TadentMgr() {}

    public synchronized static TadentMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TadentMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "tadent";
    }

    protected Object makeBean()
    {
        return new Tadent();
    }

    protected int getBeanId(Object obj)
    {
        return ((Tadent)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Tadent item = (Tadent) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	tadentTalentId		 = rs.getInt("tadentTalentId");
            int	tadentStudentId		 = rs.getInt("tadentStudentId");
            int	tadentActive		 = rs.getInt("tadentActive");
            java.util.Date	tadentComeDate		 = rs.getTimestamp("tadentComeDate");
            String	tadentPs		 = rs.getString("tadentPs");
            int	tadentTime		 = rs.getInt("tadentTime");
            int	tadentActualTime		 = rs.getInt("tadentActualTime");
            int	talentLog		 = rs.getInt("talentLog");
            int	talentLogId		 = rs.getInt("talentLogId");
            java.util.Date	talentLogDate		 = rs.getTimestamp("talentLogDate");

            item
            .init(id, created, modified
            , tadentTalentId, tadentStudentId, tadentActive
            , tadentComeDate, tadentPs, tadentTime
            , tadentActualTime, talentLog, talentLogId
            , talentLogDate);
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
        Tadent item = (Tadent) obj;

        String ret = "modified=NOW()"
            + ",tadentTalentId=" + item.getTadentTalentId()
            + ",tadentStudentId=" + item.getTadentStudentId()
            + ",tadentActive=" + item.getTadentActive()
            + ",tadentComeDate=" + (((d=item.getTadentComeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",tadentPs='" + ServerTool.escapeString(item.getTadentPs()) + "'"
            + ",tadentTime=" + item.getTadentTime()
            + ",tadentActualTime=" + item.getTadentActualTime()
            + ",talentLog=" + item.getTalentLog()
            + ",talentLogId=" + item.getTalentLogId()
            + ",talentLogDate=" + (((d=item.getTalentLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, tadentTalentId, tadentStudentId, tadentActive, tadentComeDate, tadentPs, tadentTime, tadentActualTime, talentLog, talentLogId, talentLogDate";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Tadent item = (Tadent) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTadentTalentId()
            + "," + item.getTadentStudentId()
            + "," + item.getTadentActive()
            + "," + (((d=item.getTadentComeDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",'" + ServerTool.escapeString(item.getTadentPs()) + "'"
            + "," + item.getTadentTime()
            + "," + item.getTadentActualTime()
            + "," + item.getTalentLog()
            + "," + item.getTalentLogId()
            + "," + (((d=item.getTalentLogDate())!=null)?("'"+df.format(d)+"'"):"NULL")
        ;
        return ret;
    }
}
