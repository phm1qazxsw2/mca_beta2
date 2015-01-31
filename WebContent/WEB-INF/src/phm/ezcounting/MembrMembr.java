package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class MembrMembr
{

    private int   	m1Id;
    private int   	m2Id;


    public MembrMembr() {}


    public int   	getM1Id   	() { return m1Id; }
    public int   	getM2Id   	() { return m2Id; }


    public void 	setM1Id   	(int m1Id) { this.m1Id = m1Id; }
    public void 	setM2Id   	(int m2Id) { this.m2Id = m2Id; }

}
