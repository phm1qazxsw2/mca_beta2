package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class ClassesCharge
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	classesChargeCMId;
    private Date   	classesChargeMonth;
    private int   	classesChargeCategory;
    private int   	classesChargexId;
    private int   	classesChargeYId;
    private int   	classesChargeActive;
    private int   	classesChargeMoneyNumber;
    private String   	classesChargePs;


    public ClassesCharge() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	classesChargeCMId,
        Date	classesChargeMonth,
        int	classesChargeCategory,
        int	classesChargexId,
        int	classesChargeYId,
        int	classesChargeActive,
        int	classesChargeMoneyNumber,
        String	classesChargePs    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.classesChargeCMId 	 = classesChargeCMId;
        this.classesChargeMonth 	 = classesChargeMonth;
        this.classesChargeCategory 	 = classesChargeCategory;
        this.classesChargexId 	 = classesChargexId;
        this.classesChargeYId 	 = classesChargeYId;
        this.classesChargeActive 	 = classesChargeActive;
        this.classesChargeMoneyNumber 	 = classesChargeMoneyNumber;
        this.classesChargePs 	 = classesChargePs;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getClassesChargeCMId   	() { return classesChargeCMId; }
    public Date   	getClassesChargeMonth   	() { return classesChargeMonth; }
    public int   	getClassesChargeCategory   	() { return classesChargeCategory; }
    public int   	getClassesChargexId   	() { return classesChargexId; }
    public int   	getClassesChargeYId   	() { return classesChargeYId; }
    public int   	getClassesChargeActive   	() { return classesChargeActive; }
    public int   	getClassesChargeMoneyNumber   	() { return classesChargeMoneyNumber; }
    public String   	getClassesChargePs   	() { return classesChargePs; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClassesChargeCMId   	(int classesChargeCMId) { this.classesChargeCMId = classesChargeCMId; }
    public void 	setClassesChargeMonth   	(Date classesChargeMonth) { this.classesChargeMonth = classesChargeMonth; }
    public void 	setClassesChargeCategory   	(int classesChargeCategory) { this.classesChargeCategory = classesChargeCategory; }
    public void 	setClassesChargexId   	(int classesChargexId) { this.classesChargexId = classesChargexId; }
    public void 	setClassesChargeYId   	(int classesChargeYId) { this.classesChargeYId = classesChargeYId; }
    public void 	setClassesChargeActive   	(int classesChargeActive) { this.classesChargeActive = classesChargeActive; }
    public void 	setClassesChargeMoneyNumber   	(int classesChargeMoneyNumber) { this.classesChargeMoneyNumber = classesChargeMoneyNumber; }
    public void 	setClassesChargePs   	(String classesChargePs) { this.classesChargePs = classesChargePs; }
}
