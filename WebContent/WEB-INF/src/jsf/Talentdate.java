package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Talentdate
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	talentdateTalentId;
    private Date   	talentdateStartDate;
    private Date   	talentdateEndDate;
    private String   	talentdatePlan;
    private String   	talentdatePicFile;
    private int   	talentdateStatus;
    private int   	talentdateNotice;
    private int   	talentdatePresent;
    private int   	talentdateUserId;
    private String   	talentdatePrepare;


    public Talentdate() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	talentdateTalentId,
        Date	talentdateStartDate,
        Date	talentdateEndDate,
        String	talentdatePlan,
        String	talentdatePicFile,
        int	talentdateStatus,
        int	talentdateNotice,
        int	talentdatePresent,
        int	talentdateUserId,
        String	talentdatePrepare    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.talentdateTalentId 	 = talentdateTalentId;
        this.talentdateStartDate 	 = talentdateStartDate;
        this.talentdateEndDate 	 = talentdateEndDate;
        this.talentdatePlan 	 = talentdatePlan;
        this.talentdatePicFile 	 = talentdatePicFile;
        this.talentdateStatus 	 = talentdateStatus;
        this.talentdateNotice 	 = talentdateNotice;
        this.talentdatePresent 	 = talentdatePresent;
        this.talentdateUserId 	 = talentdateUserId;
        this.talentdatePrepare 	 = talentdatePrepare;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTalentdateTalentId   	() { return talentdateTalentId; }
    public Date   	getTalentdateStartDate   	() { return talentdateStartDate; }
    public Date   	getTalentdateEndDate   	() { return talentdateEndDate; }
    public String   	getTalentdatePlan   	() { return talentdatePlan; }
    public String   	getTalentdatePicFile   	() { return talentdatePicFile; }
    public int   	getTalentdateStatus   	() { return talentdateStatus; }
    public int   	getTalentdateNotice   	() { return talentdateNotice; }
    public int   	getTalentdatePresent   	() { return talentdatePresent; }
    public int   	getTalentdateUserId   	() { return talentdateUserId; }
    public String   	getTalentdatePrepare   	() { return talentdatePrepare; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTalentdateTalentId   	(int talentdateTalentId) { this.talentdateTalentId = talentdateTalentId; }
    public void 	setTalentdateStartDate   	(Date talentdateStartDate) { this.talentdateStartDate = talentdateStartDate; }
    public void 	setTalentdateEndDate   	(Date talentdateEndDate) { this.talentdateEndDate = talentdateEndDate; }
    public void 	setTalentdatePlan   	(String talentdatePlan) { this.talentdatePlan = talentdatePlan; }
    public void 	setTalentdatePicFile   	(String talentdatePicFile) { this.talentdatePicFile = talentdatePicFile; }
    public void 	setTalentdateStatus   	(int talentdateStatus) { this.talentdateStatus = talentdateStatus; }
    public void 	setTalentdateNotice   	(int talentdateNotice) { this.talentdateNotice = talentdateNotice; }
    public void 	setTalentdatePresent   	(int talentdatePresent) { this.talentdatePresent = talentdatePresent; }
    public void 	setTalentdateUserId   	(int talentdateUserId) { this.talentdateUserId = talentdateUserId; }
    public void 	setTalentdatePrepare   	(String talentdatePrepare) { this.talentdatePrepare = talentdatePrepare; }
}
