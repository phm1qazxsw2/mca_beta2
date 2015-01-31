package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class DoTrade
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	doTradedDate;
    private int   	doTradeClientAccountId;
    private int   	doTradeCostpayId;
    private int   	doTradeUserId;
    private int   	doTradeStatus;
    private int   	doTradeFromAccountType;
    private int   	doTradeFromAccountId;


    public DoTrade() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	doTradedDate,
        int	doTradeClientAccountId,
        int	doTradeCostpayId,
        int	doTradeUserId,
        int	doTradeStatus,
        int	doTradeFromAccountType,
        int	doTradeFromAccountId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.doTradedDate 	 = doTradedDate;
        this.doTradeClientAccountId 	 = doTradeClientAccountId;
        this.doTradeCostpayId 	 = doTradeCostpayId;
        this.doTradeUserId 	 = doTradeUserId;
        this.doTradeStatus 	 = doTradeStatus;
        this.doTradeFromAccountType 	 = doTradeFromAccountType;
        this.doTradeFromAccountId 	 = doTradeFromAccountId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getDoTradedDate   	() { return doTradedDate; }
    public int   	getDoTradeClientAccountId   	() { return doTradeClientAccountId; }
    public int   	getDoTradeCostpayId   	() { return doTradeCostpayId; }
    public int   	getDoTradeUserId   	() { return doTradeUserId; }
    public int   	getDoTradeStatus   	() { return doTradeStatus; }
    public int   	getDoTradeFromAccountType   	() { return doTradeFromAccountType; }
    public int   	getDoTradeFromAccountId   	() { return doTradeFromAccountId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setDoTradedDate   	(Date doTradedDate) { this.doTradedDate = doTradedDate; }
    public void 	setDoTradeClientAccountId   	(int doTradeClientAccountId) { this.doTradeClientAccountId = doTradeClientAccountId; }
    public void 	setDoTradeCostpayId   	(int doTradeCostpayId) { this.doTradeCostpayId = doTradeCostpayId; }
    public void 	setDoTradeUserId   	(int doTradeUserId) { this.doTradeUserId = doTradeUserId; }
    public void 	setDoTradeStatus   	(int doTradeStatus) { this.doTradeStatus = doTradeStatus; }
    public void 	setDoTradeFromAccountType   	(int doTradeFromAccountType) { this.doTradeFromAccountType = doTradeFromAccountType; }
    public void 	setDoTradeFromAccountId   	(int doTradeFromAccountId) { this.doTradeFromAccountId = doTradeFromAccountId; }
}
