package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class ChequeSum
{

    private int   	receivable;
    private int   	payable;


    public ChequeSum() {}


    public int   	getReceivable   	() { return receivable; }
    public int   	getPayable   	() { return payable; }


    public void 	setReceivable   	(int receivable) { this.receivable = receivable; }
    public void 	setPayable   	(int payable) { this.payable = payable; }

}
