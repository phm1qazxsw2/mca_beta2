package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class PItem
{

    private int   	id;
    private String   	name;
    private int   	safetyLevel;
    private int   	status;
    private int   	salePrice;
    private int   	bunitId;


    public PItem() {}


    public int   	getId   	() { return id; }
    public String   	getName   	() { return name; }
    public int   	getSafetyLevel   	() { return safetyLevel; }
    public int   	getStatus   	() { return status; }
    public int   	getSalePrice   	() { return salePrice; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setSafetyLevel   	(int safetyLevel) { this.safetyLevel = safetyLevel; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setSalePrice   	(int salePrice) { this.salePrice = salePrice; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

    public static final int STATUS_ACTIVE = 1;
    public static final int STATUS_DISABLED = 0;


}
