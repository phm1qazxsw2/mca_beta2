package mca;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class McaRecord
{

    private int   	id;
    private int   	mcaFeeId;
    private int   	billRecordId;


    public McaRecord() {}


    public int   	getId   	() { return id; }
    public int   	getMcaFeeId   	() { return mcaFeeId; }
    public int   	getBillRecordId   	() { return billRecordId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setMcaFeeId   	(int mcaFeeId) { this.mcaFeeId = mcaFeeId; }
    public void 	setBillRecordId   	(int billRecordId) { this.billRecordId = billRecordId; }

}
