package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class ChargeItemMembr
{

    private int   	membrId;
    private int   	chargeItemId;
    private int   	billRecordId;
    private int   	billItemId;
    private int   	chargeAmount;
    private int   	amount;
    private String   	chargeName_;
    private String   	userLoginId;
    private String   	note;
    private String   	membrName;
    private int   	paidStatus;
    private long   	printDate;
    private String   	ticketId;
    private int   	smallItemId;
    private int   	tagId;
    private String   	tagName;
    private int   	billType;
    private int   	pitemNum;
    private int   	pitemId;
    private int   	aliasId;
    private int   	templateVchrId;
    private int   	userId;
    private int   	receivable;
    private int   	received;
    private int   	copyStatus;


    public ChargeItemMembr() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getChargeItemId   	() { return chargeItemId; }
    public int   	getBillRecordId   	() { return billRecordId; }
    public int   	getBillItemId   	() { return billItemId; }
    public int   	getChargeAmount   	() { return chargeAmount; }
    public int   	getAmount   	() { return amount; }
    public String   	getChargeName_   	() { return chargeName_; }
    public String   	getUserLoginId   	() { return userLoginId; }
    public String   	getNote   	() { return note; }
    public String   	getMembrName   	() { return membrName; }
    public int   	getPaidStatus   	() { return paidStatus; }
    public long   	getPrintDate   	() { return printDate; }
    public String   	getTicketId   	() { return ticketId; }
    public int   	getSmallItemId   	() { return smallItemId; }
    public int   	getTagId   	() { return tagId; }
    public String   	getTagName   	() { return tagName; }
    public int   	getBillType   	() { return billType; }
    public int   	getPitemNum   	() { return pitemNum; }
    public int   	getPitemId   	() { return pitemId; }
    public int   	getAliasId   	() { return aliasId; }
    public int   	getTemplateVchrId   	() { return templateVchrId; }
    public int   	getUserId   	() { return userId; }
    public int   	getReceivable   	() { return receivable; }
    public int   	getReceived   	() { return received; }
    public int   	getCopyStatus   	() { return copyStatus; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setChargeItemId   	(int chargeItemId) { this.chargeItemId = chargeItemId; }
    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }
    public void 	setBillItemId   	(int billItemId) { this.billItemId = billItemId; }
    public void 	setChargeAmount   	(int chargeAmount) { this.chargeAmount = chargeAmount; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setChargeName_   	(String chargeName_) { this.chargeName_ = chargeName_; }
    public void 	setUserLoginId   	(String userLoginId) { this.userLoginId = userLoginId; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }
    public void 	setPaidStatus   	(int paidStatus) { this.paidStatus = paidStatus; }
    public void 	setPrintDate   	(long printDate) { this.printDate = printDate; }
    public void 	setTicketId   	(String ticketId) { this.ticketId = ticketId; }
    public void 	setSmallItemId   	(int smallItemId) { this.smallItemId = smallItemId; }
    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setTagName   	(String tagName) { this.tagName = tagName; }
    public void 	setBillType   	(int billType) { this.billType = billType; }
    public void 	setPitemNum   	(int pitemNum) { this.pitemNum = pitemNum; }
    public void 	setPitemId   	(int pitemId) { this.pitemId = pitemId; }
    public void 	setAliasId   	(int aliasId) { this.aliasId = aliasId; }
    public void 	setTemplateVchrId   	(int templateVchrId) { this.templateVchrId = templateVchrId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setReceivable   	(int receivable) { this.receivable = receivable; }
    public void 	setReceived   	(int received) { this.received = received; }
    public void 	setCopyStatus   	(int copyStatus) { this.copyStatus = copyStatus; }

    public final static int ZERO = -99999999;
    public int getMyAmount()
    {
        if (getAmount()==ZERO)
            return 0;
	else if (getAmount()!=(int)0)
	    return getAmount();
        return getChargeAmount();
    }

    public static int getMyAmount(Charge c, ChargeItem ci)
    {
        if (c.getAmount()==ZERO)
	    return 0;
	else if (c.getAmount()!=0)
	    return c.getAmount();
	return ci.getChargeAmount();
    }

    public String getChargeKey()
    {
        return getMembrId()+"#"+getChargeItemId();
    }

    public String getMembrSmallItemIdKey()
    {
	return getMembrId()+"#"+getSmallItemId();	
    }

    public String getTagChargeKey()
    {
        return getTagId()+"#" + getChargeItemId();
    }

    public String getTagMembrKey()
    {
        return getTagId()+"#" + getMembrId();
    }

    public String getChargeName()
	throws Exception
    {
        return BillItem.getItemName(this.getAliasId(), this.getChargeName_(), this.getPitemNum());
    }

    public String getTicketIdAsString()
    {
        return "'" + getTicketId() + "'";
    }

}
