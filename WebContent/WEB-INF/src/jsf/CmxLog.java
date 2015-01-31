package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class CmxLog
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	cmxLogCategory;
    private int   	cmxLogCMid;
    private int   	cmxLogXId;
    private int   	cmxLogYId;
    private int   	cmxLogActive;


    public CmxLog() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	cmxLogCategory,
        int	cmxLogCMid,
        int	cmxLogXId,
        int	cmxLogYId,
        int	cmxLogActive    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.cmxLogCategory 	 = cmxLogCategory;
        this.cmxLogCMid 	 = cmxLogCMid;
        this.cmxLogXId 	 = cmxLogXId;
        this.cmxLogYId 	 = cmxLogYId;
        this.cmxLogActive 	 = cmxLogActive;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getCmxLogCategory   	() { return cmxLogCategory; }
    public int   	getCmxLogCMid   	() { return cmxLogCMid; }
    public int   	getCmxLogXId   	() { return cmxLogXId; }
    public int   	getCmxLogYId   	() { return cmxLogYId; }
    public int   	getCmxLogActive   	() { return cmxLogActive; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCmxLogCategory   	(int cmxLogCategory) { this.cmxLogCategory = cmxLogCategory; }
    public void 	setCmxLogCMid   	(int cmxLogCMid) { this.cmxLogCMid = cmxLogCMid; }
    public void 	setCmxLogXId   	(int cmxLogXId) { this.cmxLogXId = cmxLogXId; }
    public void 	setCmxLogYId   	(int cmxLogYId) { this.cmxLogYId = cmxLogYId; }
    public void 	setCmxLogActive   	(int cmxLogActive) { this.cmxLogActive = cmxLogActive; }
}
