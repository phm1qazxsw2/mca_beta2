package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Relation
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	relationName;
    private int   	relationActive;
    private int   	bunitId;


    public Relation() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	relationName,
        int	relationActive,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.relationName 	 = relationName;
        this.relationActive 	 = relationActive;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getRelationName   	() { return relationName; }
    public int   	getRelationActive   	() { return relationActive; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setRelationName   	(String relationName) { this.relationName = relationName; }
    public void 	setRelationActive   	(int relationActive) { this.relationActive = relationActive; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
