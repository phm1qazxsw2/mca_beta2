package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalarybankAuth
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	salarybankAuthId;
    private int   	salarybankAuthUserID;
    private int   	salarybankAuthActive;
    private int   	salarybankLoginId;


    public SalarybankAuth() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	salarybankAuthId,
        int	salarybankAuthUserID,
        int	salarybankAuthActive,
        int	salarybankLoginId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salarybankAuthId 	 = salarybankAuthId;
        this.salarybankAuthUserID 	 = salarybankAuthUserID;
        this.salarybankAuthActive 	 = salarybankAuthActive;
        this.salarybankLoginId 	 = salarybankLoginId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getSalarybankAuthId   	() { return salarybankAuthId; }
    public int   	getSalarybankAuthUserID   	() { return salarybankAuthUserID; }
    public int   	getSalarybankAuthActive   	() { return salarybankAuthActive; }
    public int   	getSalarybankLoginId   	() { return salarybankLoginId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalarybankAuthId   	(int salarybankAuthId) { this.salarybankAuthId = salarybankAuthId; }
    public void 	setSalarybankAuthUserID   	(int salarybankAuthUserID) { this.salarybankAuthUserID = salarybankAuthUserID; }
    public void 	setSalarybankAuthActive   	(int salarybankAuthActive) { this.salarybankAuthActive = salarybankAuthActive; }
    public void 	setSalarybankLoginId   	(int salarybankLoginId) { this.salarybankLoginId = salarybankLoginId; }
}
