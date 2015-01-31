package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Discount
{

    private int   	id;
    private int   	chargeItemId;
    private int   	membrId;
    private int   	userId;
    private int   	amount;
    private int   	type;
    private String   	note;
    private int   	copy;


    public Discount() {}


    public int   	getId   	() { return id; }
    public int   	getChargeItemId   	() { return chargeItemId; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getUserId   	() { return userId; }
    public int   	getAmount   	() { return amount; }
    public int   	getType   	() { return type; }
    public String   	getNote   	() { return note; }
    public int   	getCopy   	() { return copy; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setChargeItemId   	(int chargeItemId) { this.chargeItemId = chargeItemId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setCopy   	(int copy) { this.copy = copy; }

    public static final int COPY_YES = 0;
    public static final int COPY_NO = 1;

    public String getChargeKey()
    {
        return getMembrId()+"#"+getChargeItemId();
    }

}
