package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Schsw
{

    private int   	id;
    private Date   	recordTime;
    private int   	userId;
    private String   	note;
    private int   	reqMembrId;
    private int   	verifystatus;
    private Date   	verifyDate;
    private int   	verifyUserId;


    public Schsw() {}


    public int   	getId   	() { return id; }
    public Date   	getRecordTime   	() { return recordTime; }
    public int   	getUserId   	() { return userId; }
    public String   	getNote   	() { return note; }
    public int   	getReqMembrId   	() { return reqMembrId; }
    public int   	getVerifystatus   	() { return verifystatus; }
    public Date   	getVerifyDate   	() { return verifyDate; }
    public int   	getVerifyUserId   	() { return verifyUserId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setReqMembrId   	(int reqMembrId) { this.reqMembrId = reqMembrId; }
    public void 	setVerifystatus   	(int verifystatus) { this.verifystatus = verifystatus; }
    public void 	setVerifyDate   	(Date verifyDate) { this.verifyDate = verifyDate; }
    public void 	setVerifyUserId   	(int verifyUserId) { this.verifyUserId = verifyUserId; }

}
