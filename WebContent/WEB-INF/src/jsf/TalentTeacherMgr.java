package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TalentTeacherMgr extends Manager
{
    private static TalentTeacherMgr _instance = null;

    TalentTeacherMgr() {}

    public synchronized static TalentTeacherMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TalentTeacherMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "talentteacher";
    }

    protected Object makeBean()
    {
        return new TalentTeacher();
    }

    protected int getBeanId(Object obj)
    {
        return ((TalentTeacher)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TalentTeacher item = (TalentTeacher) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	talentTeacherTalentId		 = rs.getInt("talentTeacherTalentId");
            int	talentTeacherTeacherId		 = rs.getInt("talentTeacherTeacherId");
            int	talentUnitMoney		 = rs.getInt("talentUnitMoney");
            int	talentTeacherActive		 = rs.getInt("talentTeacherActive");
            int	talentTeacherLogId		 = rs.getInt("talentTeacherLogId");

            item
            .init(id, created, modified
            , talentTeacherTalentId, talentTeacherTeacherId, talentUnitMoney
            , talentTeacherActive, talentTeacherLogId);
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
        TalentTeacher item = (TalentTeacher) obj;

        String ret = "modified=NOW()"
            + ",talentTeacherTalentId=" + item.getTalentTeacherTalentId()
            + ",talentTeacherTeacherId=" + item.getTalentTeacherTeacherId()
            + ",talentUnitMoney=" + item.getTalentUnitMoney()
            + ",talentTeacherActive=" + item.getTalentTeacherActive()
            + ",talentTeacherLogId=" + item.getTalentTeacherLogId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, talentTeacherTalentId, talentTeacherTeacherId, talentUnitMoney, talentTeacherActive, talentTeacherLogId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TalentTeacher item = (TalentTeacher) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTalentTeacherTalentId()
            + "," + item.getTalentTeacherTeacherId()
            + "," + item.getTalentUnitMoney()
            + "," + item.getTalentTeacherActive()
            + "," + item.getTalentTeacherLogId()
        ;
        return ret;
    }
}
