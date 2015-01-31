package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class BitemVchr
{

    private int   	billItemId;
    private int   	vchrId;


    public BitemVchr() {}


    public int   	getBillItemId   	() { return billItemId; }
    public int   	getVchrId   	() { return vchrId; }


    public void 	setBillItemId   	(int billItemId) { this.billItemId = billItemId; }
    public void 	setVchrId   	(int vchrId) { this.vchrId = vchrId; }

}
