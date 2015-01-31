package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Membr
{

    private int   	id;
    private String   	name;
    private int   	active;
    private int   	type;
    private int   	surrogateId;
    private Date   	birth;
    private int   	bunitId;


    public Membr() {}


    public int   	getId   	() { return id; }
    public String   	getName   	() { return name; }
    public int   	getActive   	() { return active; }
    public int   	getType   	() { return type; }
    public int   	getSurrogateId   	() { return surrogateId; }
    public Date   	getBirth   	() { return birth; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setActive   	(int active) { this.active = active; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setSurrogateId   	(int surrogateId) { this.surrogateId = surrogateId; }
    public void 	setBirth   	(Date birth) { this.birth = birth; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

     public final static int TYPE_STUDENT = 1;
     public final static int TYPE_TEACHER = 2;

}
