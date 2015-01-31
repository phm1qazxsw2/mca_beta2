package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MessageBackupMgr extends Manager
{
    private static MessageBackupMgr _instance = null;

    MessageBackupMgr() {}

    public synchronized static MessageBackupMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MessageBackupMgr();
        }
        return _instance;
    }

    protected String getTableName()
    {
        return "messagebackup";
    }

    protected Object makeBean()
    {
        return new MessageBackup();
    }

    protected int getBeanId(Object obj)
    {
        return ((MessageBackup)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MessageBackup item = (MessageBackup) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	messageBackupFromDate		 = rs.getTimestamp("messageBackupFromDate");
            int	messageBackupFrom		 = rs.getInt("messageBackupFrom");
            int	messageBackupFromStatus		 = rs.getInt("messageBackupFromStatus");
            int	messageBackupTo		 = rs.getInt("messageBackupTo");
            int	messageBackupToStatus		 = rs.getInt("messageBackupToStatus");
            String	messageBackupTitle		 = rs.getString("messageBackupTitle");
            String	messageBackupText		 = rs.getString("messageBackupText");
            int	messageBackupType		 = rs.getInt("messageBackupType");

            item
            .init(id, created, modified
            , messageBackupFromDate, messageBackupFrom, messageBackupFromStatus
            , messageBackupTo, messageBackupToStatus, messageBackupTitle
            , messageBackupText, messageBackupType);
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
        MessageBackup item = (MessageBackup) obj;

        String ret = "modified=NOW()"
            + ",messageBackupFromDate=" + (((d=item.getMessageBackupFromDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",messageBackupFrom=" + item.getMessageBackupFrom()
            + ",messageBackupFromStatus=" + item.getMessageBackupFromStatus()
            + ",messageBackupTo=" + item.getMessageBackupTo()
            + ",messageBackupToStatus=" + item.getMessageBackupToStatus()
            + ",messageBackupTitle='" + ServerTool.escapeString(item.getMessageBackupTitle()) + "'"
            + ",messageBackupText='" + ServerTool.escapeString(item.getMessageBackupText()) + "'"
            + ",messageBackupType=" + item.getMessageBackupType()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, messageBackupFromDate, messageBackupFrom, messageBackupFromStatus, messageBackupTo, messageBackupToStatus, messageBackupTitle, messageBackupText, messageBackupType";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MessageBackup item = (MessageBackup) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getMessageBackupFromDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMessageBackupFrom()
            + "," + item.getMessageBackupFromStatus()
            + "," + item.getMessageBackupTo()
            + "," + item.getMessageBackupToStatus()
            + ",'" + ServerTool.escapeString(item.getMessageBackupTitle()) + "'"
            + ",'" + ServerTool.escapeString(item.getMessageBackupText()) + "'"
            + "," + item.getMessageBackupType()
        ;
        return ret;
    }
}
