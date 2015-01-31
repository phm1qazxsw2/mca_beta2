package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchMembr
{

    private int   	membrId;
    private int   	schdefId;
    private String   	note;


    public SchMembr() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getSchdefId   	() { return schdefId; }
    public String   	getNote   	() { return note; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setSchdefId   	(int schdefId) { this.schdefId = schdefId; }
    public void 	setNote   	(String note) { this.note = note; }

}
