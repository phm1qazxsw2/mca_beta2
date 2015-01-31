package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillSource
{

    private int   	id;
    private String   	line;


    public BillSource() {}


    public int   	getId   	() { return id; }
    public String   	getLine   	() { return line; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setLine   	(String line) { this.line = line; }

}
