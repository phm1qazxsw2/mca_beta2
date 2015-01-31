package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Authitem
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	authId;
    private int   	number;
    private String   	pagename;


    public Authitem() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	authId,
        int	number,
        String	pagename    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.authId 	 = authId;
        this.number 	 = number;
        this.pagename 	 = pagename;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getAuthId   	() { return authId; }
    public int   	getNumber   	() { return number; }
    public String   	getPagename   	() { return pagename; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setAuthId   	(int authId) { this.authId = authId; }
    public void 	setNumber   	(int number) { this.number = number; }
    public void 	setPagename   	(String pagename) { this.pagename = pagename; }
}
