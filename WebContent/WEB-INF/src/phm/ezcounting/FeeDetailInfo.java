package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class FeeDetailInfo extends FeeDetail
{

    private int   	billRecordId;
    private int   	billItemId;


    public FeeDetailInfo() {}


    public int   	getBillRecordId   	() { return billRecordId; }
    public int   	getBillItemId   	() { return billItemId; }


    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }
    public void 	setBillItemId   	(int billItemId) { this.billItemId = billItemId; }

}
