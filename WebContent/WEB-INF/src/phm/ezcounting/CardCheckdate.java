package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class CardCheckdate
{

    private int   	id;
    private Date   	checkdate;
    private int   	checkUser;


    public CardCheckdate() {}


    public int   	getId   	() { return id; }
    public Date   	getCheckdate   	() { return checkdate; }
    public int   	getCheckUser   	() { return checkUser; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCheckdate   	(Date checkdate) { this.checkdate = checkdate; }
    public void 	setCheckUser   	(int checkUser) { this.checkUser = checkUser; }

}
