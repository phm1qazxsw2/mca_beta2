package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Bookmark
{

    private int   	id;
    private int   	userId;
    private String   	name;
    private String   	url;
    private Date   	created;


    public Bookmark() {}


    public int   	getId   	() { return id; }
    public int   	getUserId   	() { return userId; }
    public String   	getName   	() { return name; }
    public String   	getUrl   	() { return url; }
    public Date   	getCreated   	() { return created; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setUrl   	(String url) { this.url = url; }
    public void 	setCreated   	(Date created) { this.created = created; }

}
