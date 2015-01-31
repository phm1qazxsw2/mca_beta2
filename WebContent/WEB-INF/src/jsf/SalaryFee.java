package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryFee
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	salaryFeeSanumberId;
    private Date   	salaryFeeMonth;
    private int   	salaryFeeTeacherId;
    private int   	salaryFeeDeportId;
    private int   	salaryFeePositionId;
    private int   	salaryFeeClassesId;
    private int   	salaryFeeType;
    private int   	salaryFeeTypeId;
    private int   	salaryFeeNumber;
    private int   	salaryFeePrintNeed;
    private int   	salaryFeeLogId;
    private String   	salaryFeeLogPs;
    private int   	salaryFeeVNeed;
    private int   	salaryFeeVUserId;
    private Date   	salaryFeeVDate;
    private String   	salaryFeeVPs;
    private int   	salaryFeeStatus;


    public SalaryFee() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	salaryFeeSanumberId,
        Date	salaryFeeMonth,
        int	salaryFeeTeacherId,
        int	salaryFeeDeportId,
        int	salaryFeePositionId,
        int	salaryFeeClassesId,
        int	salaryFeeType,
        int	salaryFeeTypeId,
        int	salaryFeeNumber,
        int	salaryFeePrintNeed,
        int	salaryFeeLogId,
        String	salaryFeeLogPs,
        int	salaryFeeVNeed,
        int	salaryFeeVUserId,
        Date	salaryFeeVDate,
        String	salaryFeeVPs,
        int	salaryFeeStatus    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryFeeSanumberId 	 = salaryFeeSanumberId;
        this.salaryFeeMonth 	 = salaryFeeMonth;
        this.salaryFeeTeacherId 	 = salaryFeeTeacherId;
        this.salaryFeeDeportId 	 = salaryFeeDeportId;
        this.salaryFeePositionId 	 = salaryFeePositionId;
        this.salaryFeeClassesId 	 = salaryFeeClassesId;
        this.salaryFeeType 	 = salaryFeeType;
        this.salaryFeeTypeId 	 = salaryFeeTypeId;
        this.salaryFeeNumber 	 = salaryFeeNumber;
        this.salaryFeePrintNeed 	 = salaryFeePrintNeed;
        this.salaryFeeLogId 	 = salaryFeeLogId;
        this.salaryFeeLogPs 	 = salaryFeeLogPs;
        this.salaryFeeVNeed 	 = salaryFeeVNeed;
        this.salaryFeeVUserId 	 = salaryFeeVUserId;
        this.salaryFeeVDate 	 = salaryFeeVDate;
        this.salaryFeeVPs 	 = salaryFeeVPs;
        this.salaryFeeStatus 	 = salaryFeeStatus;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getSalaryFeeSanumberId   	() { return salaryFeeSanumberId; }
    public Date   	getSalaryFeeMonth   	() { return salaryFeeMonth; }
    public int   	getSalaryFeeTeacherId   	() { return salaryFeeTeacherId; }
    public int   	getSalaryFeeDeportId   	() { return salaryFeeDeportId; }
    public int   	getSalaryFeePositionId   	() { return salaryFeePositionId; }
    public int   	getSalaryFeeClassesId   	() { return salaryFeeClassesId; }
    public int   	getSalaryFeeType   	() { return salaryFeeType; }
    public int   	getSalaryFeeTypeId   	() { return salaryFeeTypeId; }
    public int   	getSalaryFeeNumber   	() { return salaryFeeNumber; }
    public int   	getSalaryFeePrintNeed   	() { return salaryFeePrintNeed; }
    public int   	getSalaryFeeLogId   	() { return salaryFeeLogId; }
    public String   	getSalaryFeeLogPs   	() { return salaryFeeLogPs; }
    public int   	getSalaryFeeVNeed   	() { return salaryFeeVNeed; }
    public int   	getSalaryFeeVUserId   	() { return salaryFeeVUserId; }
    public Date   	getSalaryFeeVDate   	() { return salaryFeeVDate; }
    public String   	getSalaryFeeVPs   	() { return salaryFeeVPs; }
    public int   	getSalaryFeeStatus   	() { return salaryFeeStatus; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryFeeSanumberId   	(int salaryFeeSanumberId) { this.salaryFeeSanumberId = salaryFeeSanumberId; }
    public void 	setSalaryFeeMonth   	(Date salaryFeeMonth) { this.salaryFeeMonth = salaryFeeMonth; }
    public void 	setSalaryFeeTeacherId   	(int salaryFeeTeacherId) { this.salaryFeeTeacherId = salaryFeeTeacherId; }
    public void 	setSalaryFeeDeportId   	(int salaryFeeDeportId) { this.salaryFeeDeportId = salaryFeeDeportId; }
    public void 	setSalaryFeePositionId   	(int salaryFeePositionId) { this.salaryFeePositionId = salaryFeePositionId; }
    public void 	setSalaryFeeClassesId   	(int salaryFeeClassesId) { this.salaryFeeClassesId = salaryFeeClassesId; }
    public void 	setSalaryFeeType   	(int salaryFeeType) { this.salaryFeeType = salaryFeeType; }
    public void 	setSalaryFeeTypeId   	(int salaryFeeTypeId) { this.salaryFeeTypeId = salaryFeeTypeId; }
    public void 	setSalaryFeeNumber   	(int salaryFeeNumber) { this.salaryFeeNumber = salaryFeeNumber; }
    public void 	setSalaryFeePrintNeed   	(int salaryFeePrintNeed) { this.salaryFeePrintNeed = salaryFeePrintNeed; }
    public void 	setSalaryFeeLogId   	(int salaryFeeLogId) { this.salaryFeeLogId = salaryFeeLogId; }
    public void 	setSalaryFeeLogPs   	(String salaryFeeLogPs) { this.salaryFeeLogPs = salaryFeeLogPs; }
    public void 	setSalaryFeeVNeed   	(int salaryFeeVNeed) { this.salaryFeeVNeed = salaryFeeVNeed; }
    public void 	setSalaryFeeVUserId   	(int salaryFeeVUserId) { this.salaryFeeVUserId = salaryFeeVUserId; }
    public void 	setSalaryFeeVDate   	(Date salaryFeeVDate) { this.salaryFeeVDate = salaryFeeVDate; }
    public void 	setSalaryFeeVPs   	(String salaryFeeVPs) { this.salaryFeeVPs = salaryFeeVPs; }
    public void 	setSalaryFeeStatus   	(int salaryFeeStatus) { this.salaryFeeStatus = salaryFeeStatus; }
}
