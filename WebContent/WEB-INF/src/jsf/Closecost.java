package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Closecost
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	closecostMonth;
    private int   	closecostType;
    private int   	closecostStatus;
    private int   	closecostCbId;
    private int   	closecostCbCheckId;
    private int   	closecostNum;


    public Closecost() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	closecostMonth,
        int	closecostType,
        int	closecostStatus,
        int	closecostCbId,
        int	closecostCbCheckId,
        int	closecostNum    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.closecostMonth 	 = closecostMonth;
        this.closecostType 	 = closecostType;
        this.closecostStatus 	 = closecostStatus;
        this.closecostCbId 	 = closecostCbId;
        this.closecostCbCheckId 	 = closecostCbCheckId;
        this.closecostNum 	 = closecostNum;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getClosecostMonth   	() { return closecostMonth; }
    public int   	getClosecostType   	() { return closecostType; }
    public int   	getClosecostStatus   	() { return closecostStatus; }
    public int   	getClosecostCbId   	() { return closecostCbId; }
    public int   	getClosecostCbCheckId   	() { return closecostCbCheckId; }
    public int   	getClosecostNum   	() { return closecostNum; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClosecostMonth   	(Date closecostMonth) { this.closecostMonth = closecostMonth; }
    public void 	setClosecostType   	(int closecostType) { this.closecostType = closecostType; }
    public void 	setClosecostStatus   	(int closecostStatus) { this.closecostStatus = closecostStatus; }
    public void 	setClosecostCbId   	(int closecostCbId) { this.closecostCbId = closecostCbId; }
    public void 	setClosecostCbCheckId   	(int closecostCbCheckId) { this.closecostCbCheckId = closecostCbCheckId; }
    public void 	setClosecostNum   	(int closecostNum) { this.closecostNum = closecostNum; }
}
