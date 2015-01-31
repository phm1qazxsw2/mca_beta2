package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchswRecordx extends SchswRecord
{

    private Date   	startDate;
    private Date   	endDate;
    private int   	reqMembrId;
    private String   	schdefName;
    private String   	membrName;


    public SchswRecordx() {}


    public Date   	getStartDate   	() { return startDate; }
    public Date   	getEndDate   	() { return endDate; }
    public int   	getReqMembrId   	() { return reqMembrId; }
    public String   	getSchdefName   	() { return schdefName; }
    public String   	getMembrName   	() { return membrName; }


    public void 	setStartDate   	(Date startDate) { this.startDate = startDate; }
    public void 	setEndDate   	(Date endDate) { this.endDate = endDate; }
    public void 	setReqMembrId   	(int reqMembrId) { this.reqMembrId = reqMembrId; }
    public void 	setSchdefName   	(String schdefName) { this.schdefName = schdefName; }
    public void 	setMembrName   	(String membrName) { this.membrName = membrName; }

}
