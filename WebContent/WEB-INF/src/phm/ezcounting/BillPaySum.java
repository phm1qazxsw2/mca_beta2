package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillPaySum
{

    private int   	amount;
    private int   	remain;


    public BillPaySum() {}


    public int   	getAmount   	() { return amount; }
    public int   	getRemain   	() { return remain; }


    public void 	setAmount   	(int amount) { this.amount = amount; }
    public void 	setRemain   	(int remain) { this.remain = remain; }

}
