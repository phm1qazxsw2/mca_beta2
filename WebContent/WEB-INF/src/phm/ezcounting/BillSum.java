package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillSum
{

    private int   	receivable;
    private int   	received;


    public BillSum() {}


    public int   	getReceivable   	() { return receivable; }
    public int   	getReceived   	() { return received; }


    public void 	setReceivable   	(int receivable) { this.receivable = receivable; }
    public void 	setReceived   	(int received) { this.received = received; }

}
