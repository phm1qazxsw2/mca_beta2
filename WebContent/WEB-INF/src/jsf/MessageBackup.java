package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class MessageBackup
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	messageBackupFromDate;
    private int   	messageBackupFrom;
    private int   	messageBackupFromStatus;
    private int   	messageBackupTo;
    private int   	messageBackupToStatus;
    private String   	messageBackupTitle;
    private String   	messageBackupText;
    private int   	messageBackupType;


    public MessageBackup() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	messageBackupFromDate,
        int	messageBackupFrom,
        int	messageBackupFromStatus,
        int	messageBackupTo,
        int	messageBackupToStatus,
        String	messageBackupTitle,
        String	messageBackupText,
        int	messageBackupType    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.messageBackupFromDate 	 = messageBackupFromDate;
        this.messageBackupFrom 	 = messageBackupFrom;
        this.messageBackupFromStatus 	 = messageBackupFromStatus;
        this.messageBackupTo 	 = messageBackupTo;
        this.messageBackupToStatus 	 = messageBackupToStatus;
        this.messageBackupTitle 	 = messageBackupTitle;
        this.messageBackupText 	 = messageBackupText;
        this.messageBackupType 	 = messageBackupType;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getMessageBackupFromDate   	() { return messageBackupFromDate; }
    public int   	getMessageBackupFrom   	() { return messageBackupFrom; }
    public int   	getMessageBackupFromStatus   	() { return messageBackupFromStatus; }
    public int   	getMessageBackupTo   	() { return messageBackupTo; }
    public int   	getMessageBackupToStatus   	() { return messageBackupToStatus; }
    public String   	getMessageBackupTitle   	() { return messageBackupTitle; }
    public String   	getMessageBackupText   	() { return messageBackupText; }
    public int   	getMessageBackupType   	() { return messageBackupType; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setMessageBackupFromDate   	(Date messageBackupFromDate) { this.messageBackupFromDate = messageBackupFromDate; }
    public void 	setMessageBackupFrom   	(int messageBackupFrom) { this.messageBackupFrom = messageBackupFrom; }
    public void 	setMessageBackupFromStatus   	(int messageBackupFromStatus) { this.messageBackupFromStatus = messageBackupFromStatus; }
    public void 	setMessageBackupTo   	(int messageBackupTo) { this.messageBackupTo = messageBackupTo; }
    public void 	setMessageBackupToStatus   	(int messageBackupToStatus) { this.messageBackupToStatus = messageBackupToStatus; }
    public void 	setMessageBackupTitle   	(String messageBackupTitle) { this.messageBackupTitle = messageBackupTitle; }
    public void 	setMessageBackupText   	(String messageBackupText) { this.messageBackupText = messageBackupText; }
    public void 	setMessageBackupType   	(int messageBackupType) { this.messageBackupType = messageBackupType; }
}
