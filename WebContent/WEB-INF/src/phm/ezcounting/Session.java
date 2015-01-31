package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Session
{

    private String   	id;
    private int   	bunitId;
    private int   	userId;


    public Session() {}


    public String   	getId   	() { return id; }
    public int   	getBunitId   	() { return bunitId; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(String id) { this.id = id; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

}
