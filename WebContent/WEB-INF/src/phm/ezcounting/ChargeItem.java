package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class ChargeItem
{

    private int   	id;
    private int   	billItemId;
    private int   	billRecordId;
    private int   	smallItemId;
    private int   	chargeAmount;


    public ChargeItem() {}


    public int   	getId   	() { return id; }
    public int   	getBillItemId   	() { return billItemId; }
    public int   	getBillRecordId   	() { return billRecordId; }
    public int   	getSmallItemId   	() { return smallItemId; }
    public int   	getChargeAmount   	() { return chargeAmount; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setBillItemId   	(int billItemId) { this.billItemId = billItemId; }
    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }
    public void 	setSmallItemId   	(int smallItemId) { this.smallItemId = smallItemId; }
    public void 	setChargeAmount   	(int chargeAmount) { this.chargeAmount = chargeAmount; }

}
