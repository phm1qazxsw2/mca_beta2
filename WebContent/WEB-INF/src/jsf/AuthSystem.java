package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class AuthSystem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	authSystemCode;
    private int   	authSystemType;
    private int   	authSystemStatus;
    private String   	authSystemPs;


    public AuthSystem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	authSystemCode,
        int	authSystemType,
        int	authSystemStatus,
        String	authSystemPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.authSystemCode 	 = authSystemCode;
        this.authSystemType 	 = authSystemType;
        this.authSystemStatus 	 = authSystemStatus;
        this.authSystemPs 	 = authSystemPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getAuthSystemCode   	() { return authSystemCode; }
    public int   	getAuthSystemType   	() { return authSystemType; }
    public int   	getAuthSystemStatus   	() { return authSystemStatus; }
    public String   	getAuthSystemPs   	() { return authSystemPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAuthSystemCode   	(String authSystemCode) { this.authSystemCode = authSystemCode; }
    public void 	setAuthSystemType   	(int authSystemType) { this.authSystemType = authSystemType; }
    public void 	setAuthSystemStatus   	(int authSystemStatus) { this.authSystemStatus = authSystemStatus; }
    public void 	setAuthSystemPs   	(String authSystemPs) { this.authSystemPs = authSystemPs; }
}
