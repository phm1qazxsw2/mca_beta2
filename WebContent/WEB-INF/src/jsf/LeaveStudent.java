package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class LeaveStudent
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private int   	leaveStudentStudentId;
    private int   	leaveStudentReasonId;
    private String   	leaveStudentPs;
    private int   	leaveStudentLogId;
    private int   	bunitId;


    public LeaveStudent() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        int	leaveStudentStudentId,
        int	leaveStudentReasonId,
        String	leaveStudentPs,
        int	leaveStudentLogId,
        int	bunitId    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.leaveStudentStudentId 	 = leaveStudentStudentId;
        this.leaveStudentReasonId 	 = leaveStudentReasonId;
        this.leaveStudentPs 	 = leaveStudentPs;
        this.leaveStudentLogId 	 = leaveStudentLogId;
        this.bunitId 	 = bunitId;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public int   	getLeaveStudentStudentId   	() { return leaveStudentStudentId; }
    public int   	getLeaveStudentReasonId   	() { return leaveStudentReasonId; }
    public String   	getLeaveStudentPs   	() { return leaveStudentPs; }
    public int   	getLeaveStudentLogId   	() { return leaveStudentLogId; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setLeaveStudentStudentId   	(int leaveStudentStudentId) { this.leaveStudentStudentId = leaveStudentStudentId; }
    public void 	setLeaveStudentReasonId   	(int leaveStudentReasonId) { this.leaveStudentReasonId = leaveStudentReasonId; }
    public void 	setLeaveStudentPs   	(String leaveStudentPs) { this.leaveStudentPs = leaveStudentPs; }
    public void 	setLeaveStudentLogId   	(int leaveStudentLogId) { this.leaveStudentLogId = leaveStudentLogId; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }
}
