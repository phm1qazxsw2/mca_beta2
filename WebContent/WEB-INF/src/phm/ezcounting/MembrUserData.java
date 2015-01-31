package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrUserData extends MembrUser
{

    private int   	membrId;
    private int   	userId;
    private String   	userLoginId;
    private String   	userPassword;
    private int   	userActive;
    private String   	name;


    public MembrUserData() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getUserId   	() { return userId; }
    public String   	getUserLoginId   	() { return userLoginId; }
    public String   	getUserPassword   	() { return userPassword; }
    public int   	getUserActive   	() { return userActive; }
    public String   	getName   	() { return name; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setUserLoginId   	(String userLoginId) { this.userLoginId = userLoginId; }
    public void 	setUserPassword   	(String userPassword) { this.userPassword = userPassword; }
    public void 	setUserActive   	(int userActive) { this.userActive = userActive; }
    public void 	setName   	(String name) { this.name = name; }

}
