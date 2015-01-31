package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Position
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	PositionName;
    private int   	PositionActive;
    private int   	PositionPriority;


    public Position() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	PositionName,
        int	PositionActive,
        int	PositionPriority    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.PositionName 	 = PositionName;
        this.PositionActive 	 = PositionActive;
        this.PositionPriority 	 = PositionPriority;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getPositionName   	() { return PositionName; }
    public int   	getPositionActive   	() { return PositionActive; }
    public int   	getPositionPriority   	() { return PositionPriority; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPositionName   	(String PositionName) { this.PositionName = PositionName; }
    public void 	setPositionActive   	(int PositionActive) { this.PositionActive = PositionActive; }
    public void 	setPositionPriority   	(int PositionPriority) { this.PositionPriority = PositionPriority; }
}
