package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VchrItemInfo extends VchrItem
{

    private Date   	registerDate;
    private Date   	created;
    private String   	main;
    private String   	sub;
    private int   	name1;
    private int   	name2;
    private int   	vnote;
    private String   	serial;
    private int   	userId;


    public VchrItemInfo() {}


    public Date   	getRegisterDate   	() { return registerDate; }
    public Date   	getCreated   	() { return created; }
    public String   	getMain   	() { return main; }
    public String   	getSub   	() { return sub; }
    public int   	getName1   	() { return name1; }
    public int   	getName2   	() { return name2; }
    public int   	getVnote   	() { return vnote; }
    public String   	getSerial   	() { return serial; }
    public int   	getUserId   	() { return userId; }


    public void 	setRegisterDate   	(Date registerDate) { this.registerDate = registerDate; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setMain   	(String main) { this.main = main; }
    public void 	setSub   	(String sub) { this.sub = sub; }
    public void 	setName1   	(int name1) { this.name1 = name1; }
    public void 	setName2   	(int name2) { this.name2 = name2; }
    public void 	setVnote   	(int vnote) { this.vnote = vnote; }
    public void 	setSerial   	(String serial) { this.serial = serial; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

}
