package jsf;


import com.axiom.beans.*;
import com.axiom.util.*;
import com.axiom.mgr.*;
import java.util.Date;
import java.text.*;
import java.sql.*;

public class MessageMgr extends Manager
{
    private static MessageMgr _instance = null;

    MessageMgr() {}

    public synchronized static MessageMgr getInstance()
    {
        if (_instance==null) {
            _instance = new MessageMgr();
        }
        return _instance;
    }

    public MessageMgr(int tran_id) throws Exception {
        super(tran_id);
    }

    protected String getTableName()
    {
        return "message";
    }

    protected Object makeBean()
    {
        return new Message();
    }

    protected int getBeanId(Object obj)
    {
        return ((Message)obj).getId();
    }

    protected void fillBean(ResultSet rs, Object obj, Connection con)
        throws Exception
    {
        Message item = (Message) obj;
        try {
            int	id		 = rs.getInt("id");
            java.util.Date	created		 = rs.getTimestamp("created");
            java.util.Date	modified		 = rs.getTimestamp("modified");
            java.util.Date	messageFromDate		 = rs.getTimestamp("messageFromDate");
            int	messageFrom		 = rs.getInt("messageFrom");
            int	messageFromStatus		 = rs.getInt("messageFromStatus");
            int	messageTo		 = rs.getInt("messageTo");
            int	messageToStatus		 = rs.getInt("messageToStatus");
            String	messageTitle		 = rs.getString("messageTitle");
            String	messageText		 = rs.getString("messageText");
            int	messageType		 = rs.getInt("messageType");
            int	messageActive		 = rs.getInt("messageActive");
            int	messagePersonType		 = rs.getInt("messagePersonType");
            int	messagePersonId		 = rs.getInt("messagePersonId");
            String	messageHandleContent		 = rs.getString("messageHandleContent");
            java.util.Date	messageHandleDate		 = rs.getTimestamp("messageHandleDate");
            int	messageEmailStatus		 = rs.getInt("messageEmailStatus");
            int	messageHandleId		 = rs.getInt("messageHandleId");
            int	bunitId		 = rs.getInt("bunitId");

            item
            .init(id, created, modified
            , messageFromDate, messageFrom, messageFromStatus
            , messageTo, messageToStatus, messageTitle
            , messageText, messageType, messageActive
            , messagePersonType, messagePersonId, messageHandleContent
            , messageHandleDate, messageEmailStatus, messageHandleId
            , bunitId);
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
        Message item = (Message) obj;

        String ret = "modified=NOW()"
            + ",messageFromDate=" + (((d=item.getMessageFromDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",messageFrom=" + item.getMessageFrom()
            + ",messageFromStatus=" + item.getMessageFromStatus()
            + ",messageTo=" + item.getMessageTo()
            + ",messageToStatus=" + item.getMessageToStatus()
            + ",messageTitle='" + ServerTool.escapeString(item.getMessageTitle()) + "'"
            + ",messageText='" + ServerTool.escapeString(item.getMessageText()) + "'"
            + ",messageType=" + item.getMessageType()
            + ",messageActive=" + item.getMessageActive()
            + ",messagePersonType=" + item.getMessagePersonType()
            + ",messagePersonId=" + item.getMessagePersonId()
            + ",messageHandleContent='" + ServerTool.escapeString(item.getMessageHandleContent()) + "'"
            + ",messageHandleDate=" + (((d=item.getMessageHandleDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + ",messageEmailStatus=" + item.getMessageEmailStatus()
            + ",messageHandleId=" + item.getMessageHandleId()
            + ",bunitId=" + item.getBunitId()
        ;
        return ret;
    }

    protected String getInsertString()
    {
         return "created, modified, messageFromDate, messageFrom, messageFromStatus, messageTo, messageToStatus, messageTitle, messageText, messageType, messageActive, messagePersonType, messagePersonId, messageHandleContent, messageHandleDate, messageEmailStatus, messageHandleId, bunitId";
    }

    protected String getCreateString(Object obj)
    {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        java.util.Date d;
        Message item = (Message) obj;

        String ret = "NOW(), NOW()"
            + "," + (((d=item.getMessageFromDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMessageFrom()
            + "," + item.getMessageFromStatus()
            + "," + item.getMessageTo()
            + "," + item.getMessageToStatus()
            + ",'" + ServerTool.escapeString(item.getMessageTitle()) + "'"
            + ",'" + ServerTool.escapeString(item.getMessageText()) + "'"
            + "," + item.getMessageType()
            + "," + item.getMessageActive()
            + "," + item.getMessagePersonType()
            + "," + item.getMessagePersonId()
            + ",'" + ServerTool.escapeString(item.getMessageHandleContent()) + "'"
            + "," + (((d=item.getMessageHandleDate())!=null)?("'"+df.format(d)+"'"):"NULL")
            + "," + item.getMessageEmailStatus()
            + "," + item.getMessageHandleId()
            + "," + item.getBunitId()
        ;
        return ret;
    }
}
