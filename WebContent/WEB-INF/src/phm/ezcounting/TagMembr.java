package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class TagMembr
{

    private int   	tagId;
    private int   	membrId;
    private Date   	bindTime;


    public TagMembr() {}


    public int   	getTagId   	() { return tagId; }
    public int   	getMembrId   	() { return membrId; }
    public Date   	getBindTime   	() { return bindTime; }


    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setBindTime   	(Date bindTime) { this.bindTime = bindTime; }

}
