package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Tag
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	typeId;
    private String   	name;
    private int   	status;
    private int   	branchTag;
    private Date   	branchTime;
    private int   	rootTag;
    private int   	branchVer;
    private int   	bunitId;
    private int   	progId;


    public Tag() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTypeId   	() { return typeId; }
    public String   	getName   	() { return name; }
    public int   	getStatus   	() { return status; }
    public int   	getBranchTag   	() { return branchTag; }
    public Date   	getBranchTime   	() { return branchTime; }
    public int   	getRootTag   	() { return rootTag; }
    public int   	getBranchVer   	() { return branchVer; }
    public int   	getBunitId   	() { return bunitId; }
    public int   	getProgId   	() { return progId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTypeId   	(int typeId) { this.typeId = typeId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setBranchTag   	(int branchTag) { this.branchTag = branchTag; }
    public void 	setBranchTime   	(Date branchTime) { this.branchTime = branchTime; }
    public void 	setRootTag   	(int rootTag) { this.rootTag = rootTag; }
    public void 	setBranchVer   	(int branchVer) { this.branchVer = branchVer; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setProgId   	(int progId) { this.progId = progId; }

    public final static int STATUS_CURRENT = 0;
    public final static int STATUS_HISTORY = 1;
    public final static int STATUS_DELETED = -1;

    public Tag copy()
    {
        Tag t = new Tag();
	t.setTypeId(this.typeId);
	t.setName(this.name);
	t.setStatus(this.status);
	t.setBranchTag(this.branchTag);
	t.setBranchTime(this.branchTime);
	t.setRootTag(this.rootTag);
	t.setBunitId(this.bunitId);
	t.setProgId(this.progId);
	return t;
    }

    public String getBunitProgKey()
    {
        return getBunitId()+"#"+getProgId();
    }


}
