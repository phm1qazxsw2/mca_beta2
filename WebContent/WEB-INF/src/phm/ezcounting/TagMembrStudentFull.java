package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class TagMembrStudentFull extends jsf.Student
{

    private int   	id;
    private int   	membrId;


    public TagMembrStudentFull() {}


    public int   	getId   	() { return id; }
    public int   	getMembrId   	() { return membrId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }

}
