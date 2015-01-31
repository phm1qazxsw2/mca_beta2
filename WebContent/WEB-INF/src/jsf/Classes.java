package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Classes
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	classesName;
    private String   	classesEnglishName;
    private int   	classesStatus;
    private int   	classesXid;
    private int   	classesAllPeople;


    public Classes() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	classesName,
        String	classesEnglishName,
        int	classesStatus,
        int	classesXid,
        int	classesAllPeople    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.classesName 	 = classesName;
        this.classesEnglishName 	 = classesEnglishName;
        this.classesStatus 	 = classesStatus;
        this.classesXid 	 = classesXid;
        this.classesAllPeople 	 = classesAllPeople;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getClassesName   	() { return classesName; }
    public String   	getClassesEnglishName   	() { return classesEnglishName; }
    public int   	getClassesStatus   	() { return classesStatus; }
    public int   	getClassesXid   	() { return classesXid; }
    public int   	getClassesAllPeople   	() { return classesAllPeople; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClassesName   	(String classesName) { this.classesName = classesName; }
    public void 	setClassesEnglishName   	(String classesEnglishName) { this.classesEnglishName = classesEnglishName; }
    public void 	setClassesStatus   	(int classesStatus) { this.classesStatus = classesStatus; }
    public void 	setClassesXid   	(int classesXid) { this.classesXid = classesXid; }
    public void 	setClassesAllPeople   	(int classesAllPeople) { this.classesAllPeople = classesAllPeople; }
}
