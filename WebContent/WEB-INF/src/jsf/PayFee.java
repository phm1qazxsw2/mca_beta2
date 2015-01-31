package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class PayFee
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	payFeeFeenumberId;
    private int   	payFeeMoneyNumber;
    private Date   	payFeeLogDate;
    private Date   	payFeeLogPayDate;
    private int   	payFeeManPCType;
    private int   	payFeeSourceCategory;
    private int   	payFeeSourceId;
    private String   	payFeeSourceFileName;
    private int   	payFeeStatus;
    private int   	payFeeLogId;
    private String   	payFeeLogPs;
    private int   	payFeeVId;
    private String   	payFeeVPs;
    private int   	payFeeMessageStatus;
    private int   	payFeeAccountType;
    private int   	payFeeAccountId;
    private int   	payFeeVstatus;


    public PayFee() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	payFeeFeenumberId,
        int	payFeeMoneyNumber,
        Date	payFeeLogDate,
        Date	payFeeLogPayDate,
        int	payFeeManPCType,
        int	payFeeSourceCategory,
        int	payFeeSourceId,
        String	payFeeSourceFileName,
        int	payFeeStatus,
        int	payFeeLogId,
        String	payFeeLogPs,
        int	payFeeVId,
        String	payFeeVPs,
        int	payFeeMessageStatus,
        int	payFeeAccountType,
        int	payFeeAccountId,
        int	payFeeVstatus    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.payFeeFeenumberId 	 = payFeeFeenumberId;
        this.payFeeMoneyNumber 	 = payFeeMoneyNumber;
        this.payFeeLogDate 	 = payFeeLogDate;
        this.payFeeLogPayDate 	 = payFeeLogPayDate;
        this.payFeeManPCType 	 = payFeeManPCType;
        this.payFeeSourceCategory 	 = payFeeSourceCategory;
        this.payFeeSourceId 	 = payFeeSourceId;
        this.payFeeSourceFileName 	 = payFeeSourceFileName;
        this.payFeeStatus 	 = payFeeStatus;
        this.payFeeLogId 	 = payFeeLogId;
        this.payFeeLogPs 	 = payFeeLogPs;
        this.payFeeVId 	 = payFeeVId;
        this.payFeeVPs 	 = payFeeVPs;
        this.payFeeMessageStatus 	 = payFeeMessageStatus;
        this.payFeeAccountType 	 = payFeeAccountType;
        this.payFeeAccountId 	 = payFeeAccountId;
        this.payFeeVstatus 	 = payFeeVstatus;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getPayFeeFeenumberId   	() { return payFeeFeenumberId; }
    public int   	getPayFeeMoneyNumber   	() { return payFeeMoneyNumber; }
    public Date   	getPayFeeLogDate   	() { return payFeeLogDate; }
    public Date   	getPayFeeLogPayDate   	() { return payFeeLogPayDate; }
    public int   	getPayFeeManPCType   	() { return payFeeManPCType; }
    public int   	getPayFeeSourceCategory   	() { return payFeeSourceCategory; }
    public int   	getPayFeeSourceId   	() { return payFeeSourceId; }
    public String   	getPayFeeSourceFileName   	() { return payFeeSourceFileName; }
    public int   	getPayFeeStatus   	() { return payFeeStatus; }
    public int   	getPayFeeLogId   	() { return payFeeLogId; }
    public String   	getPayFeeLogPs   	() { return payFeeLogPs; }
    public int   	getPayFeeVId   	() { return payFeeVId; }
    public String   	getPayFeeVPs   	() { return payFeeVPs; }
    public int   	getPayFeeMessageStatus   	() { return payFeeMessageStatus; }
    public int   	getPayFeeAccountType   	() { return payFeeAccountType; }
    public int   	getPayFeeAccountId   	() { return payFeeAccountId; }
    public int   	getPayFeeVstatus   	() { return payFeeVstatus; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setPayFeeFeenumberId   	(int payFeeFeenumberId) { this.payFeeFeenumberId = payFeeFeenumberId; }
    public void 	setPayFeeMoneyNumber   	(int payFeeMoneyNumber) { this.payFeeMoneyNumber = payFeeMoneyNumber; }
    public void 	setPayFeeLogDate   	(Date payFeeLogDate) { this.payFeeLogDate = payFeeLogDate; }
    public void 	setPayFeeLogPayDate   	(Date payFeeLogPayDate) { this.payFeeLogPayDate = payFeeLogPayDate; }
    public void 	setPayFeeManPCType   	(int payFeeManPCType) { this.payFeeManPCType = payFeeManPCType; }
    public void 	setPayFeeSourceCategory   	(int payFeeSourceCategory) { this.payFeeSourceCategory = payFeeSourceCategory; }
    public void 	setPayFeeSourceId   	(int payFeeSourceId) { this.payFeeSourceId = payFeeSourceId; }
    public void 	setPayFeeSourceFileName   	(String payFeeSourceFileName) { this.payFeeSourceFileName = payFeeSourceFileName; }
    public void 	setPayFeeStatus   	(int payFeeStatus) { this.payFeeStatus = payFeeStatus; }
    public void 	setPayFeeLogId   	(int payFeeLogId) { this.payFeeLogId = payFeeLogId; }
    public void 	setPayFeeLogPs   	(String payFeeLogPs) { this.payFeeLogPs = payFeeLogPs; }
    public void 	setPayFeeVId   	(int payFeeVId) { this.payFeeVId = payFeeVId; }
    public void 	setPayFeeVPs   	(String payFeeVPs) { this.payFeeVPs = payFeeVPs; }
    public void 	setPayFeeMessageStatus   	(int payFeeMessageStatus) { this.payFeeMessageStatus = payFeeMessageStatus; }
    public void 	setPayFeeAccountType   	(int payFeeAccountType) { this.payFeeAccountType = payFeeAccountType; }
    public void 	setPayFeeAccountId   	(int payFeeAccountId) { this.payFeeAccountId = payFeeAccountId; }
    public void 	setPayFeeVstatus   	(int payFeeVstatus) { this.payFeeVstatus = payFeeVstatus; }
}
