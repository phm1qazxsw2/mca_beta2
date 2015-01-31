package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Userlog
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	UserlogUserId;
    private Date   	UserlogDate;
    private String   	UserlogIP;
    private String   	UserlogHost;
    private Date   	UserlogOut;
    private String   	UserlogOutPs;
    private int   	userConfirm;
    private int   	bunitId;


    public Userlog() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	UserlogUserId,
        Date	UserlogDate,
        String	UserlogIP,
        String	UserlogHost,
        Date	UserlogOut,
        String	UserlogOutPs,
        int	userConfirm,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.UserlogUserId 	 = UserlogUserId;
        this.UserlogDate 	 = UserlogDate;
        this.UserlogIP 	 = UserlogIP;
        this.UserlogHost 	 = UserlogHost;
        this.UserlogOut 	 = UserlogOut;
        this.UserlogOutPs 	 = UserlogOutPs;
        this.userConfirm 	 = userConfirm;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getUserlogUserId   	() { return UserlogUserId; }
    public Date   	getUserlogDate   	() { return UserlogDate; }
    public String   	getUserlogIP   	() { return UserlogIP; }
    public String   	getUserlogHost   	() { return UserlogHost; }
    public Date   	getUserlogOut   	() { return UserlogOut; }
    public String   	getUserlogOutPs   	() { return UserlogOutPs; }
    public int   	getUserConfirm   	() { return userConfirm; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setUserlogUserId   	(int UserlogUserId) { this.UserlogUserId = UserlogUserId; }
    public void 	setUserlogDate   	(Date UserlogDate) { this.UserlogDate = UserlogDate; }
    public void 	setUserlogIP   	(String UserlogIP) { this.UserlogIP = UserlogIP; }
    public void 	setUserlogHost   	(String UserlogHost) { this.UserlogHost = UserlogHost; }
    public void 	setUserlogOut   	(Date UserlogOut) { this.UserlogOut = UserlogOut; }
    public void 	setUserlogOutPs   	(String UserlogOutPs) { this.UserlogOutPs = UserlogOutPs; }
    public void 	setUserConfirm   	(int userConfirm) { this.userConfirm = userConfirm; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
