package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Ownertrade
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	ownertradeOwnerId;
    private int   	ownertradeInOut;
    private int   	ownertradeNumber;
    private int   	ownertradeWay;
    private Date   	ownertradeAccountDate;
    private int   	ownertradeAccountType;
    private int   	ownertradeAccountId;
    private int   	ownertradeLogId;
    private String   	ownertradeLogPs;
    private int   	ownertradeCheckLog;
    private int   	ownertradeCheckUserId;
    private Date   	ownertradeCheckDate;
    private String   	ownertradeCheckPs;
    private int   	bunitId;


    public Ownertrade() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	ownertradeOwnerId,
        int	ownertradeInOut,
        int	ownertradeNumber,
        int	ownertradeWay,
        Date	ownertradeAccountDate,
        int	ownertradeAccountType,
        int	ownertradeAccountId,
        int	ownertradeLogId,
        String	ownertradeLogPs,
        int	ownertradeCheckLog,
        int	ownertradeCheckUserId,
        Date	ownertradeCheckDate,
        String	ownertradeCheckPs,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.ownertradeOwnerId 	 = ownertradeOwnerId;
        this.ownertradeInOut 	 = ownertradeInOut;
        this.ownertradeNumber 	 = ownertradeNumber;
        this.ownertradeWay 	 = ownertradeWay;
        this.ownertradeAccountDate 	 = ownertradeAccountDate;
        this.ownertradeAccountType 	 = ownertradeAccountType;
        this.ownertradeAccountId 	 = ownertradeAccountId;
        this.ownertradeLogId 	 = ownertradeLogId;
        this.ownertradeLogPs 	 = ownertradeLogPs;
        this.ownertradeCheckLog 	 = ownertradeCheckLog;
        this.ownertradeCheckUserId 	 = ownertradeCheckUserId;
        this.ownertradeCheckDate 	 = ownertradeCheckDate;
        this.ownertradeCheckPs 	 = ownertradeCheckPs;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getOwnertradeOwnerId   	() { return ownertradeOwnerId; }
    public int   	getOwnertradeInOut   	() { return ownertradeInOut; }
    public int   	getOwnertradeNumber   	() { return ownertradeNumber; }
    public int   	getOwnertradeWay   	() { return ownertradeWay; }
    public Date   	getOwnertradeAccountDate   	() { return ownertradeAccountDate; }
    public int   	getOwnertradeAccountType   	() { return ownertradeAccountType; }
    public int   	getOwnertradeAccountId   	() { return ownertradeAccountId; }
    public int   	getOwnertradeLogId   	() { return ownertradeLogId; }
    public String   	getOwnertradeLogPs   	() { return ownertradeLogPs; }
    public int   	getOwnertradeCheckLog   	() { return ownertradeCheckLog; }
    public int   	getOwnertradeCheckUserId   	() { return ownertradeCheckUserId; }
    public Date   	getOwnertradeCheckDate   	() { return ownertradeCheckDate; }
    public String   	getOwnertradeCheckPs   	() { return ownertradeCheckPs; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setOwnertradeOwnerId   	(int ownertradeOwnerId) { this.ownertradeOwnerId = ownertradeOwnerId; }
    public void 	setOwnertradeInOut   	(int ownertradeInOut) { this.ownertradeInOut = ownertradeInOut; }
    public void 	setOwnertradeNumber   	(int ownertradeNumber) { this.ownertradeNumber = ownertradeNumber; }
    public void 	setOwnertradeWay   	(int ownertradeWay) { this.ownertradeWay = ownertradeWay; }
    public void 	setOwnertradeAccountDate   	(Date ownertradeAccountDate) { this.ownertradeAccountDate = ownertradeAccountDate; }
    public void 	setOwnertradeAccountType   	(int ownertradeAccountType) { this.ownertradeAccountType = ownertradeAccountType; }
    public void 	setOwnertradeAccountId   	(int ownertradeAccountId) { this.ownertradeAccountId = ownertradeAccountId; }
    public void 	setOwnertradeLogId   	(int ownertradeLogId) { this.ownertradeLogId = ownertradeLogId; }
    public void 	setOwnertradeLogPs   	(String ownertradeLogPs) { this.ownertradeLogPs = ownertradeLogPs; }
    public void 	setOwnertradeCheckLog   	(int ownertradeCheckLog) { this.ownertradeCheckLog = ownertradeCheckLog; }
    public void 	setOwnertradeCheckUserId   	(int ownertradeCheckUserId) { this.ownertradeCheckUserId = ownertradeCheckUserId; }
    public void 	setOwnertradeCheckDate   	(Date ownertradeCheckDate) { this.ownertradeCheckDate = ownertradeCheckDate; }
    public void 	setOwnertradeCheckPs   	(String ownertradeCheckPs) { this.ownertradeCheckPs = ownertradeCheckPs; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
