package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class LeaveReason
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private String   	leaveReasonName;
    private int   	leaveReasonActive;
    private int   	bunitId;


    public LeaveReason() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        String	leaveReasonName,
        int	leaveReasonActive,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.leaveReasonName 	 = leaveReasonName;
        this.leaveReasonActive 	 = leaveReasonActive;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public String   	getLeaveReasonName   	() { return leaveReasonName; }
    public int   	getLeaveReasonActive   	() { return leaveReasonActive; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setLeaveReasonName   	(String leaveReasonName) { this.leaveReasonName = leaveReasonName; }
    public void 	setLeaveReasonActive   	(int leaveReasonActive) { this.leaveReasonActive = leaveReasonActive; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
