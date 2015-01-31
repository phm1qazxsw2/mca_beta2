package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillComment
{

    private int   	membrId;
    private int   	billRecordId;
    private String   	comment;


    public BillComment() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getBillRecordId   	() { return billRecordId; }
    public String   	getComment   	() { return comment; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }
    public void 	setComment   	(String comment) { this.comment = comment; }

   public String getBillKey()
   {
        return getMembrId()+"#"+getBillRecordId();
   }

}
