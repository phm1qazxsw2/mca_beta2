package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class CfDiscount
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	cfDiscountClassesFeeId;
    private int   	cfDiscountNumber;
    private int   	cfDiscountStudentId;
    private int   	cfDiscountClassId;
    private int   	cfDiscountGroupId;
    private int   	cfDiscountLevelId;
    private int   	cfDiscountCmId;
    private Date   	cfDiscountMonth;
    private int   	cfDiscountFeenumberId;
    private int   	cfDiscountLogId;
    private String   	cfDiscountLogPs;
    private int   	cfDiscountVerify;
    private int   	cfDiscountVLogId;
    private String   	cfDiscountVPs;
    private Date   	cfDiscountVDate;
    private int   	cfDiscountStuatus;
    private int   	cfDiscountTypeId;
    private int   	cfDiscountContinue;


    public CfDiscount() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	cfDiscountClassesFeeId,
        int	cfDiscountNumber,
        int	cfDiscountStudentId,
        int	cfDiscountClassId,
        int	cfDiscountGroupId,
        int	cfDiscountLevelId,
        int	cfDiscountCmId,
        Date	cfDiscountMonth,
        int	cfDiscountFeenumberId,
        int	cfDiscountLogId,
        String	cfDiscountLogPs,
        int	cfDiscountVerify,
        int	cfDiscountVLogId,
        String	cfDiscountVPs,
        Date	cfDiscountVDate,
        int	cfDiscountStuatus,
        int	cfDiscountTypeId,
        int	cfDiscountContinue    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.cfDiscountClassesFeeId 	 = cfDiscountClassesFeeId;
        this.cfDiscountNumber 	 = cfDiscountNumber;
        this.cfDiscountStudentId 	 = cfDiscountStudentId;
        this.cfDiscountClassId 	 = cfDiscountClassId;
        this.cfDiscountGroupId 	 = cfDiscountGroupId;
        this.cfDiscountLevelId 	 = cfDiscountLevelId;
        this.cfDiscountCmId 	 = cfDiscountCmId;
        this.cfDiscountMonth 	 = cfDiscountMonth;
        this.cfDiscountFeenumberId 	 = cfDiscountFeenumberId;
        this.cfDiscountLogId 	 = cfDiscountLogId;
        this.cfDiscountLogPs 	 = cfDiscountLogPs;
        this.cfDiscountVerify 	 = cfDiscountVerify;
        this.cfDiscountVLogId 	 = cfDiscountVLogId;
        this.cfDiscountVPs 	 = cfDiscountVPs;
        this.cfDiscountVDate 	 = cfDiscountVDate;
        this.cfDiscountStuatus 	 = cfDiscountStuatus;
        this.cfDiscountTypeId 	 = cfDiscountTypeId;
        this.cfDiscountContinue 	 = cfDiscountContinue;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getCfDiscountClassesFeeId   	() { return cfDiscountClassesFeeId; }
    public int   	getCfDiscountNumber   	() { return cfDiscountNumber; }
    public int   	getCfDiscountStudentId   	() { return cfDiscountStudentId; }
    public int   	getCfDiscountClassId   	() { return cfDiscountClassId; }
    public int   	getCfDiscountGroupId   	() { return cfDiscountGroupId; }
    public int   	getCfDiscountLevelId   	() { return cfDiscountLevelId; }
    public int   	getCfDiscountCmId   	() { return cfDiscountCmId; }
    public Date   	getCfDiscountMonth   	() { return cfDiscountMonth; }
    public int   	getCfDiscountFeenumberId   	() { return cfDiscountFeenumberId; }
    public int   	getCfDiscountLogId   	() { return cfDiscountLogId; }
    public String   	getCfDiscountLogPs   	() { return cfDiscountLogPs; }
    public int   	getCfDiscountVerify   	() { return cfDiscountVerify; }
    public int   	getCfDiscountVLogId   	() { return cfDiscountVLogId; }
    public String   	getCfDiscountVPs   	() { return cfDiscountVPs; }
    public Date   	getCfDiscountVDate   	() { return cfDiscountVDate; }
    public int   	getCfDiscountStuatus   	() { return cfDiscountStuatus; }
    public int   	getCfDiscountTypeId   	() { return cfDiscountTypeId; }
    public int   	getCfDiscountContinue   	() { return cfDiscountContinue; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCfDiscountClassesFeeId   	(int cfDiscountClassesFeeId) { this.cfDiscountClassesFeeId = cfDiscountClassesFeeId; }
    public void 	setCfDiscountNumber   	(int cfDiscountNumber) { this.cfDiscountNumber = cfDiscountNumber; }
    public void 	setCfDiscountStudentId   	(int cfDiscountStudentId) { this.cfDiscountStudentId = cfDiscountStudentId; }
    public void 	setCfDiscountClassId   	(int cfDiscountClassId) { this.cfDiscountClassId = cfDiscountClassId; }
    public void 	setCfDiscountGroupId   	(int cfDiscountGroupId) { this.cfDiscountGroupId = cfDiscountGroupId; }
    public void 	setCfDiscountLevelId   	(int cfDiscountLevelId) { this.cfDiscountLevelId = cfDiscountLevelId; }
    public void 	setCfDiscountCmId   	(int cfDiscountCmId) { this.cfDiscountCmId = cfDiscountCmId; }
    public void 	setCfDiscountMonth   	(Date cfDiscountMonth) { this.cfDiscountMonth = cfDiscountMonth; }
    public void 	setCfDiscountFeenumberId   	(int cfDiscountFeenumberId) { this.cfDiscountFeenumberId = cfDiscountFeenumberId; }
    public void 	setCfDiscountLogId   	(int cfDiscountLogId) { this.cfDiscountLogId = cfDiscountLogId; }
    public void 	setCfDiscountLogPs   	(String cfDiscountLogPs) { this.cfDiscountLogPs = cfDiscountLogPs; }
    public void 	setCfDiscountVerify   	(int cfDiscountVerify) { this.cfDiscountVerify = cfDiscountVerify; }
    public void 	setCfDiscountVLogId   	(int cfDiscountVLogId) { this.cfDiscountVLogId = cfDiscountVLogId; }
    public void 	setCfDiscountVPs   	(String cfDiscountVPs) { this.cfDiscountVPs = cfDiscountVPs; }
    public void 	setCfDiscountVDate   	(Date cfDiscountVDate) { this.cfDiscountVDate = cfDiscountVDate; }
    public void 	setCfDiscountStuatus   	(int cfDiscountStuatus) { this.cfDiscountStuatus = cfDiscountStuatus; }
    public void 	setCfDiscountTypeId   	(int cfDiscountTypeId) { this.cfDiscountTypeId = cfDiscountTypeId; }
    public void 	setCfDiscountContinue   	(int cfDiscountContinue) { this.cfDiscountContinue = cfDiscountContinue; }
}
