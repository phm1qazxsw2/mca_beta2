package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrStudent
{

    private int   	membrId;
    private int   	studentId;
    private String   	name;
    private int   	status;
    private String   	studentNumber;


    public MembrStudent() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getStudentId   	() { return studentId; }
    public String   	getName   	() { return name; }
    public int   	getStatus   	() { return status; }
    public String   	getStudentNumber   	() { return studentNumber; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setStudentId   	(int studentId) { this.studentId = studentId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setStudentNumber   	(String studentNumber) { this.studentNumber = studentNumber; }

}
