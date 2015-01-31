package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Closeincome
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	closeincomeMonth;
    private int   	closeincomeType;
    private int   	closeincomeStatus;
    private int   	closeincomeCbId;
    private int   	closeincomeCbCheckId;
    private int   	closeincomeNum;


    public Closeincome() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	closeincomeMonth,
        int	closeincomeType,
        int	closeincomeStatus,
        int	closeincomeCbId,
        int	closeincomeCbCheckId,
        int	closeincomeNum    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.closeincomeMonth 	 = closeincomeMonth;
        this.closeincomeType 	 = closeincomeType;
        this.closeincomeStatus 	 = closeincomeStatus;
        this.closeincomeCbId 	 = closeincomeCbId;
        this.closeincomeCbCheckId 	 = closeincomeCbCheckId;
        this.closeincomeNum 	 = closeincomeNum;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getCloseincomeMonth   	() { return closeincomeMonth; }
    public int   	getCloseincomeType   	() { return closeincomeType; }
    public int   	getCloseincomeStatus   	() { return closeincomeStatus; }
    public int   	getCloseincomeCbId   	() { return closeincomeCbId; }
    public int   	getCloseincomeCbCheckId   	() { return closeincomeCbCheckId; }
    public int   	getCloseincomeNum   	() { return closeincomeNum; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setCloseincomeMonth   	(Date closeincomeMonth) { this.closeincomeMonth = closeincomeMonth; }
    public void 	setCloseincomeType   	(int closeincomeType) { this.closeincomeType = closeincomeType; }
    public void 	setCloseincomeStatus   	(int closeincomeStatus) { this.closeincomeStatus = closeincomeStatus; }
    public void 	setCloseincomeCbId   	(int closeincomeCbId) { this.closeincomeCbId = closeincomeCbId; }
    public void 	setCloseincomeCbCheckId   	(int closeincomeCbCheckId) { this.closeincomeCbCheckId = closeincomeCbCheckId; }
    public void 	setCloseincomeNum   	(int closeincomeNum) { this.closeincomeNum = closeincomeNum; }
}
