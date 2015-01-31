package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BillPayInfo extends BillPay
{

    private String   	membrName;


    public BillPayInfo() {}


    public String   	getMembrName   	() { return membrName; }


    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }

}
