package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryPay
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	salaryPaySanumberId;
    private Date   	salaryPayMonth;
    private int   	salaryPayTeacherId;
    private int   	salaryPayDeportId;
    private int   	salaryPayPositionId;
    private int   	salaryPayClassesId;
    private int   	salaryPayWay;
    private int   	salaryPayBankListId;
    private int   	salaryPayNumber;
    private String   	salaryPayPs;
    private int   	salaryPayLogId;
    private Date   	salaryPayLogDate;
    private String   	salaryPayLogPs;
    private int   	salaryPayStatus;


    public SalaryPay() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	salaryPaySanumberId,
        Date	salaryPayMonth,
        int	salaryPayTeacherId,
        int	salaryPayDeportId,
        int	salaryPayPositionId,
        int	salaryPayClassesId,
        int	salaryPayWay,
        int	salaryPayBankListId,
        int	salaryPayNumber,
        String	salaryPayPs,
        int	salaryPayLogId,
        Date	salaryPayLogDate,
        String	salaryPayLogPs,
        int	salaryPayStatus    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryPaySanumberId 	 = salaryPaySanumberId;
        this.salaryPayMonth 	 = salaryPayMonth;
        this.salaryPayTeacherId 	 = salaryPayTeacherId;
        this.salaryPayDeportId 	 = salaryPayDeportId;
        this.salaryPayPositionId 	 = salaryPayPositionId;
        this.salaryPayClassesId 	 = salaryPayClassesId;
        this.salaryPayWay 	 = salaryPayWay;
        this.salaryPayBankListId 	 = salaryPayBankListId;
        this.salaryPayNumber 	 = salaryPayNumber;
        this.salaryPayPs 	 = salaryPayPs;
        this.salaryPayLogId 	 = salaryPayLogId;
        this.salaryPayLogDate 	 = salaryPayLogDate;
        this.salaryPayLogPs 	 = salaryPayLogPs;
        this.salaryPayStatus 	 = salaryPayStatus;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getSalaryPaySanumberId   	() { return salaryPaySanumberId; }
    public Date   	getSalaryPayMonth   	() { return salaryPayMonth; }
    public int   	getSalaryPayTeacherId   	() { return salaryPayTeacherId; }
    public int   	getSalaryPayDeportId   	() { return salaryPayDeportId; }
    public int   	getSalaryPayPositionId   	() { return salaryPayPositionId; }
    public int   	getSalaryPayClassesId   	() { return salaryPayClassesId; }
    public int   	getSalaryPayWay   	() { return salaryPayWay; }
    public int   	getSalaryPayBankListId   	() { return salaryPayBankListId; }
    public int   	getSalaryPayNumber   	() { return salaryPayNumber; }
    public String   	getSalaryPayPs   	() { return salaryPayPs; }
    public int   	getSalaryPayLogId   	() { return salaryPayLogId; }
    public Date   	getSalaryPayLogDate   	() { return salaryPayLogDate; }
    public String   	getSalaryPayLogPs   	() { return salaryPayLogPs; }
    public int   	getSalaryPayStatus   	() { return salaryPayStatus; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryPaySanumberId   	(int salaryPaySanumberId) { this.salaryPaySanumberId = salaryPaySanumberId; }
    public void 	setSalaryPayMonth   	(Date salaryPayMonth) { this.salaryPayMonth = salaryPayMonth; }
    public void 	setSalaryPayTeacherId   	(int salaryPayTeacherId) { this.salaryPayTeacherId = salaryPayTeacherId; }
    public void 	setSalaryPayDeportId   	(int salaryPayDeportId) { this.salaryPayDeportId = salaryPayDeportId; }
    public void 	setSalaryPayPositionId   	(int salaryPayPositionId) { this.salaryPayPositionId = salaryPayPositionId; }
    public void 	setSalaryPayClassesId   	(int salaryPayClassesId) { this.salaryPayClassesId = salaryPayClassesId; }
    public void 	setSalaryPayWay   	(int salaryPayWay) { this.salaryPayWay = salaryPayWay; }
    public void 	setSalaryPayBankListId   	(int salaryPayBankListId) { this.salaryPayBankListId = salaryPayBankListId; }
    public void 	setSalaryPayNumber   	(int salaryPayNumber) { this.salaryPayNumber = salaryPayNumber; }
    public void 	setSalaryPayPs   	(String salaryPayPs) { this.salaryPayPs = salaryPayPs; }
    public void 	setSalaryPayLogId   	(int salaryPayLogId) { this.salaryPayLogId = salaryPayLogId; }
    public void 	setSalaryPayLogDate   	(Date salaryPayLogDate) { this.salaryPayLogDate = salaryPayLogDate; }
    public void 	setSalaryPayLogPs   	(String salaryPayLogPs) { this.salaryPayLogPs = salaryPayLogPs; }
    public void 	setSalaryPayStatus   	(int salaryPayStatus) { this.salaryPayStatus = salaryPayStatus; }
}
