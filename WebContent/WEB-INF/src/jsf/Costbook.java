package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Costbook
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	costbookOutIn;
    private int   	costbookCostcheckId;
    private Date   	costbookAccountDate;
    private int   	costbookCosttradeId;
    private String   	costbookName;
    private int   	costbookLogId;
    private String   	costbookLogPs;
    private int   	costbookAttachStatus;
    private int   	costbookAttachType;
    private int   	costbookTotalMoney;
    private int   	costbookTotalNum;
    private int   	costbookPaiedMoney;
    private int   	costbookPaiedStatus;
    private int   	costbookPaidNum;
    private int   	costbookVerifyStatus;
    private int   	costbookVerifyId;
    private Date   	costbookVerifyDate;
    private String   	costbookVerifyPs;
    private int   	costbookActive;
    private String   	costbookActivePs;


    public Costbook() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	costbookOutIn,
        int	costbookCostcheckId,
        Date	costbookAccountDate,
        int	costbookCosttradeId,
        String	costbookName,
        int	costbookLogId,
        String	costbookLogPs,
        int	costbookAttachStatus,
        int	costbookAttachType,
        int	costbookTotalMoney,
        int	costbookTotalNum,
        int	costbookPaiedMoney,
        int	costbookPaiedStatus,
        int	costbookPaidNum,
        int	costbookVerifyStatus,
        int	costbookVerifyId,
        Date	costbookVerifyDate,
        String	costbookVerifyPs,
        int	costbookActive,
        String	costbookActivePs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.costbookOutIn 	 = costbookOutIn;
        this.costbookCostcheckId 	 = costbookCostcheckId;
        this.costbookAccountDate 	 = costbookAccountDate;
        this.costbookCosttradeId 	 = costbookCosttradeId;
        this.costbookName 	 = costbookName;
        this.costbookLogId 	 = costbookLogId;
        this.costbookLogPs 	 = costbookLogPs;
        this.costbookAttachStatus 	 = costbookAttachStatus;
        this.costbookAttachType 	 = costbookAttachType;
        this.costbookTotalMoney 	 = costbookTotalMoney;
        this.costbookTotalNum 	 = costbookTotalNum;
        this.costbookPaiedMoney 	 = costbookPaiedMoney;
        this.costbookPaiedStatus 	 = costbookPaiedStatus;
        this.costbookPaidNum 	 = costbookPaidNum;
        this.costbookVerifyStatus 	 = costbookVerifyStatus;
        this.costbookVerifyId 	 = costbookVerifyId;
        this.costbookVerifyDate 	 = costbookVerifyDate;
        this.costbookVerifyPs 	 = costbookVerifyPs;
        this.costbookActive 	 = costbookActive;
        this.costbookActivePs 	 = costbookActivePs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getCostbookOutIn   	() { return costbookOutIn; }
    public int   	getCostbookCostcheckId   	() { return costbookCostcheckId; }
    public Date   	getCostbookAccountDate   	() { return costbookAccountDate; }
    public int   	getCostbookCosttradeId   	() { return costbookCosttradeId; }
    public String   	getCostbookName   	() { return costbookName; }
    public int   	getCostbookLogId   	() { return costbookLogId; }
    public String   	getCostbookLogPs   	() { return costbookLogPs; }
    public int   	getCostbookAttachStatus   	() { return costbookAttachStatus; }
    public int   	getCostbookAttachType   	() { return costbookAttachType; }
    public int   	getCostbookTotalMoney   	() { return costbookTotalMoney; }
    public int   	getCostbookTotalNum   	() { return costbookTotalNum; }
    public int   	getCostbookPaiedMoney   	() { return costbookPaiedMoney; }
    public int   	getCostbookPaiedStatus   	() { return costbookPaiedStatus; }
    public int   	getCostbookPaidNum   	() { return costbookPaidNum; }
    public int   	getCostbookVerifyStatus   	() { return costbookVerifyStatus; }
    public int   	getCostbookVerifyId   	() { return costbookVerifyId; }
    public Date   	getCostbookVerifyDate   	() { return costbookVerifyDate; }
    public String   	getCostbookVerifyPs   	() { return costbookVerifyPs; }
    public int   	getCostbookActive   	() { return costbookActive; }
    public String   	getCostbookActivePs   	() { return costbookActivePs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCostbookOutIn   	(int costbookOutIn) { this.costbookOutIn = costbookOutIn; }
    public void 	setCostbookCostcheckId   	(int costbookCostcheckId) { this.costbookCostcheckId = costbookCostcheckId; }
    public void 	setCostbookAccountDate   	(Date costbookAccountDate) { this.costbookAccountDate = costbookAccountDate; }
    public void 	setCostbookCosttradeId   	(int costbookCosttradeId) { this.costbookCosttradeId = costbookCosttradeId; }
    public void 	setCostbookName   	(String costbookName) { this.costbookName = costbookName; }
    public void 	setCostbookLogId   	(int costbookLogId) { this.costbookLogId = costbookLogId; }
    public void 	setCostbookLogPs   	(String costbookLogPs) { this.costbookLogPs = costbookLogPs; }
    public void 	setCostbookAttachStatus   	(int costbookAttachStatus) { this.costbookAttachStatus = costbookAttachStatus; }
    public void 	setCostbookAttachType   	(int costbookAttachType) { this.costbookAttachType = costbookAttachType; }
    public void 	setCostbookTotalMoney   	(int costbookTotalMoney) { this.costbookTotalMoney = costbookTotalMoney; }
    public void 	setCostbookTotalNum   	(int costbookTotalNum) { this.costbookTotalNum = costbookTotalNum; }
    public void 	setCostbookPaiedMoney   	(int costbookPaiedMoney) { this.costbookPaiedMoney = costbookPaiedMoney; }
    public void 	setCostbookPaiedStatus   	(int costbookPaiedStatus) { this.costbookPaiedStatus = costbookPaiedStatus; }
    public void 	setCostbookPaidNum   	(int costbookPaidNum) { this.costbookPaidNum = costbookPaidNum; }
    public void 	setCostbookVerifyStatus   	(int costbookVerifyStatus) { this.costbookVerifyStatus = costbookVerifyStatus; }
    public void 	setCostbookVerifyId   	(int costbookVerifyId) { this.costbookVerifyId = costbookVerifyId; }
    public void 	setCostbookVerifyDate   	(Date costbookVerifyDate) { this.costbookVerifyDate = costbookVerifyDate; }
    public void 	setCostbookVerifyPs   	(String costbookVerifyPs) { this.costbookVerifyPs = costbookVerifyPs; }
    public void 	setCostbookActive   	(int costbookActive) { this.costbookActive = costbookActive; }
    public void 	setCostbookActivePs   	(String costbookActivePs) { this.costbookActivePs = costbookActivePs; }
}
