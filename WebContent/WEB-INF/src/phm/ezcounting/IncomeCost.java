package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class IncomeCost
{

    private int   	cost;
    private int   	income;
    private double   	orgAmount;


    public IncomeCost() {}


    public int   	getCost   	() { return cost; }
    public int   	getIncome   	() { return income; }
    public double   	getOrgAmount   	() { return orgAmount; }


    public void 	setCost   	(int cost) { this.cost = cost; }
    public void 	setIncome   	(int income) { this.income = income; }
    public void 	setOrgAmount   	(double orgAmount) { this.orgAmount = orgAmount; }

}
