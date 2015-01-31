package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Tadent
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	tadentTalentId;
    private int   	tadentStudentId;
    private int   	tadentActive;
    private Date   	tadentComeDate;
    private String   	tadentPs;
    private int   	tadentTime;
    private int   	tadentActualTime;
    private int   	talentLog;
    private int   	talentLogId;
    private Date   	talentLogDate;


    public Tadent() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	tadentTalentId,
        int	tadentStudentId,
        int	tadentActive,
        Date	tadentComeDate,
        String	tadentPs,
        int	tadentTime,
        int	tadentActualTime,
        int	talentLog,
        int	talentLogId,
        Date	talentLogDate    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.tadentTalentId 	 = tadentTalentId;
        this.tadentStudentId 	 = tadentStudentId;
        this.tadentActive 	 = tadentActive;
        this.tadentComeDate 	 = tadentComeDate;
        this.tadentPs 	 = tadentPs;
        this.tadentTime 	 = tadentTime;
        this.tadentActualTime 	 = tadentActualTime;
        this.talentLog 	 = talentLog;
        this.talentLogId 	 = talentLogId;
        this.talentLogDate 	 = talentLogDate;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTadentTalentId   	() { return tadentTalentId; }
    public int   	getTadentStudentId   	() { return tadentStudentId; }
    public int   	getTadentActive   	() { return tadentActive; }
    public Date   	getTadentComeDate   	() { return tadentComeDate; }
    public String   	getTadentPs   	() { return tadentPs; }
    public int   	getTadentTime   	() { return tadentTime; }
    public int   	getTadentActualTime   	() { return tadentActualTime; }
    public int   	getTalentLog   	() { return talentLog; }
    public int   	getTalentLogId   	() { return talentLogId; }
    public Date   	getTalentLogDate   	() { return talentLogDate; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTadentTalentId   	(int tadentTalentId) { this.tadentTalentId = tadentTalentId; }
    public void 	setTadentStudentId   	(int tadentStudentId) { this.tadentStudentId = tadentStudentId; }
    public void 	setTadentActive   	(int tadentActive) { this.tadentActive = tadentActive; }
    public void 	setTadentComeDate   	(Date tadentComeDate) { this.tadentComeDate = tadentComeDate; }
    public void 	setTadentPs   	(String tadentPs) { this.tadentPs = tadentPs; }
    public void 	setTadentTime   	(int tadentTime) { this.tadentTime = tadentTime; }
    public void 	setTadentActualTime   	(int tadentActualTime) { this.tadentActualTime = tadentActualTime; }
    public void 	setTalentLog   	(int talentLog) { this.talentLog = talentLog; }
    public void 	setTalentLogId   	(int talentLogId) { this.talentLogId = talentLogId; }
    public void 	setTalentLogDate   	(Date talentLogDate) { this.talentLogDate = talentLogDate; }
}
