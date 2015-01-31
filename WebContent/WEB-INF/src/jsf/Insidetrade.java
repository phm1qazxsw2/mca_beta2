package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Insidetrade
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	insidetradeUserId;
    private String   	insidetradeUserPs;
    private int   	insidetradeNumber;
    private int   	insidetradeWay;
    private Date   	insidetradeDate;
    private int   	insidetradeFromType;
    private int   	insidetradeFromId;
    private int   	insidetradeToType;
    private int   	insidetradeToId;
    private int   	insidetradeCheckLog;
    private int   	insidetradeCheckUserId;
    private Date   	insidetradeCheckDate;
    private String   	insidetradeCheckPs;
    private int   	threadId;
    private int   	bunitId;


    public Insidetrade() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	insidetradeUserId,
        String	insidetradeUserPs,
        int	insidetradeNumber,
        int	insidetradeWay,
        Date	insidetradeDate,
        int	insidetradeFromType,
        int	insidetradeFromId,
        int	insidetradeToType,
        int	insidetradeToId,
        int	insidetradeCheckLog,
        int	insidetradeCheckUserId,
        Date	insidetradeCheckDate,
        String	insidetradeCheckPs,
        int	threadId,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.insidetradeUserId 	 = insidetradeUserId;
        this.insidetradeUserPs 	 = insidetradeUserPs;
        this.insidetradeNumber 	 = insidetradeNumber;
        this.insidetradeWay 	 = insidetradeWay;
        this.insidetradeDate 	 = insidetradeDate;
        this.insidetradeFromType 	 = insidetradeFromType;
        this.insidetradeFromId 	 = insidetradeFromId;
        this.insidetradeToType 	 = insidetradeToType;
        this.insidetradeToId 	 = insidetradeToId;
        this.insidetradeCheckLog 	 = insidetradeCheckLog;
        this.insidetradeCheckUserId 	 = insidetradeCheckUserId;
        this.insidetradeCheckDate 	 = insidetradeCheckDate;
        this.insidetradeCheckPs 	 = insidetradeCheckPs;
        this.threadId 	 = threadId;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getInsidetradeUserId   	() { return insidetradeUserId; }
    public String   	getInsidetradeUserPs   	() { return insidetradeUserPs; }
    public int   	getInsidetradeNumber   	() { return insidetradeNumber; }
    public int   	getInsidetradeWay   	() { return insidetradeWay; }
    public Date   	getInsidetradeDate   	() { return insidetradeDate; }
    public int   	getInsidetradeFromType   	() { return insidetradeFromType; }
    public int   	getInsidetradeFromId   	() { return insidetradeFromId; }
    public int   	getInsidetradeToType   	() { return insidetradeToType; }
    public int   	getInsidetradeToId   	() { return insidetradeToId; }
    public int   	getInsidetradeCheckLog   	() { return insidetradeCheckLog; }
    public int   	getInsidetradeCheckUserId   	() { return insidetradeCheckUserId; }
    public Date   	getInsidetradeCheckDate   	() { return insidetradeCheckDate; }
    public String   	getInsidetradeCheckPs   	() { return insidetradeCheckPs; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setInsidetradeUserId   	(int insidetradeUserId) { this.insidetradeUserId = insidetradeUserId; }
    public void 	setInsidetradeUserPs   	(String insidetradeUserPs) { this.insidetradeUserPs = insidetradeUserPs; }
    public void 	setInsidetradeNumber   	(int insidetradeNumber) { this.insidetradeNumber = insidetradeNumber; }
    public void 	setInsidetradeWay   	(int insidetradeWay) { this.insidetradeWay = insidetradeWay; }
    public void 	setInsidetradeDate   	(Date insidetradeDate) { this.insidetradeDate = insidetradeDate; }
    public void 	setInsidetradeFromType   	(int insidetradeFromType) { this.insidetradeFromType = insidetradeFromType; }
    public void 	setInsidetradeFromId   	(int insidetradeFromId) { this.insidetradeFromId = insidetradeFromId; }
    public void 	setInsidetradeToType   	(int insidetradeToType) { this.insidetradeToType = insidetradeToType; }
    public void 	setInsidetradeToId   	(int insidetradeToId) { this.insidetradeToId = insidetradeToId; }
    public void 	setInsidetradeCheckLog   	(int insidetradeCheckLog) { this.insidetradeCheckLog = insidetradeCheckLog; }
    public void 	setInsidetradeCheckUserId   	(int insidetradeCheckUserId) { this.insidetradeCheckUserId = insidetradeCheckUserId; }
    public void 	setInsidetradeCheckDate   	(Date insidetradeCheckDate) { this.insidetradeCheckDate = insidetradeCheckDate; }
    public void 	setInsidetradeCheckPs   	(String insidetradeCheckPs) { this.insidetradeCheckPs = insidetradeCheckPs; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
