package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Authuser
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	authitemId;
    private int   	userId;


    public Authuser() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	authitemId,
        int	userId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.authitemId 	 = authitemId;
        this.userId 	 = userId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getAuthitemId   	() { return authitemId; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAuthitemId   	(int authitemId) { this.authitemId = authitemId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
}
