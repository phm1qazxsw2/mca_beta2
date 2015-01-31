package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryBank
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	salaryBankMonth;
    private int   	salaryBankTeacherId;
    private int   	salaryBankSanumber;
    private int   	salaryBankDeportId;
    private int   	salaryBankPositionId;
    private int   	salaryBankClassesId;
    private int   	salaryBankMoney;
    private int   	salaryBankBankNumberId;
    private int   	salaryBankStatus;
    private Date   	salaryBankPayDate;
    private int   	salaryBankPayWay;
    private int   	salaryBankPayAccountType;
    private int   	salaryBankPayAccountId;
    private int   	salaryBankToId;
    private String   	salaryBankToAccount;
    private int   	salaryBankLogId;
    private String   	salaryBankLogPs;
    private int   	salaryBankVerifyStatus;
    private int   	salaryBankVerifyId;
    private Date   	salaryBankVerifyDate;
    private String   	salaryBankVerifyPs;


    public SalaryBank() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	salaryBankMonth,
        int	salaryBankTeacherId,
        int	salaryBankSanumber,
        int	salaryBankDeportId,
        int	salaryBankPositionId,
        int	salaryBankClassesId,
        int	salaryBankMoney,
        int	salaryBankBankNumberId,
        int	salaryBankStatus,
        Date	salaryBankPayDate,
        int	salaryBankPayWay,
        int	salaryBankPayAccountType,
        int	salaryBankPayAccountId,
        int	salaryBankToId,
        String	salaryBankToAccount,
        int	salaryBankLogId,
        String	salaryBankLogPs,
        int	salaryBankVerifyStatus,
        int	salaryBankVerifyId,
        Date	salaryBankVerifyDate,
        String	salaryBankVerifyPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryBankMonth 	 = salaryBankMonth;
        this.salaryBankTeacherId 	 = salaryBankTeacherId;
        this.salaryBankSanumber 	 = salaryBankSanumber;
        this.salaryBankDeportId 	 = salaryBankDeportId;
        this.salaryBankPositionId 	 = salaryBankPositionId;
        this.salaryBankClassesId 	 = salaryBankClassesId;
        this.salaryBankMoney 	 = salaryBankMoney;
        this.salaryBankBankNumberId 	 = salaryBankBankNumberId;
        this.salaryBankStatus 	 = salaryBankStatus;
        this.salaryBankPayDate 	 = salaryBankPayDate;
        this.salaryBankPayWay 	 = salaryBankPayWay;
        this.salaryBankPayAccountType 	 = salaryBankPayAccountType;
        this.salaryBankPayAccountId 	 = salaryBankPayAccountId;
        this.salaryBankToId 	 = salaryBankToId;
        this.salaryBankToAccount 	 = salaryBankToAccount;
        this.salaryBankLogId 	 = salaryBankLogId;
        this.salaryBankLogPs 	 = salaryBankLogPs;
        this.salaryBankVerifyStatus 	 = salaryBankVerifyStatus;
        this.salaryBankVerifyId 	 = salaryBankVerifyId;
        this.salaryBankVerifyDate 	 = salaryBankVerifyDate;
        this.salaryBankVerifyPs 	 = salaryBankVerifyPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getSalaryBankMonth   	() { return salaryBankMonth; }
    public int   	getSalaryBankTeacherId   	() { return salaryBankTeacherId; }
    public int   	getSalaryBankSanumber   	() { return salaryBankSanumber; }
    public int   	getSalaryBankDeportId   	() { return salaryBankDeportId; }
    public int   	getSalaryBankPositionId   	() { return salaryBankPositionId; }
    public int   	getSalaryBankClassesId   	() { return salaryBankClassesId; }
    public int   	getSalaryBankMoney   	() { return salaryBankMoney; }
    public int   	getSalaryBankBankNumberId   	() { return salaryBankBankNumberId; }
    public int   	getSalaryBankStatus   	() { return salaryBankStatus; }
    public Date   	getSalaryBankPayDate   	() { return salaryBankPayDate; }
    public int   	getSalaryBankPayWay   	() { return salaryBankPayWay; }
    public int   	getSalaryBankPayAccountType   	() { return salaryBankPayAccountType; }
    public int   	getSalaryBankPayAccountId   	() { return salaryBankPayAccountId; }
    public int   	getSalaryBankToId   	() { return salaryBankToId; }
    public String   	getSalaryBankToAccount   	() { return salaryBankToAccount; }
    public int   	getSalaryBankLogId   	() { return salaryBankLogId; }
    public String   	getSalaryBankLogPs   	() { return salaryBankLogPs; }
    public int   	getSalaryBankVerifyStatus   	() { return salaryBankVerifyStatus; }
    public int   	getSalaryBankVerifyId   	() { return salaryBankVerifyId; }
    public Date   	getSalaryBankVerifyDate   	() { return salaryBankVerifyDate; }
    public String   	getSalaryBankVerifyPs   	() { return salaryBankVerifyPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryBankMonth   	(Date salaryBankMonth) { this.salaryBankMonth = salaryBankMonth; }
    public void 	setSalaryBankTeacherId   	(int salaryBankTeacherId) { this.salaryBankTeacherId = salaryBankTeacherId; }
    public void 	setSalaryBankSanumber   	(int salaryBankSanumber) { this.salaryBankSanumber = salaryBankSanumber; }
    public void 	setSalaryBankDeportId   	(int salaryBankDeportId) { this.salaryBankDeportId = salaryBankDeportId; }
    public void 	setSalaryBankPositionId   	(int salaryBankPositionId) { this.salaryBankPositionId = salaryBankPositionId; }
    public void 	setSalaryBankClassesId   	(int salaryBankClassesId) { this.salaryBankClassesId = salaryBankClassesId; }
    public void 	setSalaryBankMoney   	(int salaryBankMoney) { this.salaryBankMoney = salaryBankMoney; }
    public void 	setSalaryBankBankNumberId   	(int salaryBankBankNumberId) { this.salaryBankBankNumberId = salaryBankBankNumberId; }
    public void 	setSalaryBankStatus   	(int salaryBankStatus) { this.salaryBankStatus = salaryBankStatus; }
    public void 	setSalaryBankPayDate   	(Date salaryBankPayDate) { this.salaryBankPayDate = salaryBankPayDate; }
    public void 	setSalaryBankPayWay   	(int salaryBankPayWay) { this.salaryBankPayWay = salaryBankPayWay; }
    public void 	setSalaryBankPayAccountType   	(int salaryBankPayAccountType) { this.salaryBankPayAccountType = salaryBankPayAccountType; }
    public void 	setSalaryBankPayAccountId   	(int salaryBankPayAccountId) { this.salaryBankPayAccountId = salaryBankPayAccountId; }
    public void 	setSalaryBankToId   	(int salaryBankToId) { this.salaryBankToId = salaryBankToId; }
    public void 	setSalaryBankToAccount   	(String salaryBankToAccount) { this.salaryBankToAccount = salaryBankToAccount; }
    public void 	setSalaryBankLogId   	(int salaryBankLogId) { this.salaryBankLogId = salaryBankLogId; }
    public void 	setSalaryBankLogPs   	(String salaryBankLogPs) { this.salaryBankLogPs = salaryBankLogPs; }
    public void 	setSalaryBankVerifyStatus   	(int salaryBankVerifyStatus) { this.salaryBankVerifyStatus = salaryBankVerifyStatus; }
    public void 	setSalaryBankVerifyId   	(int salaryBankVerifyId) { this.salaryBankVerifyId = salaryBankVerifyId; }
    public void 	setSalaryBankVerifyDate   	(Date salaryBankVerifyDate) { this.salaryBankVerifyDate = salaryBankVerifyDate; }
    public void 	setSalaryBankVerifyPs   	(String salaryBankVerifyPs) { this.salaryBankVerifyPs = salaryBankVerifyPs; }
}
