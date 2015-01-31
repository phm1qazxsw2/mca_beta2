package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class UserBunit
{

    private int   	userId;
    private int   	bunitId;


    public UserBunit() {}


    public int   	getUserId   	() { return userId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
