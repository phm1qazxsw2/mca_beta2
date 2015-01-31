package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaExRate
{

    private int   	id;
    private double   	rate;
    private Date   	start;


    public McaExRate() {}


    public int   	getId   	() { return id; }
    public double   	getRate   	() { return rate; }
    public Date   	getStart   	() { return start; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setRate   	(double rate) { this.rate = rate; }
    public void 	setStart   	(Date start) { this.start = start; }

}
