package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class tag_teacher
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	tagId;
    private int   	teacherId;


    public tag_teacher() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	tagId,
        int	teacherId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.tagId 	 = tagId;
        this.teacherId 	 = teacherId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTagId   	() { return tagId; }
    public int   	getTeacherId   	() { return teacherId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setTeacherId   	(int teacherId) { this.teacherId = teacherId; }
}
