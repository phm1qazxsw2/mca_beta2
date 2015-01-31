package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Talent
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	talentName;
    private String   	talentEnName;
    private int   	talentActive;
    private int   	talentStatus;
    private int   	talentTeacherId;
    private String   	talentPs;
    private int   	talentTimes;
    private int   	talentActualTimes;
    private int   	talentNeedPeople;
    private int   	talentActualPeople;
    private String   	talentQuality;
    private Date   	talentStartDate;
    private Date   	talentEndDate;
    private int   	talentFee;
    private String   	talentFeeExplain;
    private int   	talentPlace;
    private int   	talentFinanceType;
    private int   	talentFinanceBigItem;
    private int   	talentFinanceSmallItem;
    private int   	talentSalaryTypeId;


    public Talent() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	talentName,
        String	talentEnName,
        int	talentActive,
        int	talentStatus,
        int	talentTeacherId,
        String	talentPs,
        int	talentTimes,
        int	talentActualTimes,
        int	talentNeedPeople,
        int	talentActualPeople,
        String	talentQuality,
        Date	talentStartDate,
        Date	talentEndDate,
        int	talentFee,
        String	talentFeeExplain,
        int	talentPlace,
        int	talentFinanceType,
        int	talentFinanceBigItem,
        int	talentFinanceSmallItem,
        int	talentSalaryTypeId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.talentName 	 = talentName;
        this.talentEnName 	 = talentEnName;
        this.talentActive 	 = talentActive;
        this.talentStatus 	 = talentStatus;
        this.talentTeacherId 	 = talentTeacherId;
        this.talentPs 	 = talentPs;
        this.talentTimes 	 = talentTimes;
        this.talentActualTimes 	 = talentActualTimes;
        this.talentNeedPeople 	 = talentNeedPeople;
        this.talentActualPeople 	 = talentActualPeople;
        this.talentQuality 	 = talentQuality;
        this.talentStartDate 	 = talentStartDate;
        this.talentEndDate 	 = talentEndDate;
        this.talentFee 	 = talentFee;
        this.talentFeeExplain 	 = talentFeeExplain;
        this.talentPlace 	 = talentPlace;
        this.talentFinanceType 	 = talentFinanceType;
        this.talentFinanceBigItem 	 = talentFinanceBigItem;
        this.talentFinanceSmallItem 	 = talentFinanceSmallItem;
        this.talentSalaryTypeId 	 = talentSalaryTypeId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getTalentName   	() { return talentName; }
    public String   	getTalentEnName   	() { return talentEnName; }
    public int   	getTalentActive   	() { return talentActive; }
    public int   	getTalentStatus   	() { return talentStatus; }
    public int   	getTalentTeacherId   	() { return talentTeacherId; }
    public String   	getTalentPs   	() { return talentPs; }
    public int   	getTalentTimes   	() { return talentTimes; }
    public int   	getTalentActualTimes   	() { return talentActualTimes; }
    public int   	getTalentNeedPeople   	() { return talentNeedPeople; }
    public int   	getTalentActualPeople   	() { return talentActualPeople; }
    public String   	getTalentQuality   	() { return talentQuality; }
    public Date   	getTalentStartDate   	() { return talentStartDate; }
    public Date   	getTalentEndDate   	() { return talentEndDate; }
    public int   	getTalentFee   	() { return talentFee; }
    public String   	getTalentFeeExplain   	() { return talentFeeExplain; }
    public int   	getTalentPlace   	() { return talentPlace; }
    public int   	getTalentFinanceType   	() { return talentFinanceType; }
    public int   	getTalentFinanceBigItem   	() { return talentFinanceBigItem; }
    public int   	getTalentFinanceSmallItem   	() { return talentFinanceSmallItem; }
    public int   	getTalentSalaryTypeId   	() { return talentSalaryTypeId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTalentName   	(String talentName) { this.talentName = talentName; }
    public void 	setTalentEnName   	(String talentEnName) { this.talentEnName = talentEnName; }
    public void 	setTalentActive   	(int talentActive) { this.talentActive = talentActive; }
    public void 	setTalentStatus   	(int talentStatus) { this.talentStatus = talentStatus; }
    public void 	setTalentTeacherId   	(int talentTeacherId) { this.talentTeacherId = talentTeacherId; }
    public void 	setTalentPs   	(String talentPs) { this.talentPs = talentPs; }
    public void 	setTalentTimes   	(int talentTimes) { this.talentTimes = talentTimes; }
    public void 	setTalentActualTimes   	(int talentActualTimes) { this.talentActualTimes = talentActualTimes; }
    public void 	setTalentNeedPeople   	(int talentNeedPeople) { this.talentNeedPeople = talentNeedPeople; }
    public void 	setTalentActualPeople   	(int talentActualPeople) { this.talentActualPeople = talentActualPeople; }
    public void 	setTalentQuality   	(String talentQuality) { this.talentQuality = talentQuality; }
    public void 	setTalentStartDate   	(Date talentStartDate) { this.talentStartDate = talentStartDate; }
    public void 	setTalentEndDate   	(Date talentEndDate) { this.talentEndDate = talentEndDate; }
    public void 	setTalentFee   	(int talentFee) { this.talentFee = talentFee; }
    public void 	setTalentFeeExplain   	(String talentFeeExplain) { this.talentFeeExplain = talentFeeExplain; }
    public void 	setTalentPlace   	(int talentPlace) { this.talentPlace = talentPlace; }
    public void 	setTalentFinanceType   	(int talentFinanceType) { this.talentFinanceType = talentFinanceType; }
    public void 	setTalentFinanceBigItem   	(int talentFinanceBigItem) { this.talentFinanceBigItem = talentFinanceBigItem; }
    public void 	setTalentFinanceSmallItem   	(int talentFinanceSmallItem) { this.talentFinanceSmallItem = talentFinanceSmallItem; }
    public void 	setTalentSalaryTypeId   	(int talentSalaryTypeId) { this.talentSalaryTypeId = talentSalaryTypeId; }
}
