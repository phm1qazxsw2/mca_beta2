package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class FixCost
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	fixCostCostId;
    private int   	fixCostUserid;
    private int   	fixCostActive;
    private int   	fixCostLastUserid;
    private Date   	fixCostLastDate;
    private String   	fixCostLastTitle;
    private int   	fixCostLastId;


    public FixCost() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	fixCostCostId,
        int	fixCostUserid,
        int	fixCostActive,
        int	fixCostLastUserid,
        Date	fixCostLastDate,
        String	fixCostLastTitle,
        int	fixCostLastId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.fixCostCostId 	 = fixCostCostId;
        this.fixCostUserid 	 = fixCostUserid;
        this.fixCostActive 	 = fixCostActive;
        this.fixCostLastUserid 	 = fixCostLastUserid;
        this.fixCostLastDate 	 = fixCostLastDate;
        this.fixCostLastTitle 	 = fixCostLastTitle;
        this.fixCostLastId 	 = fixCostLastId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getFixCostCostId   	() { return fixCostCostId; }
    public int   	getFixCostUserid   	() { return fixCostUserid; }
    public int   	getFixCostActive   	() { return fixCostActive; }
    public int   	getFixCostLastUserid   	() { return fixCostLastUserid; }
    public Date   	getFixCostLastDate   	() { return fixCostLastDate; }
    public String   	getFixCostLastTitle   	() { return fixCostLastTitle; }
    public int   	getFixCostLastId   	() { return fixCostLastId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setFixCostCostId   	(int fixCostCostId) { this.fixCostCostId = fixCostCostId; }
    public void 	setFixCostUserid   	(int fixCostUserid) { this.fixCostUserid = fixCostUserid; }
    public void 	setFixCostActive   	(int fixCostActive) { this.fixCostActive = fixCostActive; }
    public void 	setFixCostLastUserid   	(int fixCostLastUserid) { this.fixCostLastUserid = fixCostLastUserid; }
    public void 	setFixCostLastDate   	(Date fixCostLastDate) { this.fixCostLastDate = fixCostLastDate; }
    public void 	setFixCostLastTitle   	(String fixCostLastTitle) { this.fixCostLastTitle = fixCostLastTitle; }
    public void 	setFixCostLastId   	(int fixCostLastId) { this.fixCostLastId = fixCostLastId; }
}
