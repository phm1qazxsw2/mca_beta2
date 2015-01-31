package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class AreaChange
{

    private int   	level;
    private String   	code;
    private String   	cName;
    private String   	eName;
    private String   	parentCode;
    private int   	orgLevel;
    private String   	orgCode;
    private String   	orgParent;


    public AreaChange() {}


    public int   	getLevel   	() { return level; }
    public String   	getCode   	() { return code; }
    public String   	getCName   	() { return cName; }
    public String   	getEName   	() { return eName; }
    public String   	getParentCode   	() { return parentCode; }
    public int   	getOrgLevel   	() { return orgLevel; }
    public String   	getOrgCode   	() { return orgCode; }
    public String   	getOrgParent   	() { return orgParent; }


    public void 	setLevel   	(int level) { this.level = level; }
    public void 	setCode   	(String code) { this.code = code; }
    public void 	setCName   	(String cName) { this.cName = cName; }
    public void 	setEName   	(String eName) { this.eName = eName; }
    public void 	setParentCode   	(String parentCode) { this.parentCode = parentCode; }
    public void 	setOrgLevel   	(int orgLevel) { this.orgLevel = orgLevel; }
    public void 	setOrgCode   	(String orgCode) { this.orgCode = orgCode; }
    public void 	setOrgParent   	(String orgParent) { this.orgParent = orgParent; }

    public String getMyKey()
    {
        return getLevel() + "#" + getCode();
    }

}
