package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class ClassesFee
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	classesFeeCMId;
    private int   	classesFeeStudentId;
    private int   	classesFeeStuClassId;
    private int   	classesFeeStuGroupId;
    private int   	classesFeeStuLevelId;
    private Date   	classesFeeMonth;
    private int   	classesFeeFeenumberId;
    private int   	classesFeeShouldNumber;
    private int   	classesFeeTotalDiscount;
    private int   	classesFeeLogId;
    private String   	classesFeeLogPs;
    private int   	classesFeeVNeed;
    private int   	classesFeeVUserId;
    private Date   	classesFeeVDate;
    private String   	classesFeeVPs;
    private int   	classesFeeStatus;
    private int   	classesFeeChargeId;


    public ClassesFee() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	classesFeeCMId,
        int	classesFeeStudentId,
        int	classesFeeStuClassId,
        int	classesFeeStuGroupId,
        int	classesFeeStuLevelId,
        Date	classesFeeMonth,
        int	classesFeeFeenumberId,
        int	classesFeeShouldNumber,
        int	classesFeeTotalDiscount,
        int	classesFeeLogId,
        String	classesFeeLogPs,
        int	classesFeeVNeed,
        int	classesFeeVUserId,
        Date	classesFeeVDate,
        String	classesFeeVPs,
        int	classesFeeStatus,
        int	classesFeeChargeId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.classesFeeCMId 	 = classesFeeCMId;
        this.classesFeeStudentId 	 = classesFeeStudentId;
        this.classesFeeStuClassId 	 = classesFeeStuClassId;
        this.classesFeeStuGroupId 	 = classesFeeStuGroupId;
        this.classesFeeStuLevelId 	 = classesFeeStuLevelId;
        this.classesFeeMonth 	 = classesFeeMonth;
        this.classesFeeFeenumberId 	 = classesFeeFeenumberId;
        this.classesFeeShouldNumber 	 = classesFeeShouldNumber;
        this.classesFeeTotalDiscount 	 = classesFeeTotalDiscount;
        this.classesFeeLogId 	 = classesFeeLogId;
        this.classesFeeLogPs 	 = classesFeeLogPs;
        this.classesFeeVNeed 	 = classesFeeVNeed;
        this.classesFeeVUserId 	 = classesFeeVUserId;
        this.classesFeeVDate 	 = classesFeeVDate;
        this.classesFeeVPs 	 = classesFeeVPs;
        this.classesFeeStatus 	 = classesFeeStatus;
        this.classesFeeChargeId 	 = classesFeeChargeId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getClassesFeeCMId   	() { return classesFeeCMId; }
    public int   	getClassesFeeStudentId   	() { return classesFeeStudentId; }
    public int   	getClassesFeeStuClassId   	() { return classesFeeStuClassId; }
    public int   	getClassesFeeStuGroupId   	() { return classesFeeStuGroupId; }
    public int   	getClassesFeeStuLevelId   	() { return classesFeeStuLevelId; }
    public Date   	getClassesFeeMonth   	() { return classesFeeMonth; }
    public int   	getClassesFeeFeenumberId   	() { return classesFeeFeenumberId; }
    public int   	getClassesFeeShouldNumber   	() { return classesFeeShouldNumber; }
    public int   	getClassesFeeTotalDiscount   	() { return classesFeeTotalDiscount; }
    public int   	getClassesFeeLogId   	() { return classesFeeLogId; }
    public String   	getClassesFeeLogPs   	() { return classesFeeLogPs; }
    public int   	getClassesFeeVNeed   	() { return classesFeeVNeed; }
    public int   	getClassesFeeVUserId   	() { return classesFeeVUserId; }
    public Date   	getClassesFeeVDate   	() { return classesFeeVDate; }
    public String   	getClassesFeeVPs   	() { return classesFeeVPs; }
    public int   	getClassesFeeStatus   	() { return classesFeeStatus; }
    public int   	getClassesFeeChargeId   	() { return classesFeeChargeId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClassesFeeCMId   	(int classesFeeCMId) { this.classesFeeCMId = classesFeeCMId; }
    public void 	setClassesFeeStudentId   	(int classesFeeStudentId) { this.classesFeeStudentId = classesFeeStudentId; }
    public void 	setClassesFeeStuClassId   	(int classesFeeStuClassId) { this.classesFeeStuClassId = classesFeeStuClassId; }
    public void 	setClassesFeeStuGroupId   	(int classesFeeStuGroupId) { this.classesFeeStuGroupId = classesFeeStuGroupId; }
    public void 	setClassesFeeStuLevelId   	(int classesFeeStuLevelId) { this.classesFeeStuLevelId = classesFeeStuLevelId; }
    public void 	setClassesFeeMonth   	(Date classesFeeMonth) { this.classesFeeMonth = classesFeeMonth; }
    public void 	setClassesFeeFeenumberId   	(int classesFeeFeenumberId) { this.classesFeeFeenumberId = classesFeeFeenumberId; }
    public void 	setClassesFeeShouldNumber   	(int classesFeeShouldNumber) { this.classesFeeShouldNumber = classesFeeShouldNumber; }
    public void 	setClassesFeeTotalDiscount   	(int classesFeeTotalDiscount) { this.classesFeeTotalDiscount = classesFeeTotalDiscount; }
    public void 	setClassesFeeLogId   	(int classesFeeLogId) { this.classesFeeLogId = classesFeeLogId; }
    public void 	setClassesFeeLogPs   	(String classesFeeLogPs) { this.classesFeeLogPs = classesFeeLogPs; }
    public void 	setClassesFeeVNeed   	(int classesFeeVNeed) { this.classesFeeVNeed = classesFeeVNeed; }
    public void 	setClassesFeeVUserId   	(int classesFeeVUserId) { this.classesFeeVUserId = classesFeeVUserId; }
    public void 	setClassesFeeVDate   	(Date classesFeeVDate) { this.classesFeeVDate = classesFeeVDate; }
    public void 	setClassesFeeVPs   	(String classesFeeVPs) { this.classesFeeVPs = classesFeeVPs; }
    public void 	setClassesFeeStatus   	(int classesFeeStatus) { this.classesFeeStatus = classesFeeStatus; }
    public void 	setClassesFeeChargeId   	(int classesFeeChargeId) { this.classesFeeChargeId = classesFeeChargeId; }
}
