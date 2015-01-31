package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Tradeaccount
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	TradeaccountName;
    private int   	TradeaccountActive;
    private int   	TradeaccountUserId;
    private int   	TradeaccountAuth;
    private int   	tradeAccountOrder;
    private int   	bunitId;


    public Tradeaccount() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	TradeaccountName,
        int	TradeaccountActive,
        int	TradeaccountUserId,
        int	TradeaccountAuth,
        int	tradeAccountOrder,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.TradeaccountName 	 = TradeaccountName;
        this.TradeaccountActive 	 = TradeaccountActive;
        this.TradeaccountUserId 	 = TradeaccountUserId;
        this.TradeaccountAuth 	 = TradeaccountAuth;
        this.tradeAccountOrder 	 = tradeAccountOrder;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getTradeaccountName   	() { return TradeaccountName; }
    public int   	getTradeaccountActive   	() { return TradeaccountActive; }
    public int   	getTradeaccountUserId   	() { return TradeaccountUserId; }
    public int   	getTradeaccountAuth   	() { return TradeaccountAuth; }
    public int   	getTradeAccountOrder   	() { return tradeAccountOrder; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTradeaccountName   	(String TradeaccountName) { this.TradeaccountName = TradeaccountName; }
    public void 	setTradeaccountActive   	(int TradeaccountActive) { this.TradeaccountActive = TradeaccountActive; }
    public void 	setTradeaccountUserId   	(int TradeaccountUserId) { this.TradeaccountUserId = TradeaccountUserId; }
    public void 	setTradeaccountAuth   	(int TradeaccountAuth) { this.TradeaccountAuth = TradeaccountAuth; }
    public void 	setTradeAccountOrder   	(int tradeAccountOrder) { this.tradeAccountOrder = tradeAccountOrder; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
