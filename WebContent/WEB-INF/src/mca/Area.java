package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Area
{

    private int   	level;
    private String   	code;
    private String   	cName;
    private String   	eName;
    private String   	parentCode;


    public Area() {}


    public int   	getLevel   	() { return level; }
    public String   	getCode   	() { return code; }
    public String   	getCName   	() { return cName; }
    public String   	getEName   	() { return eName; }
    public String   	getParentCode   	() { return parentCode; }


    public void 	setLevel   	(int level) { this.level = level; }
    public void 	setCode   	(String code) { this.code = code; }
    public void 	setCName   	(String cName) { this.cName = cName; }
    public void 	setEName   	(String eName) { this.eName = eName; }
    public void 	setParentCode   	(String parentCode) { this.parentCode = parentCode; }

    public String getMyKey()
    {
        return getLevel() + "#" + getCode();
    }

}
