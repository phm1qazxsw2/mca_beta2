package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Binfo
{

    private int   	bunitId;
    private int   	bankId;
    private String   	virtualID;
    private String   	storeID;
    private String   	serviceID;
    private int   	studentBunitId;
    private int   	acodeBunitId;
    private int   	metaBunitId;
    private int   	unpaidBunitId;
    private String   	fullname;
    private String   	address;
    private String   	phone;
    private String   	web;
    private String   	billNote;
    private String   	smsText;


    public Binfo() {}


    public int   	getBunitId   	() { return bunitId; }
    public int   	getBankId   	() { return bankId; }
    public String   	getVirtualID   	() { return virtualID; }
    public String   	getStoreID   	() { return storeID; }
    public String   	getServiceID   	() { return serviceID; }
    public int   	getStudentBunitId   	() { return studentBunitId; }
    public int   	getAcodeBunitId   	() { return acodeBunitId; }
    public int   	getMetaBunitId   	() { return metaBunitId; }
    public int   	getUnpaidBunitId   	() { return unpaidBunitId; }
    public String   	getFullname   	() { return fullname; }
    public String   	getAddress   	() { return address; }
    public String   	getPhone   	() { return phone; }
    public String   	getWeb   	() { return web; }
    public String   	getBillNote   	() { return billNote; }
    public String   	getSmsText   	() { return smsText; }


    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
    public void 	setBankId   	(int bankId) { this.bankId = bankId; }
    public void 	setVirtualID   	(String virtualID) { this.virtualID = virtualID; }
    public void 	setStoreID   	(String storeID) { this.storeID = storeID; }
    public void 	setServiceID   	(String serviceID) { this.serviceID = serviceID; }
    public void 	setStudentBunitId   	(int studentBunitId) { this.studentBunitId = studentBunitId; }
    public void 	setAcodeBunitId   	(int acodeBunitId) { this.acodeBunitId = acodeBunitId; }
    public void 	setMetaBunitId   	(int metaBunitId) { this.metaBunitId = metaBunitId; }
    public void 	setUnpaidBunitId   	(int unpaidBunitId) { this.unpaidBunitId = unpaidBunitId; }
    public void 	setFullname   	(String fullname) { this.fullname = fullname; }
    public void 	setAddress   	(String address) { this.address = address; }
    public void 	setPhone   	(String phone) { this.phone = phone; }
    public void 	setWeb   	(String web) { this.web = web; }
    public void 	setBillNote   	(String billNote) { this.billNote = billNote; }
    public void 	setSmsText   	(String smsText) { this.smsText = smsText; }

}
