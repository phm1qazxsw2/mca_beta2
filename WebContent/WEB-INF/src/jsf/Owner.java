package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Owner
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	ownerName;
    private String   	ownerPs;
    private int   	ownerStatus;
    private int   	bunitId;


    public Owner() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	ownerName,
        String	ownerPs,
        int	ownerStatus,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.ownerName 	 = ownerName;
        this.ownerPs 	 = ownerPs;
        this.ownerStatus 	 = ownerStatus;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getOwnerName   	() { return ownerName; }
    public String   	getOwnerPs   	() { return ownerPs; }
    public int   	getOwnerStatus   	() { return ownerStatus; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setOwnerName   	(String ownerName) { this.ownerName = ownerName; }
    public void 	setOwnerPs   	(String ownerPs) { this.ownerPs = ownerPs; }
    public void 	setOwnerStatus   	(int ownerStatus) { this.ownerStatus = ownerStatus; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
