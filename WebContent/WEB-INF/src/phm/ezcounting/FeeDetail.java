package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class FeeDetail
{

    private int   	id;
    private int   	chargeItemId;
    private int   	membrId;
    private int   	unitPrice;
    private int   	num;
    private Date   	feeTime;
    private String   	note;
    private int   	userId;
    private int   	manhourId;
    private int   	payrollMembrId;
    private int   	payrollFdId;


    public FeeDetail() {}


    public int   	getId   	() { return id; }
    public int   	getChargeItemId   	() { return chargeItemId; }
    public int   	getMembrId   	() { return membrId; }
    public int   	getUnitPrice   	() { return unitPrice; }
    public int   	getNum   	() { return num; }
    public Date   	getFeeTime   	() { return feeTime; }
    public String   	getNote   	() { return note; }
    public int   	getUserId   	() { return userId; }
    public int   	getManhourId   	() { return manhourId; }
    public int   	getPayrollMembrId   	() { return payrollMembrId; }
    public int   	getPayrollFdId   	() { return payrollFdId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setChargeItemId   	(int chargeItemId) { this.chargeItemId = chargeItemId; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setUnitPrice   	(int unitPrice) { this.unitPrice = unitPrice; }
    public void 	setNum   	(int num) { this.num = num; }
    public void 	setFeeTime   	(Date feeTime) { this.feeTime = feeTime; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setManhourId   	(int manhourId) { this.manhourId = manhourId; }
    public void 	setPayrollMembrId   	(int payrollMembrId) { this.payrollMembrId = payrollMembrId; }
    public void 	setPayrollFdId   	(int payrollFdId) { this.payrollFdId = payrollFdId; }
    public String getChargeKey()
    {
        return getMembrId()+"#"+getChargeItemId();
    }

    public FeeDetail clone()
    {
        FeeDetail fd = new FeeDetail();
	fd.setId(this.getId());
	fd.setChargeItemId(this.getChargeItemId());
	fd.setMembrId(this.getMembrId());
	fd.setUnitPrice(this.getUnitPrice());
	fd.setNum(this.getNum());
	fd.setFeeTime(this.getFeeTime());
	fd.setNote(this.getNote());
	fd.setUserId(this.getUserId());
	fd.setPayrollMembrId(this.getPayrollMembrId());
	fd.setPayrollFdId(this.getPayrollFdId());
	return fd;
    }

}
