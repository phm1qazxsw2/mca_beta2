package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrTeacher
{

    private int   	membrId;
    private int   	teacherId;
    private String   	name;
    private String   	teacherIdNumber;
    private String   	teacherBank1;
    private String   	teacherAccountNumber1;
    private String   	teacherAccountName1;
    private int   	teacherAccountDefaut;
    private String   	teacherBank2;
    private String   	teacherAccountNumber2;
    private String   	teacherAccountName2;
    private int   	teacherAccountPayWay;
    private int   	status;
    private int   	teacherLevel;
    private int   	teacherBunitId;
    private String   	teacherEmail;


    public MembrTeacher() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getTeacherId   	() { return teacherId; }
    public String   	getName   	() { return name; }
    public String   	getTeacherIdNumber   	() { return teacherIdNumber; }
    public String   	getTeacherBank1   	() { return teacherBank1; }
    public String   	getTeacherAccountNumber1   	() { return teacherAccountNumber1; }
    public String   	getTeacherAccountName1   	() { return teacherAccountName1; }
    public int   	getTeacherAccountDefaut   	() { return teacherAccountDefaut; }
    public String   	getTeacherBank2   	() { return teacherBank2; }
    public String   	getTeacherAccountNumber2   	() { return teacherAccountNumber2; }
    public String   	getTeacherAccountName2   	() { return teacherAccountName2; }
    public int   	getTeacherAccountPayWay   	() { return teacherAccountPayWay; }
    public int   	getStatus   	() { return status; }
    public int   	getTeacherLevel   	() { return teacherLevel; }
    public int   	getTeacherBunitId   	() { return teacherBunitId; }
    public String   	getTeacherEmail   	() { return teacherEmail; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setTeacherId   	(int teacherId) { this.teacherId = teacherId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setTeacherIdNumber   	(String teacherIdNumber) { this.teacherIdNumber = teacherIdNumber; }
    public void 	setTeacherBank1   	(String teacherBank1) { this.teacherBank1 = teacherBank1; }
    public void 	setTeacherAccountNumber1   	(String teacherAccountNumber1) { this.teacherAccountNumber1 = teacherAccountNumber1; }
    public void 	setTeacherAccountName1   	(String teacherAccountName1) { this.teacherAccountName1 = teacherAccountName1; }
    public void 	setTeacherAccountDefaut   	(int teacherAccountDefaut) { this.teacherAccountDefaut = teacherAccountDefaut; }
    public void 	setTeacherBank2   	(String teacherBank2) { this.teacherBank2 = teacherBank2; }
    public void 	setTeacherAccountNumber2   	(String teacherAccountNumber2) { this.teacherAccountNumber2 = teacherAccountNumber2; }
    public void 	setTeacherAccountName2   	(String teacherAccountName2) { this.teacherAccountName2 = teacherAccountName2; }
    public void 	setTeacherAccountPayWay   	(int teacherAccountPayWay) { this.teacherAccountPayWay = teacherAccountPayWay; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setTeacherLevel   	(int teacherLevel) { this.teacherLevel = teacherLevel; }
    public void 	setTeacherBunitId   	(int teacherBunitId) { this.teacherBunitId = teacherBunitId; }
    public void 	setTeacherEmail   	(String teacherEmail) { this.teacherEmail = teacherEmail; }

}
