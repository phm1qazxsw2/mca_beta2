package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class MessageType
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	messageTypeName;
    private int   	messageTypeStatus;
    private int   	bunitId;


    public MessageType() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	messageTypeName,
        int	messageTypeStatus,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.messageTypeName 	 = messageTypeName;
        this.messageTypeStatus 	 = messageTypeStatus;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getMessageTypeName   	() { return messageTypeName; }
    public int   	getMessageTypeStatus   	() { return messageTypeStatus; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setMessageTypeName   	(String messageTypeName) { this.messageTypeName = messageTypeName; }
    public void 	setMessageTypeStatus   	(int messageTypeStatus) { this.messageTypeStatus = messageTypeStatus; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
