package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Closemonth
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	closemonthMonth;
    private int   	closemonthStatus;
    private int   	closemonthUserId;
    private String   	closemonthPs;
    private int   	closemonthFeesNum;
    private int   	closemonthFeesNotNum;
    private int   	closemonthFeestatus;
    private Date   	closemonthFeeDate;
    private int   	closemonthFeeUserId;
    private String   	closemonthFeePs;
    private int   	closemonthIncomestatus;
    private int   	closemonthIncomeNum;
    private int   	closemonthIncomeNotNum;
    private Date   	closemonthIncomeDate;
    private int   	closemonthIncomeUserId;
    private String   	closemonthIncomePs;
    private int   	closemonthSalarystatus;
    private int   	closemonthSalaryNum;
    private int   	closemonthSalaryNotNum;
    private Date   	closemonthSalaryDate;
    private int   	closemonthSalaryUserId;
    private String   	closemonthSalaryPs;
    private int   	closemonthCoststatus;
    private int   	closemonthCostNum;
    private int   	closemonthCostNotNum;
    private Date   	closemonthCostDate;
    private int   	closemonthCostUserId;
    private String   	closemonthCostPs;
    private int   	closemonthFeePrepay;


    public Closemonth() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	closemonthMonth,
        int	closemonthStatus,
        int	closemonthUserId,
        String	closemonthPs,
        int	closemonthFeesNum,
        int	closemonthFeesNotNum,
        int	closemonthFeestatus,
        Date	closemonthFeeDate,
        int	closemonthFeeUserId,
        String	closemonthFeePs,
        int	closemonthIncomestatus,
        int	closemonthIncomeNum,
        int	closemonthIncomeNotNum,
        Date	closemonthIncomeDate,
        int	closemonthIncomeUserId,
        String	closemonthIncomePs,
        int	closemonthSalarystatus,
        int	closemonthSalaryNum,
        int	closemonthSalaryNotNum,
        Date	closemonthSalaryDate,
        int	closemonthSalaryUserId,
        String	closemonthSalaryPs,
        int	closemonthCoststatus,
        int	closemonthCostNum,
        int	closemonthCostNotNum,
        Date	closemonthCostDate,
        int	closemonthCostUserId,
        String	closemonthCostPs,
        int	closemonthFeePrepay    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.closemonthMonth 	 = closemonthMonth;
        this.closemonthStatus 	 = closemonthStatus;
        this.closemonthUserId 	 = closemonthUserId;
        this.closemonthPs 	 = closemonthPs;
        this.closemonthFeesNum 	 = closemonthFeesNum;
        this.closemonthFeesNotNum 	 = closemonthFeesNotNum;
        this.closemonthFeestatus 	 = closemonthFeestatus;
        this.closemonthFeeDate 	 = closemonthFeeDate;
        this.closemonthFeeUserId 	 = closemonthFeeUserId;
        this.closemonthFeePs 	 = closemonthFeePs;
        this.closemonthIncomestatus 	 = closemonthIncomestatus;
        this.closemonthIncomeNum 	 = closemonthIncomeNum;
        this.closemonthIncomeNotNum 	 = closemonthIncomeNotNum;
        this.closemonthIncomeDate 	 = closemonthIncomeDate;
        this.closemonthIncomeUserId 	 = closemonthIncomeUserId;
        this.closemonthIncomePs 	 = closemonthIncomePs;
        this.closemonthSalarystatus 	 = closemonthSalarystatus;
        this.closemonthSalaryNum 	 = closemonthSalaryNum;
        this.closemonthSalaryNotNum 	 = closemonthSalaryNotNum;
        this.closemonthSalaryDate 	 = closemonthSalaryDate;
        this.closemonthSalaryUserId 	 = closemonthSalaryUserId;
        this.closemonthSalaryPs 	 = closemonthSalaryPs;
        this.closemonthCoststatus 	 = closemonthCoststatus;
        this.closemonthCostNum 	 = closemonthCostNum;
        this.closemonthCostNotNum 	 = closemonthCostNotNum;
        this.closemonthCostDate 	 = closemonthCostDate;
        this.closemonthCostUserId 	 = closemonthCostUserId;
        this.closemonthCostPs 	 = closemonthCostPs;
        this.closemonthFeePrepay 	 = closemonthFeePrepay;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getClosemonthMonth   	() { return closemonthMonth; }
    public int   	getClosemonthStatus   	() { return closemonthStatus; }
    public int   	getClosemonthUserId   	() { return closemonthUserId; }
    public String   	getClosemonthPs   	() { return closemonthPs; }
    public int   	getClosemonthFeesNum   	() { return closemonthFeesNum; }
    public int   	getClosemonthFeesNotNum   	() { return closemonthFeesNotNum; }
    public int   	getClosemonthFeestatus   	() { return closemonthFeestatus; }
    public Date   	getClosemonthFeeDate   	() { return closemonthFeeDate; }
    public int   	getClosemonthFeeUserId   	() { return closemonthFeeUserId; }
    public String   	getClosemonthFeePs   	() { return closemonthFeePs; }
    public int   	getClosemonthIncomestatus   	() { return closemonthIncomestatus; }
    public int   	getClosemonthIncomeNum   	() { return closemonthIncomeNum; }
    public int   	getClosemonthIncomeNotNum   	() { return closemonthIncomeNotNum; }
    public Date   	getClosemonthIncomeDate   	() { return closemonthIncomeDate; }
    public int   	getClosemonthIncomeUserId   	() { return closemonthIncomeUserId; }
    public String   	getClosemonthIncomePs   	() { return closemonthIncomePs; }
    public int   	getClosemonthSalarystatus   	() { return closemonthSalarystatus; }
    public int   	getClosemonthSalaryNum   	() { return closemonthSalaryNum; }
    public int   	getClosemonthSalaryNotNum   	() { return closemonthSalaryNotNum; }
    public Date   	getClosemonthSalaryDate   	() { return closemonthSalaryDate; }
    public int   	getClosemonthSalaryUserId   	() { return closemonthSalaryUserId; }
    public String   	getClosemonthSalaryPs   	() { return closemonthSalaryPs; }
    public int   	getClosemonthCoststatus   	() { return closemonthCoststatus; }
    public int   	getClosemonthCostNum   	() { return closemonthCostNum; }
    public int   	getClosemonthCostNotNum   	() { return closemonthCostNotNum; }
    public Date   	getClosemonthCostDate   	() { return closemonthCostDate; }
    public int   	getClosemonthCostUserId   	() { return closemonthCostUserId; }
    public String   	getClosemonthCostPs   	() { return closemonthCostPs; }
    public int   	getClosemonthFeePrepay   	() { return closemonthFeePrepay; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClosemonthMonth   	(Date closemonthMonth) { this.closemonthMonth = closemonthMonth; }
    public void 	setClosemonthStatus   	(int closemonthStatus) { this.closemonthStatus = closemonthStatus; }
    public void 	setClosemonthUserId   	(int closemonthUserId) { this.closemonthUserId = closemonthUserId; }
    public void 	setClosemonthPs   	(String closemonthPs) { this.closemonthPs = closemonthPs; }
    public void 	setClosemonthFeesNum   	(int closemonthFeesNum) { this.closemonthFeesNum = closemonthFeesNum; }
    public void 	setClosemonthFeesNotNum   	(int closemonthFeesNotNum) { this.closemonthFeesNotNum = closemonthFeesNotNum; }
    public void 	setClosemonthFeestatus   	(int closemonthFeestatus) { this.closemonthFeestatus = closemonthFeestatus; }
    public void 	setClosemonthFeeDate   	(Date closemonthFeeDate) { this.closemonthFeeDate = closemonthFeeDate; }
    public void 	setClosemonthFeeUserId   	(int closemonthFeeUserId) { this.closemonthFeeUserId = closemonthFeeUserId; }
    public void 	setClosemonthFeePs   	(String closemonthFeePs) { this.closemonthFeePs = closemonthFeePs; }
    public void 	setClosemonthIncomestatus   	(int closemonthIncomestatus) { this.closemonthIncomestatus = closemonthIncomestatus; }
    public void 	setClosemonthIncomeNum   	(int closemonthIncomeNum) { this.closemonthIncomeNum = closemonthIncomeNum; }
    public void 	setClosemonthIncomeNotNum   	(int closemonthIncomeNotNum) { this.closemonthIncomeNotNum = closemonthIncomeNotNum; }
    public void 	setClosemonthIncomeDate   	(Date closemonthIncomeDate) { this.closemonthIncomeDate = closemonthIncomeDate; }
    public void 	setClosemonthIncomeUserId   	(int closemonthIncomeUserId) { this.closemonthIncomeUserId = closemonthIncomeUserId; }
    public void 	setClosemonthIncomePs   	(String closemonthIncomePs) { this.closemonthIncomePs = closemonthIncomePs; }
    public void 	setClosemonthSalarystatus   	(int closemonthSalarystatus) { this.closemonthSalarystatus = closemonthSalarystatus; }
    public void 	setClosemonthSalaryNum   	(int closemonthSalaryNum) { this.closemonthSalaryNum = closemonthSalaryNum; }
    public void 	setClosemonthSalaryNotNum   	(int closemonthSalaryNotNum) { this.closemonthSalaryNotNum = closemonthSalaryNotNum; }
    public void 	setClosemonthSalaryDate   	(Date closemonthSalaryDate) { this.closemonthSalaryDate = closemonthSalaryDate; }
    public void 	setClosemonthSalaryUserId   	(int closemonthSalaryUserId) { this.closemonthSalaryUserId = closemonthSalaryUserId; }
    public void 	setClosemonthSalaryPs   	(String closemonthSalaryPs) { this.closemonthSalaryPs = closemonthSalaryPs; }
    public void 	setClosemonthCoststatus   	(int closemonthCoststatus) { this.closemonthCoststatus = closemonthCoststatus; }
    public void 	setClosemonthCostNum   	(int closemonthCostNum) { this.closemonthCostNum = closemonthCostNum; }
    public void 	setClosemonthCostNotNum   	(int closemonthCostNotNum) { this.closemonthCostNotNum = closemonthCostNotNum; }
    public void 	setClosemonthCostDate   	(Date closemonthCostDate) { this.closemonthCostDate = closemonthCostDate; }
    public void 	setClosemonthCostUserId   	(int closemonthCostUserId) { this.closemonthCostUserId = closemonthCostUserId; }
    public void 	setClosemonthCostPs   	(String closemonthCostPs) { this.closemonthCostPs = closemonthCostPs; }
    public void 	setClosemonthFeePrepay   	(int closemonthFeePrepay) { this.closemonthFeePrepay = closemonthFeePrepay; }
}
