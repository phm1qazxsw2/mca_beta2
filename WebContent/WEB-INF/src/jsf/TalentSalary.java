package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class TalentSalary
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	talentSalaryMonth;
    private Date   	talentSalaryAccountdate;
    private int   	talentSalaryTalentId;
    private int   	talentSalaryTeacherId;
    private int   	talentSalaryCostbookId;
    private int   	talentSalaryCostId;
    private int   	talentSalaryMoney;
    private int   	talentSalaryLogId;


    public TalentSalary() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	talentSalaryMonth,
        Date	talentSalaryAccountdate,
        int	talentSalaryTalentId,
        int	talentSalaryTeacherId,
        int	talentSalaryCostbookId,
        int	talentSalaryCostId,
        int	talentSalaryMoney,
        int	talentSalaryLogId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.talentSalaryMonth 	 = talentSalaryMonth;
        this.talentSalaryAccountdate 	 = talentSalaryAccountdate;
        this.talentSalaryTalentId 	 = talentSalaryTalentId;
        this.talentSalaryTeacherId 	 = talentSalaryTeacherId;
        this.talentSalaryCostbookId 	 = talentSalaryCostbookId;
        this.talentSalaryCostId 	 = talentSalaryCostId;
        this.talentSalaryMoney 	 = talentSalaryMoney;
        this.talentSalaryLogId 	 = talentSalaryLogId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getTalentSalaryMonth   	() { return talentSalaryMonth; }
    public Date   	getTalentSalaryAccountdate   	() { return talentSalaryAccountdate; }
    public int   	getTalentSalaryTalentId   	() { return talentSalaryTalentId; }
    public int   	getTalentSalaryTeacherId   	() { return talentSalaryTeacherId; }
    public int   	getTalentSalaryCostbookId   	() { return talentSalaryCostbookId; }
    public int   	getTalentSalaryCostId   	() { return talentSalaryCostId; }
    public int   	getTalentSalaryMoney   	() { return talentSalaryMoney; }
    public int   	getTalentSalaryLogId   	() { return talentSalaryLogId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTalentSalaryMonth   	(Date talentSalaryMonth) { this.talentSalaryMonth = talentSalaryMonth; }
    public void 	setTalentSalaryAccountdate   	(Date talentSalaryAccountdate) { this.talentSalaryAccountdate = talentSalaryAccountdate; }
    public void 	setTalentSalaryTalentId   	(int talentSalaryTalentId) { this.talentSalaryTalentId = talentSalaryTalentId; }
    public void 	setTalentSalaryTeacherId   	(int talentSalaryTeacherId) { this.talentSalaryTeacherId = talentSalaryTeacherId; }
    public void 	setTalentSalaryCostbookId   	(int talentSalaryCostbookId) { this.talentSalaryCostbookId = talentSalaryCostbookId; }
    public void 	setTalentSalaryCostId   	(int talentSalaryCostId) { this.talentSalaryCostId = talentSalaryCostId; }
    public void 	setTalentSalaryMoney   	(int talentSalaryMoney) { this.talentSalaryMoney = talentSalaryMoney; }
    public void 	setTalentSalaryLogId   	(int talentSalaryLogId) { this.talentSalaryLogId = talentSalaryLogId; }
}
