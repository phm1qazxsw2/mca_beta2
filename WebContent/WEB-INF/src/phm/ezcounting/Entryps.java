package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Entryps
{

    private int   	id;
    private Date   	created;
    private int   	membrId;
    private String   	ps;
    private int   	userId;
    private Date   	modifyDate;


    public Entryps() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public int   	getMembrId   	() { return membrId; }
    public String   	getPs   	() { return ps; }
    public int   	getUserId   	() { return userId; }
    public Date   	getModifyDate   	() { return modifyDate; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setPs   	(String ps) { this.ps = ps; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setModifyDate   	(Date modifyDate) { this.modifyDate = modifyDate; }

    java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyyMMdd");
    
    public String getCreatedString()
    {
        return sdf.format(this.created);
    }

    public String getDateMembr()
    {
        return sdf.format(this.created)+"#"+String.valueOf(membrId);
    }

}
