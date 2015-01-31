package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MainTagStudent
{

    private int   	membrId;
    private int   	tagId;
    private String   	tagName;
    private String   	membrName;
    private int   	studentId;
    private int   	studentStatus;


    public MainTagStudent() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getTagId   	() { return tagId; }
    public String   	getTagName   	() { return tagName; }
    public String   	getMembrName   	() { return membrName; }
    public int   	getStudentId   	() { return studentId; }
    public int   	getStudentStatus   	() { return studentStatus; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setTagId   	(int tagId) { this.tagId = tagId; }
    public void 	setTagName   	(String tagName) { this.tagName = tagName; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }
    public void 	setStudentId   	(int studentId) { this.studentId = studentId; }
    public void 	setStudentStatus   	(int studentStatus) { this.studentStatus = studentStatus; }

}
