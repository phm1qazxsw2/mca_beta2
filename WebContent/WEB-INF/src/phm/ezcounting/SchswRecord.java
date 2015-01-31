package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchswRecord
{

    private int   	id;
    private int   	schswId;
    private Date   	occurDate;
    private int   	membrId;
    private int   	schdefId;
    private int   	type;


    public SchswRecord() {}


    public int   	getId   	() { return id; }
    public int   	getSchswId   	() { return schswId; }
    public Date   	getOccurDate   	() { return occurDate; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getSchdefId   	() { return schdefId; }
    public int   	getType   	() { return type; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setSchswId   	(int schswId) { this.schswId = schswId; }
    public void 	setOccurDate   	(Date occurDate) { this.occurDate = occurDate; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setSchdefId   	(int schdefId) { this.schdefId = schdefId; }
    public void 	setType   	(int type) { this.type = type; }

    public static final int TYPE_OFF = 1;
    public static final int TYPE_ON = 2;

    public static java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    public String getKey()
    {
        return sdf.format(this.getOccurDate()) + "#" + this.getSchdefId() + "#" + this.getSchswId();
    }

    public String getDateSchdefId()
    {
        return sdf.format(this.getOccurDate()) + "#" + this.getSchdefId();
    }

    public String getCounterPartKey()
    {
        return this.getSchswId() + "#" + this.getType();
    }

    public String getMyKey()
    {
        return this.getSchswId() + "#" + this.getMembrId();
    }

}
