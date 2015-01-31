package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrMembrData
{

    private int   	m1Id;
    private int   	m2Id;
    private String   	name;


    public MembrMembrData() {}


    public int   	getM1Id   	() { return m1Id; }
    public int   	getM2Id   	() { return m2Id; }
    public String   	getName   	() { return name; }


    public void 	setM1Id   	(int m1Id) { this.m1Id = m1Id; }
    public void 	setM2Id   	(int m2Id) { this.m2Id = m2Id; }
    public void 	setName   	(String name) { this.name = name; }

}
