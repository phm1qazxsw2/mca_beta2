package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchMembrInfo
{

    private int   	membrId;
    private int   	schdefId;
    private String   	note;
    private String   	name;
    private Date   	startDate;
    private Date   	endDate;
    private int   	type;
    private String   	content;
    private String   	color;
    private int   	rootId;
    private int   	newestId;


    public SchMembrInfo() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getSchdefId   	() { return schdefId; }
    public String   	getNote   	() { return note; }
    public String   	getName   	() { return name; }
    public Date   	getStartDate   	() { return startDate; }
    public Date   	getEndDate   	() { return endDate; }
    public int   	getType   	() { return type; }
    public String   	getContent   	() { return content; }
    public String   	getColor   	() { return color; }
    public int   	getRootId   	() { return rootId; }
    public int   	getNewestId   	() { return newestId; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setSchdefId   	(int schdefId) { this.schdefId = schdefId; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStartDate   	(Date startDate) { this.startDate = startDate; }
    public void 	setEndDate   	(Date endDate) { this.endDate = endDate; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setContent   	(String content) { this.content = content; }
    public void 	setColor   	(String color) { this.color = color; }
    public void 	setRootId   	(int rootId) { this.rootId = rootId; }
    public void 	setNewestId   	(int newestId) { this.newestId = newestId; }

}
