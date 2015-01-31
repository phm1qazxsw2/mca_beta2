package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class AcodeCat
{

    private int   	id;
    private int   	name1;
    private int   	name2;


    public AcodeCat() {}


    public int   	getId   	() { return id; }
    public int   	getName1   	() { return name1; }
    public int   	getName2   	() { return name2; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName1   	(int name1) { this.name1 = name1; }
    public void 	setName2   	(int name2) { this.name2 = name2; }

}
