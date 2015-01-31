package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class TagMembrTeacher
{

    private int   	membrId;
    private int   	tagId;
    private String   	tagName;
    private String   	membrName;


    public TagMembrTeacher() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getTagId   	() { return tagId; }
    public String   	getTagName   	() { return tagName; }
    public String   	getMembrName   	() { return membrName; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setTagName   	(String tagName) { this.tagName = tagName; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }

}
