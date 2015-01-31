package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class TalentFileMgr extends Manager
{
    private static TalentFileMgr _instance = null;

    TalentFileMgr() {}

    public synchronized static TalentFileMgr getInstance()
    {
        if (_instance==null) {
            _instance = new TalentFileMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "talentfile";
    }

    protected Object makeBean()
    {
        return new TalentFile();
    }

    protected int getBeanId(Object obj)
    {
        return ((TalentFile)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        TalentFile item = (TalentFile) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            int	talentFileStudentId		 = rs.getInt("talentFileStudentId");
            int	talentFileTalentdateId		 = rs.getInt("talentFileTalentdateId");
            int	talentFileTalentId		 = rs.getInt("talentFileTalentId");
            int	talentFilePresent		 = rs.getInt("talentFilePresent");
            String	talentFileContent		 = rs.getString("talentFileContent");
            int	talentFileUserId		 = rs.getInt("talentFileUserId");
            int	talentFileSendStatus		 = rs.getInt("talentFileSendStatus");

            item
            .init(id, created, modified
            , talentFileStudentId, talentFileTalentdateId, talentFileTalentId
            , talentFilePresent, talentFileContent, talentFileUserId
            , talentFileSendStatus);
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
        TalentFile item = (TalentFile) obj;

        String ret = "modified=NOW()"
            + ",talentFileStudentId=" + item.getTalentFileStudentId()
            + ",talentFileTalentdateId=" + item.getTalentFileTalentdateId()
            + ",talentFileTalentId=" + item.getTalentFileTalentId()
            + ",talentFilePresent=" + item.getTalentFilePresent()
            + ",talentFileContent='" + ServerTool.escapeString(item.getTalentFileContent()) + "'"
            + ",talentFileUserId=" + item.getTalentFileUserId()
            + ",talentFileSendStatus=" + item.getTalentFileSendStatus()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, talentFileStudentId, talentFileTalentdateId, talentFileTalentId, talentFilePresent, talentFileContent, talentFileUserId, talentFileSendStatus";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        TalentFile item = (TalentFile) obj;

        String ret = "NOW(), NOW()"
            + "," + item.getTalentFileStudentId()
            + "," + item.getTalentFileTalentdateId()
            + "," + item.getTalentFileTalentId()
            + "," + item.getTalentFilePresent()
            + ",'" + ServerTool.escapeString(item.getTalentFileContent()) + "'"
            + "," + item.getTalentFileUserId()
            + "," + item.getTalentFileSendStatus()
        ;
        return ret;
    }
}
