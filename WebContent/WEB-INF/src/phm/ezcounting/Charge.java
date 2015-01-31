package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Charge
{

    private int   	chargeItemId;
    private int   	membrId;
    private int   	amount;
    private String   	note;
    private int   	userId;
    private int   	tagId;
    private int   	pitemNum;


    public Charge() {}


    public int   	getChargeItemId   	() { return chargeItemId; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getAmount   	() { return amount; }
    public String   	getNote   	() { return note; }
    public int   	getUserId   	() { return userId; }
    public int   	getTagId   	() { return tagId; }
    public int   	getPitemNum   	() { return pitemNum; }


    public void 	setChargeItemId   	(int chargeItemId) { this.chargeItemId = chargeItemId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setPitemNum   	(int pitemNum) { this.pitemNum = pitemNum; }

    public String getChargeKey()
    {
        return getMembrId()+"#"+getChargeItemId();
    }

}
