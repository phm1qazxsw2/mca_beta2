package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MessageTypeMgr extends Manager
{
    private static MessageTypeMgr _instance = null;

    MessageTypeMgr() {}

    public synchronized static MessageTypeMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MessageTypeMgr();
        }
        return _instance;
    }

    public MessageTypeMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "messagetype";
    }

    protected Object makeBean()
    {
        return new MessageType();
    }

    protected int getBeanId(Object obj)
    {
        return ((MessageType)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        MessageType item = (MessageType) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            String	messageTypeName		 = rs.getString("messageTypeName");
            int	messageTypeStatus		 = rs.getInt("messageTypeStatus");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , messageTypeName, messageTypeStatus, bunitId
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
        MessageType item = (MessageType) obj;

        String ret = "modified=NOW()"
            + ",messageTypeName='" + ServerTool.escapeString(item.getMessageTypeName()) + "'"
            + ",messageTypeStatus=" + item.getMessageTypeStatus()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, messageTypeName, messageTypeStatus, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        MessageType item = (MessageType) obj;

        String ret = "NOW(), NOW()"
            + ",'" + ServerTool.escapeString(item.getMessageTypeName()) + "'"
            + "," + item.getMessageTypeStatus()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
