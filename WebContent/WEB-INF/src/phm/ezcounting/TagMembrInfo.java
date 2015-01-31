package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class TagMembrInfo
{

    private int   	tagId;
    private int   	membrId;
    private String   	tagName;
    private int   	progId;


    public TagMembrInfo() {}


    public int   	getTagId   	() { return tagId; }
    public int   	getMembrId   	() { return membrId; }
    public String   	getTagName   	() { return tagName; }
    public int   	getProgId   	() { return progId; }


    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setTagName   	(String tagName) { this.tagName = tagName; }
    public void 	setProgId   	(int progId) { this.progId = progId; }

}
