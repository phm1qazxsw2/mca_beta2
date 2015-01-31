package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryType
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	salaryType;
    private String   	salaryTypeName;
    private String   	salaryTypeFullName;
    private int   	salaryTypeActive;
    private String   	salaryTypePs;
    private int   	salaryTypeContinue;
    private int   	salaryTypeContinueActive;
    private int   	salaryTypeVerufyNeed;
    private int   	salaryTypeFixNumber;


    public SalaryType() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	salaryType,
        String	salaryTypeName,
        String	salaryTypeFullName,
        int	salaryTypeActive,
        String	salaryTypePs,
        int	salaryTypeContinue,
        int	salaryTypeContinueActive,
        int	salaryTypeVerufyNeed,
        int	salaryTypeFixNumber    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryType 	 = salaryType;
        this.salaryTypeName 	 = salaryTypeName;
        this.salaryTypeFullName 	 = salaryTypeFullName;
        this.salaryTypeActive 	 = salaryTypeActive;
        this.salaryTypePs 	 = salaryTypePs;
        this.salaryTypeContinue 	 = salaryTypeContinue;
        this.salaryTypeContinueActive 	 = salaryTypeContinueActive;
        this.salaryTypeVerufyNeed 	 = salaryTypeVerufyNeed;
        this.salaryTypeFixNumber 	 = salaryTypeFixNumber;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getSalaryType   	() { return salaryType; }
    public String   	getSalaryTypeName   	() { return salaryTypeName; }
    public String   	getSalaryTypeFullName   	() { return salaryTypeFullName; }
    public int   	getSalaryTypeActive   	() { return salaryTypeActive; }
    public String   	getSalaryTypePs   	() { return salaryTypePs; }
    public int   	getSalaryTypeContinue   	() { return salaryTypeContinue; }
    public int   	getSalaryTypeContinueActive   	() { return salaryTypeContinueActive; }
    public int   	getSalaryTypeVerufyNeed   	() { return salaryTypeVerufyNeed; }
    public int   	getSalaryTypeFixNumber   	() { return salaryTypeFixNumber; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryType   	(int salaryType) { this.salaryType = salaryType; }
    public void 	setSalaryTypeName   	(String salaryTypeName) { this.salaryTypeName = salaryTypeName; }
    public void 	setSalaryTypeFullName   	(String salaryTypeFullName) { this.salaryTypeFullName = salaryTypeFullName; }
    public void 	setSalaryTypeActive   	(int salaryTypeActive) { this.salaryTypeActive = salaryTypeActive; }
    public void 	setSalaryTypePs   	(String salaryTypePs) { this.salaryTypePs = salaryTypePs; }
    public void 	setSalaryTypeContinue   	(int salaryTypeContinue) { this.salaryTypeContinue = salaryTypeContinue; }
    public void 	setSalaryTypeContinueActive   	(int salaryTypeContinueActive) { this.salaryTypeContinueActive = salaryTypeContinueActive; }
    public void 	setSalaryTypeVerufyNeed   	(int salaryTypeVerufyNeed) { this.salaryTypeVerufyNeed = salaryTypeVerufyNeed; }
    public void 	setSalaryTypeFixNumber   	(int salaryTypeFixNumber) { this.salaryTypeFixNumber = salaryTypeFixNumber; }
}
