package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaProrate
{

    private int   	id;
    private int   	mcaFeeId;
    private int   	membrId;
    private Date   	prorateDate;
    private int   	bunitId;


    public McaProrate() {}


    public int   	getId   	() { return id; }
    public int   	getMcaFeeId   	() { return mcaFeeId; }
    public int   	getMembrId   	() { return membrId; }
    public Date   	getProrateDate   	() { return prorateDate; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setMcaFeeId   	(int mcaFeeId) { this.mcaFeeId = mcaFeeId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setProrateDate   	(Date prorateDate) { this.prorateDate = prorateDate; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }

}
