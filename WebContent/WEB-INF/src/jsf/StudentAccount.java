package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class StudentAccount
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	studentAccountStuId;
    private int   	studentAccountIncomeType;
    private int   	studentAccountMoney;
    private int   	studentAccountSourceType;
    private int   	studentAccountSourceId;
    private int   	studentAccountLogId;
    private Date   	studentAccountLogDate;
    private String   	studentAccountNumber;
    private int   	studentAccountPayFeeId;
    private int   	studentAccountRootSAId;
    private int   	studentAccountCostpayID;
    private String   	studentAccountPs;


    public StudentAccount() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	studentAccountStuId,
        int	studentAccountIncomeType,
        int	studentAccountMoney,
        int	studentAccountSourceType,
        int	studentAccountSourceId,
        int	studentAccountLogId,
        Date	studentAccountLogDate,
        String	studentAccountNumber,
        int	studentAccountPayFeeId,
        int	studentAccountRootSAId,
        int	studentAccountCostpayID,
        String	studentAccountPs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.studentAccountStuId 	 = studentAccountStuId;
        this.studentAccountIncomeType 	 = studentAccountIncomeType;
        this.studentAccountMoney 	 = studentAccountMoney;
        this.studentAccountSourceType 	 = studentAccountSourceType;
        this.studentAccountSourceId 	 = studentAccountSourceId;
        this.studentAccountLogId 	 = studentAccountLogId;
        this.studentAccountLogDate 	 = studentAccountLogDate;
        this.studentAccountNumber 	 = studentAccountNumber;
        this.studentAccountPayFeeId 	 = studentAccountPayFeeId;
        this.studentAccountRootSAId 	 = studentAccountRootSAId;
        this.studentAccountCostpayID 	 = studentAccountCostpayID;
        this.studentAccountPs 	 = studentAccountPs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getStudentAccountStuId   	() { return studentAccountStuId; }
    public int   	getStudentAccountIncomeType   	() { return studentAccountIncomeType; }
    public int   	getStudentAccountMoney   	() { return studentAccountMoney; }
    public int   	getStudentAccountSourceType   	() { return studentAccountSourceType; }
    public int   	getStudentAccountSourceId   	() { return studentAccountSourceId; }
    public int   	getStudentAccountLogId   	() { return studentAccountLogId; }
    public Date   	getStudentAccountLogDate   	() { return studentAccountLogDate; }
    public String   	getStudentAccountNumber   	() { return studentAccountNumber; }
    public int   	getStudentAccountPayFeeId   	() { return studentAccountPayFeeId; }
    public int   	getStudentAccountRootSAId   	() { return studentAccountRootSAId; }
    public int   	getStudentAccountCostpayID   	() { return studentAccountCostpayID; }
    public String   	getStudentAccountPs   	() { return studentAccountPs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setStudentAccountStuId   	(int studentAccountStuId) { this.studentAccountStuId = studentAccountStuId; }
    public void 	setStudentAccountIncomeType   	(int studentAccountIncomeType) { this.studentAccountIncomeType = studentAccountIncomeType; }
    public void 	setStudentAccountMoney   	(int studentAccountMoney) { this.studentAccountMoney = studentAccountMoney; }
    public void 	setStudentAccountSourceType   	(int studentAccountSourceType) { this.studentAccountSourceType = studentAccountSourceType; }
    public void 	setStudentAccountSourceId   	(int studentAccountSourceId) { this.studentAccountSourceId = studentAccountSourceId; }
    public void 	setStudentAccountLogId   	(int studentAccountLogId) { this.studentAccountLogId = studentAccountLogId; }
    public void 	setStudentAccountLogDate   	(Date studentAccountLogDate) { this.studentAccountLogDate = studentAccountLogDate; }
    public void 	setStudentAccountNumber   	(String studentAccountNumber) { this.studentAccountNumber = studentAccountNumber; }
    public void 	setStudentAccountPayFeeId   	(int studentAccountPayFeeId) { this.studentAccountPayFeeId = studentAccountPayFeeId; }
    public void 	setStudentAccountRootSAId   	(int studentAccountRootSAId) { this.studentAccountRootSAId = studentAccountRootSAId; }
    public void 	setStudentAccountCostpayID   	(int studentAccountCostpayID) { this.studentAccountCostpayID = studentAccountCostpayID; }
    public void 	setStudentAccountPs   	(String studentAccountPs) { this.studentAccountPs = studentAccountPs; }
}
