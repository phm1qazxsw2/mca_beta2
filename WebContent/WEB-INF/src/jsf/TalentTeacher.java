package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class TalentTeacher
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	talentTeacherTalentId;
    private int   	talentTeacherTeacherId;
    private int   	talentUnitMoney;
    private int   	talentTeacherActive;
    private int   	talentTeacherLogId;


    public TalentTeacher() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	talentTeacherTalentId,
        int	talentTeacherTeacherId,
        int	talentUnitMoney,
        int	talentTeacherActive,
        int	talentTeacherLogId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.talentTeacherTalentId 	 = talentTeacherTalentId;
        this.talentTeacherTeacherId 	 = talentTeacherTeacherId;
        this.talentUnitMoney 	 = talentUnitMoney;
        this.talentTeacherActive 	 = talentTeacherActive;
        this.talentTeacherLogId 	 = talentTeacherLogId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getTalentTeacherTalentId   	() { return talentTeacherTalentId; }
    public int   	getTalentTeacherTeacherId   	() { return talentTeacherTeacherId; }
    public int   	getTalentUnitMoney   	() { return talentUnitMoney; }
    public int   	getTalentTeacherActive   	() { return talentTeacherActive; }
    public int   	getTalentTeacherLogId   	() { return talentTeacherLogId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setTalentTeacherTalentId   	(int talentTeacherTalentId) { this.talentTeacherTalentId = talentTeacherTalentId; }
    public void 	setTalentTeacherTeacherId   	(int talentTeacherTeacherId) { this.talentTeacherTeacherId = talentTeacherTeacherId; }
    public void 	setTalentUnitMoney   	(int talentUnitMoney) { this.talentUnitMoney = talentUnitMoney; }
    public void 	setTalentTeacherActive   	(int talentTeacherActive) { this.talentTeacherActive = talentTeacherActive; }
    public void 	setTalentTeacherLogId   	(int talentTeacherLogId) { this.talentTeacherLogId = talentTeacherLogId; }
}
