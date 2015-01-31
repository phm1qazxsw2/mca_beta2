package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaFeeRecord extends phm.ezcounting.BillRecord
{

    private int   	feeId;
    private int   	bunitId;


    public McaFeeRecord() {}


    public int   	getFeeId   	() { return feeId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setFeeId   	(int feeId) { this.feeId = feeId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
