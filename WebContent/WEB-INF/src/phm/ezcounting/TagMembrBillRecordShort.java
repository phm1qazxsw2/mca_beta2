package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class TagMembrBillRecordShort extends MembrBillRecord
{

    private int   	tagId;
    private String   	membrName;
    private int   	billType;
    private int   	privLevel;


    public TagMembrBillRecordShort() {}


    public int   	getTagId   	() { return tagId; }
    public String   	getMembrName   	() { return membrName; }
    public int   	getBillType   	() { return billType; }
    public int   	getPrivLevel   	() { return privLevel; }


    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }
    public void 	setBillType   	(int billType) { this.billType = billType; }
    public void 	setPrivLevel   	(int privLevel) { this.privLevel = privLevel; }

}
