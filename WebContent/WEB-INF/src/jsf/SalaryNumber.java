package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryNumber
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	salaryNumberTypeId;
    private int   	salaryNumberTeacherId;
    private int   	salaryNumberMoneyNumber;
    private int   	salaryNumberLogId;
    private Date   	salaryNumberLogDate;
    private String   	salaryNumberPs;


    public SalaryNumber() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	salaryNumberTypeId,
        int	salaryNumberTeacherId,
        int	salaryNumberMoneyNumber,
        int	salaryNumberLogId,
        Date	salaryNumberLogDate,
        String	salaryNumberPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryNumberTypeId 	 = salaryNumberTypeId;
        this.salaryNumberTeacherId 	 = salaryNumberTeacherId;
        this.salaryNumberMoneyNumber 	 = salaryNumberMoneyNumber;
        this.salaryNumberLogId 	 = salaryNumberLogId;
        this.salaryNumberLogDate 	 = salaryNumberLogDate;
        this.salaryNumberPs 	 = salaryNumberPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getSalaryNumberTypeId   	() { return salaryNumberTypeId; }
    public int   	getSalaryNumberTeacherId   	() { return salaryNumberTeacherId; }
    public int   	getSalaryNumberMoneyNumber   	() { return salaryNumberMoneyNumber; }
    public int   	getSalaryNumberLogId   	() { return salaryNumberLogId; }
    public Date   	getSalaryNumberLogDate   	() { return salaryNumberLogDate; }
    public String   	getSalaryNumberPs   	() { return salaryNumberPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryNumberTypeId   	(int salaryNumberTypeId) { this.salaryNumberTypeId = salaryNumberTypeId; }
    public void 	setSalaryNumberTeacherId   	(int salaryNumberTeacherId) { this.salaryNumberTeacherId = salaryNumberTeacherId; }
    public void 	setSalaryNumberMoneyNumber   	(int salaryNumberMoneyNumber) { this.salaryNumberMoneyNumber = salaryNumberMoneyNumber; }
    public void 	setSalaryNumberLogId   	(int salaryNumberLogId) { this.salaryNumberLogId = salaryNumberLogId; }
    public void 	setSalaryNumberLogDate   	(Date salaryNumberLogDate) { this.salaryNumberLogDate = salaryNumberLogDate; }
    public void 	setSalaryNumberPs   	(String salaryNumberPs) { this.salaryNumberPs = salaryNumberPs; }
}
