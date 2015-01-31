package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class ChargeMembr
{

    private int   	membrId;
    private int   	chargeItemId;
    private String   	membrName;


    public ChargeMembr() {}


    public int   	getMembrId   	() { return membrId; }
    public int   	getChargeItemId   	() { return chargeItemId; }
    public String   	getMembrName   	() { return membrName; }


    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setChargeItemId   	(int chargeItemId) { this.chargeItemId = chargeItemId; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }

}
