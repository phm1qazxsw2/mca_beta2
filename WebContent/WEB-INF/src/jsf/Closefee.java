package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class Closefee
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	closefeeMonth;
    private int   	closefeeType;
    private int   	closefeeStatus;
    private int   	closefeeFtId;
    private int   	closefeeFeenumberId;
    private int   	closefeeNum;


    public Closefee() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	closefeeMonth,
        int	closefeeType,
        int	closefeeStatus,
        int	closefeeFtId,
        int	closefeeFeenumberId,
        int	closefeeNum    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.closefeeMonth 	 = closefeeMonth;
        this.closefeeType 	 = closefeeType;
        this.closefeeStatus 	 = closefeeStatus;
        this.closefeeFtId 	 = closefeeFtId;
        this.closefeeFeenumberId 	 = closefeeFeenumberId;
        this.closefeeNum 	 = closefeeNum;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getClosefeeMonth   	() { return closefeeMonth; }
    public int   	getClosefeeType   	() { return closefeeType; }
    public int   	getClosefeeStatus   	() { return closefeeStatus; }
    public int   	getClosefeeFtId   	() { return closefeeFtId; }
    public int   	getClosefeeFeenumberId   	() { return closefeeFeenumberId; }
    public int   	getClosefeeNum   	() { return closefeeNum; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setClosefeeMonth   	(Date closefeeMonth) { this.closefeeMonth = closefeeMonth; }
    public void 	setClosefeeType   	(int closefeeType) { this.closefeeType = closefeeType; }
    public void 	setClosefeeStatus   	(int closefeeStatus) { this.closefeeStatus = closefeeStatus; }
    public void 	setClosefeeFtId   	(int closefeeFtId) { this.closefeeFtId = closefeeFtId; }
    public void 	setClosefeeFeenumberId   	(int closefeeFeenumberId) { this.closefeeFeenumberId = closefeeFeenumberId; }
    public void 	setClosefeeNum   	(int closefeeNum) { this.closefeeNum = closefeeNum; }
}
