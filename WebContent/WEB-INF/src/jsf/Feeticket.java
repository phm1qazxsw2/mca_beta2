package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Feeticket
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	feeticketMonth;
    private int   	feeticketFeenumberId;
    private int   	feeticketStuId;
    private int   	feeticketStuClassId;
    private int   	feeticketStuGroupId;
    private int   	feeticketStuLevelId;
    private int   	feeticketSholdMoney;
    private int   	feeticketDiscountMoney;
    private int   	feeticketTotalMoney;
    private int   	feeticketPayMoney;
    private Date   	feeticketPayDate;
    private int   	feeticketStatus;
    private Date   	feeticketEndPayDate;
    private String   	feeticketPs;
    private int   	feeticketNewFeenumber;
    private int   	feeticketNewFeenumberCmId;
    private int   	feeticketLock;
    private int   	feeticketPrintUpdate;


    public Feeticket() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	feeticketMonth,
        int	feeticketFeenumberId,
        int	feeticketStuId,
        int	feeticketStuClassId,
        int	feeticketStuGroupId,
        int	feeticketStuLevelId,
        int	feeticketSholdMoney,
        int	feeticketDiscountMoney,
        int	feeticketTotalMoney,
        int	feeticketPayMoney,
        Date	feeticketPayDate,
        int	feeticketStatus,
        Date	feeticketEndPayDate,
        String	feeticketPs,
        int	feeticketNewFeenumber,
        int	feeticketNewFeenumberCmId,
        int	feeticketLock,
        int	feeticketPrintUpdate    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.feeticketMonth 	 = feeticketMonth;
        this.feeticketFeenumberId 	 = feeticketFeenumberId;
        this.feeticketStuId 	 = feeticketStuId;
        this.feeticketStuClassId 	 = feeticketStuClassId;
        this.feeticketStuGroupId 	 = feeticketStuGroupId;
        this.feeticketStuLevelId 	 = feeticketStuLevelId;
        this.feeticketSholdMoney 	 = feeticketSholdMoney;
        this.feeticketDiscountMoney 	 = feeticketDiscountMoney;
        this.feeticketTotalMoney 	 = feeticketTotalMoney;
        this.feeticketPayMoney 	 = feeticketPayMoney;
        this.feeticketPayDate 	 = feeticketPayDate;
        this.feeticketStatus 	 = feeticketStatus;
        this.feeticketEndPayDate 	 = feeticketEndPayDate;
        this.feeticketPs 	 = feeticketPs;
        this.feeticketNewFeenumber 	 = feeticketNewFeenumber;
        this.feeticketNewFeenumberCmId 	 = feeticketNewFeenumberCmId;
        this.feeticketLock 	 = feeticketLock;
        this.feeticketPrintUpdate 	 = feeticketPrintUpdate;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getFeeticketMonth   	() { return feeticketMonth; }
    public int   	getFeeticketFeenumberId   	() { return feeticketFeenumberId; }
    public int   	getFeeticketStuId   	() { return feeticketStuId; }
    public int   	getFeeticketStuClassId   	() { return feeticketStuClassId; }
    public int   	getFeeticketStuGroupId   	() { return feeticketStuGroupId; }
    public int   	getFeeticketStuLevelId   	() { return feeticketStuLevelId; }
    public int   	getFeeticketSholdMoney   	() { return feeticketSholdMoney; }
    public int   	getFeeticketDiscountMoney   	() { return feeticketDiscountMoney; }
    public int   	getFeeticketTotalMoney   	() { return feeticketTotalMoney; }
    public int   	getFeeticketPayMoney   	() { return feeticketPayMoney; }
    public Date   	getFeeticketPayDate   	() { return feeticketPayDate; }
    public int   	getFeeticketStatus   	() { return feeticketStatus; }
    public Date   	getFeeticketEndPayDate   	() { return feeticketEndPayDate; }
    public String   	getFeeticketPs   	() { return feeticketPs; }
    public int   	getFeeticketNewFeenumber   	() { return feeticketNewFeenumber; }
    public int   	getFeeticketNewFeenumberCmId   	() { return feeticketNewFeenumberCmId; }
    public int   	getFeeticketLock   	() { return feeticketLock; }
    public int   	getFeeticketPrintUpdate   	() { return feeticketPrintUpdate; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setFeeticketMonth   	(Date feeticketMonth) { this.feeticketMonth = feeticketMonth; }
    public void 	setFeeticketFeenumberId   	(int feeticketFeenumberId) { this.feeticketFeenumberId = feeticketFeenumberId; }
    public void 	setFeeticketStuId   	(int feeticketStuId) { this.feeticketStuId = feeticketStuId; }
    public void 	setFeeticketStuClassId   	(int feeticketStuClassId) { this.feeticketStuClassId = feeticketStuClassId; }
    public void 	setFeeticketStuGroupId   	(int feeticketStuGroupId) { this.feeticketStuGroupId = feeticketStuGroupId; }
    public void 	setFeeticketStuLevelId   	(int feeticketStuLevelId) { this.feeticketStuLevelId = feeticketStuLevelId; }
    public void 	setFeeticketSholdMoney   	(int feeticketSholdMoney) { this.feeticketSholdMoney = feeticketSholdMoney; }
    public void 	setFeeticketDiscountMoney   	(int feeticketDiscountMoney) { this.feeticketDiscountMoney = feeticketDiscountMoney; }
    public void 	setFeeticketTotalMoney   	(int feeticketTotalMoney) { this.feeticketTotalMoney = feeticketTotalMoney; }
    public void 	setFeeticketPayMoney   	(int feeticketPayMoney) { this.feeticketPayMoney = feeticketPayMoney; }
    public void 	setFeeticketPayDate   	(Date feeticketPayDate) { this.feeticketPayDate = feeticketPayDate; }
    public void 	setFeeticketStatus   	(int feeticketStatus) { this.feeticketStatus = feeticketStatus; }
    public void 	setFeeticketEndPayDate   	(Date feeticketEndPayDate) { this.feeticketEndPayDate = feeticketEndPayDate; }
    public void 	setFeeticketPs   	(String feeticketPs) { this.feeticketPs = feeticketPs; }
    public void 	setFeeticketNewFeenumber   	(int feeticketNewFeenumber) { this.feeticketNewFeenumber = feeticketNewFeenumber; }
    public void 	setFeeticketNewFeenumberCmId   	(int feeticketNewFeenumberCmId) { this.feeticketNewFeenumberCmId = feeticketNewFeenumberCmId; }
    public void 	setFeeticketLock   	(int feeticketLock) { this.feeticketLock = feeticketLock; }
    public void 	setFeeticketPrintUpdate   	(int feeticketPrintUpdate) { this.feeticketPrintUpdate = feeticketPrintUpdate; }
}
