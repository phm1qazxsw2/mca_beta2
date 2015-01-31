package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class ManHour
{

    private int   	id;
    private int   	clientMembrId;
    private int   	executeMembrId;
    private Date   	recordTime;
    private Date   	modifyTime;
    private Date   	occurDate;
    private int   	billfdId;
    private int   	salaryfdId;
    private int   	userId;


    public ManHour() {}


    public int   	getId   	() { return id; }
    public int   	getClientMembrId   	() { return clientMembrId; }
    public int   	getExecuteMembrId   	() { return executeMembrId; }
    public Date   	getRecordTime   	() { return recordTime; }
    public Date   	getModifyTime   	() { return modifyTime; }
    public Date   	getOccurDate   	() { return occurDate; }
    public int   	getBillfdId   	() { return billfdId; }
    public int   	getSalaryfdId   	() { return salaryfdId; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setClientMembrId   	(int clientMembrId) { this.clientMembrId = clientMembrId; }
    public void 	setExecuteMembrId   	(int executeMembrId) { this.executeMembrId = executeMembrId; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setModifyTime   	(Date modifyTime) { this.modifyTime = modifyTime; }
    public void 	setOccurDate   	(Date occurDate) { this.occurDate = occurDate; }
    public void 	setBillfdId   	(int billfdId) { this.billfdId = billfdId; }
    public void 	setSalaryfdId   	(int salaryfdId) { this.salaryfdId = salaryfdId; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

}
