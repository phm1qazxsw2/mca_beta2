package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Dbbackup
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	dbbackupPs;
    private int   	dbbackupUserId;
    private String   	dbbackupFilePath;
    private String   	dbbackupFileName;


    public Dbbackup() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	dbbackupPs,
        int	dbbackupUserId,
        String	dbbackupFilePath,
        String	dbbackupFileName    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.dbbackupPs 	 = dbbackupPs;
        this.dbbackupUserId 	 = dbbackupUserId;
        this.dbbackupFilePath 	 = dbbackupFilePath;
        this.dbbackupFileName 	 = dbbackupFileName;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getDbbackupPs   	() { return dbbackupPs; }
    public int   	getDbbackupUserId   	() { return dbbackupUserId; }
    public String   	getDbbackupFilePath   	() { return dbbackupFilePath; }
    public String   	getDbbackupFileName   	() { return dbbackupFileName; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setDbbackupPs   	(String dbbackupPs) { this.dbbackupPs = dbbackupPs; }
    public void 	setDbbackupUserId   	(int dbbackupUserId) { this.dbbackupUserId = dbbackupUserId; }
    public void 	setDbbackupFilePath   	(String dbbackupFilePath) { this.dbbackupFilePath = dbbackupFilePath; }
    public void 	setDbbackupFileName   	(String dbbackupFileName) { this.dbbackupFileName = dbbackupFileName; }
}
