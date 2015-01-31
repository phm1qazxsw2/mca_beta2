package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class ClassesMoney
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	classesMoneyName;
    private String   	classesMoneyFullName;
    private int   	classesMoneyActive;
    private String   	classesMoneyPs;
    private int   	classesMoneyNumber;
    private int   	classesMoneyIncomeItem;
    private int   	classesMoneyContinue;
    private int   	classesMoneyContinueActive;
    private Date   	classesMoneyContinueDate;
    private int   	classesMoneyCategory;
    private int   	classesMoneyNewFeenumber;
    private int   	classesMoneyNewFeenumberCMId;


    public ClassesMoney() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	classesMoneyName,
        String	classesMoneyFullName,
        int	classesMoneyActive,
        String	classesMoneyPs,
        int	classesMoneyNumber,
        int	classesMoneyIncomeItem,
        int	classesMoneyContinue,
        int	classesMoneyContinueActive,
        Date	classesMoneyContinueDate,
        int	classesMoneyCategory,
        int	classesMoneyNewFeenumber,
        int	classesMoneyNewFeenumberCMId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.classesMoneyName 	 = classesMoneyName;
        this.classesMoneyFullName 	 = classesMoneyFullName;
        this.classesMoneyActive 	 = classesMoneyActive;
        this.classesMoneyPs 	 = classesMoneyPs;
        this.classesMoneyNumber 	 = classesMoneyNumber;
        this.classesMoneyIncomeItem 	 = classesMoneyIncomeItem;
        this.classesMoneyContinue 	 = classesMoneyContinue;
        this.classesMoneyContinueActive 	 = classesMoneyContinueActive;
        this.classesMoneyContinueDate 	 = classesMoneyContinueDate;
        this.classesMoneyCategory 	 = classesMoneyCategory;
        this.classesMoneyNewFeenumber 	 = classesMoneyNewFeenumber;
        this.classesMoneyNewFeenumberCMId 	 = classesMoneyNewFeenumberCMId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getClassesMoneyName   	() { return classesMoneyName; }
    public String   	getClassesMoneyFullName   	() { return classesMoneyFullName; }
    public int   	getClassesMoneyActive   	() { return classesMoneyActive; }
    public String   	getClassesMoneyPs   	() { return classesMoneyPs; }
    public int   	getClassesMoneyNumber   	() { return classesMoneyNumber; }
    public int   	getClassesMoneyIncomeItem   	() { return classesMoneyIncomeItem; }
    public int   	getClassesMoneyContinue   	() { return classesMoneyContinue; }
    public int   	getClassesMoneyContinueActive   	() { return classesMoneyContinueActive; }
    public Date   	getClassesMoneyContinueDate   	() { return classesMoneyContinueDate; }
    public int   	getClassesMoneyCategory   	() { return classesMoneyCategory; }
    public int   	getClassesMoneyNewFeenumber   	() { return classesMoneyNewFeenumber; }
    public int   	getClassesMoneyNewFeenumberCMId   	() { return classesMoneyNewFeenumberCMId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClassesMoneyName   	(String classesMoneyName) { this.classesMoneyName = classesMoneyName; }
    public void 	setClassesMoneyFullName   	(String classesMoneyFullName) { this.classesMoneyFullName = classesMoneyFullName; }
    public void 	setClassesMoneyActive   	(int classesMoneyActive) { this.classesMoneyActive = classesMoneyActive; }
    public void 	setClassesMoneyPs   	(String classesMoneyPs) { this.classesMoneyPs = classesMoneyPs; }
    public void 	setClassesMoneyNumber   	(int classesMoneyNumber) { this.classesMoneyNumber = classesMoneyNumber; }
    public void 	setClassesMoneyIncomeItem   	(int classesMoneyIncomeItem) { this.classesMoneyIncomeItem = classesMoneyIncomeItem; }
    public void 	setClassesMoneyContinue   	(int classesMoneyContinue) { this.classesMoneyContinue = classesMoneyContinue; }
    public void 	setClassesMoneyContinueActive   	(int classesMoneyContinueActive) { this.classesMoneyContinueActive = classesMoneyContinueActive; }
    public void 	setClassesMoneyContinueDate   	(Date classesMoneyContinueDate) { this.classesMoneyContinueDate = classesMoneyContinueDate; }
    public void 	setClassesMoneyCategory   	(int classesMoneyCategory) { this.classesMoneyCategory = classesMoneyCategory; }
    public void 	setClassesMoneyNewFeenumber   	(int classesMoneyNewFeenumber) { this.classesMoneyNewFeenumber = classesMoneyNewFeenumber; }
    public void 	setClassesMoneyNewFeenumberCMId   	(int classesMoneyNewFeenumberCMId) { this.classesMoneyNewFeenumberCMId = classesMoneyNewFeenumberCMId; }
}
