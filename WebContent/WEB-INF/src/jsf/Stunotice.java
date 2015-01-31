package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Stunotice
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	stunoticeCategory;
    private int   	stunoticeXid;
    private Date   	stunoticeDate;
    private int   	stunoticeStatus;
    private int   	stunoticeImportant;
    private int   	stunoticeStudentId;


    public Stunotice() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	stunoticeCategory,
        int	stunoticeXid,
        Date	stunoticeDate,
        int	stunoticeStatus,
        int	stunoticeImportant,
        int	stunoticeStudentId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.stunoticeCategory 	 = stunoticeCategory;
        this.stunoticeXid 	 = stunoticeXid;
        this.stunoticeDate 	 = stunoticeDate;
        this.stunoticeStatus 	 = stunoticeStatus;
        this.stunoticeImportant 	 = stunoticeImportant;
        this.stunoticeStudentId 	 = stunoticeStudentId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getStunoticeCategory   	() { return stunoticeCategory; }
    public int   	getStunoticeXid   	() { return stunoticeXid; }
    public Date   	getStunoticeDate   	() { return stunoticeDate; }
    public int   	getStunoticeStatus   	() { return stunoticeStatus; }
    public int   	getStunoticeImportant   	() { return stunoticeImportant; }
    public int   	getStunoticeStudentId   	() { return stunoticeStudentId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setStunoticeCategory   	(int stunoticeCategory) { this.stunoticeCategory = stunoticeCategory; }
    public void 	setStunoticeXid   	(int stunoticeXid) { this.stunoticeXid = stunoticeXid; }
    public void 	setStunoticeDate   	(Date stunoticeDate) { this.stunoticeDate = stunoticeDate; }
    public void 	setStunoticeStatus   	(int stunoticeStatus) { this.stunoticeStatus = stunoticeStatus; }
    public void 	setStunoticeImportant   	(int stunoticeImportant) { this.stunoticeImportant = stunoticeImportant; }
    public void 	setStunoticeStudentId   	(int stunoticeStudentId) { this.stunoticeStudentId = stunoticeStudentId; }
}
