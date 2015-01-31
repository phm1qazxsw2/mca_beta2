package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Freeze
{

    private int   	id;
    private Date   	created;
    private Date   	freezeTime;
    private int   	userId;
    private int   	bunitId;


    public Freeze() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getFreezeTime   	() { return freezeTime; }
    public int   	getUserId   	() { return userId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setFreezeTime   	(Date freezeTime) { this.freezeTime = freezeTime; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
