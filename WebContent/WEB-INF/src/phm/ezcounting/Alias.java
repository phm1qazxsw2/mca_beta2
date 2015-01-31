package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Alias
{

    private int   	id;
    private String   	name;
    private int   	status;
    private int   	bunitId;


    public Alias() {}


    public int   	getId   	() { return id; }
    public String   	getName   	() { return name; }
    public int   	getStatus   	() { return status; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

   public final static int STATUS_NONE_ACTIVE = 0;
   public final static int STATUS_ACTIVE = 1;

}
