package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class ClsGroup
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	classId;
    private String   	name;
    private int   	active;


    public ClsGroup() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	classId,
        String	name,
        int	active    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.classId 	 = classId;
        this.name 	 = name;
        this.active 	 = active;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getClassId   	() { return classId; }
    public String   	getName   	() { return name; }
    public int   	getActive   	() { return active; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClassId   	(int classId) { this.classId = classId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setActive   	(int active) { this.active = active; }
}
