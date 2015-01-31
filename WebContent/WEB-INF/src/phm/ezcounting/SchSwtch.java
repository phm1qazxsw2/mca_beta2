package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchSwtch
{

    private int   	id;
    private int   	schMembrId1;
    private int   	schMembrId2;
    private Date   	date;
    private int   	status;
    private String   	note;


    public SchSwtch() {}


    public int   	getId   	() { return id; }
    public int   	getSchMembrId1   	() { return schMembrId1; }
    public int   	getSchMembrId2   	() { return schMembrId2; }
    public Date   	getDate   	() { return date; }
    public int   	getStatus   	() { return status; }
    public String   	getNote   	() { return note; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setSchMembrId1   	(int schMembrId1) { this.schMembrId1 = schMembrId1; }
    public void 	setSchMembrId2   	(int schMembrId2) { this.schMembrId2 = schMembrId2; }
    public void 	setDate   	(Date date) { this.date = date; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setNote   	(String note) { this.note = note; }

}
