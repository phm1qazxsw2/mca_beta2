package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Closesalary
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	closesalaryMonth;
    private int   	closesalaryType;
    private int   	closesalaryStatus;
    private int   	closesalarySalaryId;
    private int   	closesalarySalaryNum;
    private int   	closesalaryNum;


    public Closesalary() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	closesalaryMonth,
        int	closesalaryType,
        int	closesalaryStatus,
        int	closesalarySalaryId,
        int	closesalarySalaryNum,
        int	closesalaryNum    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.closesalaryMonth 	 = closesalaryMonth;
        this.closesalaryType 	 = closesalaryType;
        this.closesalaryStatus 	 = closesalaryStatus;
        this.closesalarySalaryId 	 = closesalarySalaryId;
        this.closesalarySalaryNum 	 = closesalarySalaryNum;
        this.closesalaryNum 	 = closesalaryNum;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getClosesalaryMonth   	() { return closesalaryMonth; }
    public int   	getClosesalaryType   	() { return closesalaryType; }
    public int   	getClosesalaryStatus   	() { return closesalaryStatus; }
    public int   	getClosesalarySalaryId   	() { return closesalarySalaryId; }
    public int   	getClosesalarySalaryNum   	() { return closesalarySalaryNum; }
    public int   	getClosesalaryNum   	() { return closesalaryNum; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClosesalaryMonth   	(Date closesalaryMonth) { this.closesalaryMonth = closesalaryMonth; }
    public void 	setClosesalaryType   	(int closesalaryType) { this.closesalaryType = closesalaryType; }
    public void 	setClosesalaryStatus   	(int closesalaryStatus) { this.closesalaryStatus = closesalaryStatus; }
    public void 	setClosesalarySalaryId   	(int closesalarySalaryId) { this.closesalarySalaryId = closesalarySalaryId; }
    public void 	setClosesalarySalaryNum   	(int closesalarySalaryNum) { this.closesalarySalaryNum = closesalarySalaryNum; }
    public void 	setClosesalaryNum   	(int closesalaryNum) { this.closesalaryNum = closesalaryNum; }
}
