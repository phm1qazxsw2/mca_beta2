package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Message
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	messageFromDate;
    private int   	messageFrom;
    private int   	messageFromStatus;
    private int   	messageTo;
    private int   	messageToStatus;
    private String   	messageTitle;
    private String   	messageText;
    private int   	messageType;
    private int   	messageActive;
    private int   	messagePersonType;
    private int   	messagePersonId;
    private String   	messageHandleContent;
    private Date   	messageHandleDate;
    private int   	messageEmailStatus;
    private int   	messageHandleId;
    private int   	bunitId;


    public Message() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	messageFromDate,
        int	messageFrom,
        int	messageFromStatus,
        int	messageTo,
        int	messageToStatus,
        String	messageTitle,
        String	messageText,
        int	messageType,
        int	messageActive,
        int	messagePersonType,
        int	messagePersonId,
        String	messageHandleContent,
        Date	messageHandleDate,
        int	messageEmailStatus,
        int	messageHandleId,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.messageFromDate 	 = messageFromDate;
        this.messageFrom 	 = messageFrom;
        this.messageFromStatus 	 = messageFromStatus;
        this.messageTo 	 = messageTo;
        this.messageToStatus 	 = messageToStatus;
        this.messageTitle 	 = messageTitle;
        this.messageText 	 = messageText;
        this.messageType 	 = messageType;
        this.messageActive 	 = messageActive;
        this.messagePersonType 	 = messagePersonType;
        this.messagePersonId 	 = messagePersonId;
        this.messageHandleContent 	 = messageHandleContent;
        this.messageHandleDate 	 = messageHandleDate;
        this.messageEmailStatus 	 = messageEmailStatus;
        this.messageHandleId 	 = messageHandleId;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getMessageFromDate   	() { return messageFromDate; }
    public int   	getMessageFrom   	() { return messageFrom; }
    public int   	getMessageFromStatus   	() { return messageFromStatus; }
    public int   	getMessageTo   	() { return messageTo; }
    public int   	getMessageToStatus   	() { return messageToStatus; }
    public String   	getMessageTitle   	() { return messageTitle; }
    public String   	getMessageText   	() { return messageText; }
    public int   	getMessageType   	() { return messageType; }
    public int   	getMessageActive   	() { return messageActive; }
    public int   	getMessagePersonType   	() { return messagePersonType; }
    public int   	getMessagePersonId   	() { return messagePersonId; }
    public String   	getMessageHandleContent   	() { return messageHandleContent; }
    public Date   	getMessageHandleDate   	() { return messageHandleDate; }
    public int   	getMessageEmailStatus   	() { return messageEmailStatus; }
    public int   	getMessageHandleId   	() { return messageHandleId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setMessageFromDate   	(Date messageFromDate) { this.messageFromDate = messageFromDate; }
    public void 	setMessageFrom   	(int messageFrom) { this.messageFrom = messageFrom; }
    public void 	setMessageFromStatus   	(int messageFromStatus) { this.messageFromStatus = messageFromStatus; }
    public void 	setMessageTo   	(int messageTo) { this.messageTo = messageTo; }
    public void 	setMessageToStatus   	(int messageToStatus) { this.messageToStatus = messageToStatus; }
    public void 	setMessageTitle   	(String messageTitle) { this.messageTitle = messageTitle; }
    public void 	setMessageText   	(String messageText) { this.messageText = messageText; }
    public void 	setMessageType   	(int messageType) { this.messageType = messageType; }
    public void 	setMessageActive   	(int messageActive) { this.messageActive = messageActive; }
    public void 	setMessagePersonType   	(int messagePersonType) { this.messagePersonType = messagePersonType; }
    public void 	setMessagePersonId   	(int messagePersonId) { this.messagePersonId = messagePersonId; }
    public void 	setMessageHandleContent   	(String messageHandleContent) { this.messageHandleContent = messageHandleContent; }
    public void 	setMessageHandleDate   	(Date messageHandleDate) { this.messageHandleDate = messageHandleDate; }
    public void 	setMessageEmailStatus   	(int messageEmailStatus) { this.messageEmailStatus = messageEmailStatus; }
    public void 	setMessageHandleId   	(int messageHandleId) { this.messageHandleId = messageHandleId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
