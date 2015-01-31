package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrUser
{

    private int   	membrId;
    private int   	userId;


    public MembrUser() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getUserId   	() { return userId; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

}
