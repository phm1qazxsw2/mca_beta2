package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryOut
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	salaryOutMonth;
    private int   	salaryOutBanknumber;
    private int   	salaryOutBankAccountId;
    private int   	salaryOutStatus;
    private String   	salaryOutPs;
    private Date   	salaryOutPayDate;
    private int   	salaryOutPayUser;
    private String   	salaryOutPayPs;


    public SalaryOut() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	salaryOutMonth,
        int	salaryOutBanknumber,
        int	salaryOutBankAccountId,
        int	salaryOutStatus,
        String	salaryOutPs,
        Date	salaryOutPayDate,
        int	salaryOutPayUser,
        String	salaryOutPayPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryOutMonth 	 = salaryOutMonth;
        this.salaryOutBanknumber 	 = salaryOutBanknumber;
        this.salaryOutBankAccountId 	 = salaryOutBankAccountId;
        this.salaryOutStatus 	 = salaryOutStatus;
        this.salaryOutPs 	 = salaryOutPs;
        this.salaryOutPayDate 	 = salaryOutPayDate;
        this.salaryOutPayUser 	 = salaryOutPayUser;
        this.salaryOutPayPs 	 = salaryOutPayPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getSalaryOutMonth   	() { return salaryOutMonth; }
    public int   	getSalaryOutBanknumber   	() { return salaryOutBanknumber; }
    public int   	getSalaryOutBankAccountId   	() { return salaryOutBankAccountId; }
    public int   	getSalaryOutStatus   	() { return salaryOutStatus; }
    public String   	getSalaryOutPs   	() { return salaryOutPs; }
    public Date   	getSalaryOutPayDate   	() { return salaryOutPayDate; }
    public int   	getSalaryOutPayUser   	() { return salaryOutPayUser; }
    public String   	getSalaryOutPayPs   	() { return salaryOutPayPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryOutMonth   	(Date salaryOutMonth) { this.salaryOutMonth = salaryOutMonth; }
    public void 	setSalaryOutBanknumber   	(int salaryOutBanknumber) { this.salaryOutBanknumber = salaryOutBanknumber; }
    public void 	setSalaryOutBankAccountId   	(int salaryOutBankAccountId) { this.salaryOutBankAccountId = salaryOutBankAccountId; }
    public void 	setSalaryOutStatus   	(int salaryOutStatus) { this.salaryOutStatus = salaryOutStatus; }
    public void 	setSalaryOutPs   	(String salaryOutPs) { this.salaryOutPs = salaryOutPs; }
    public void 	setSalaryOutPayDate   	(Date salaryOutPayDate) { this.salaryOutPayDate = salaryOutPayDate; }
    public void 	setSalaryOutPayUser   	(int salaryOutPayUser) { this.salaryOutPayUser = salaryOutPayUser; }
    public void 	setSalaryOutPayPs   	(String salaryOutPayPs) { this.salaryOutPayPs = salaryOutPayPs; }
}
