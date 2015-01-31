package jsf;


import java.util.*;
import java.sql.*;
import java.util.Date;
import com.axiom.util.*;


public class SalaryTicket
{

    private int   	id;
    private Date   	created;
    private Date   	modified;
    private Date   	salaryTicketMonth;
    private int   	salaryTicketSanumberId;
    private int   	salaryTicketTeacherId;
    private int   	salaryTicketDepartId;
    private int   	salaryTicketPositionId;
    private int   	salaryTicketClassesId;
    private int   	salaryTicketMoneyType1;
    private int   	salaryTicketMoneyType2;
    private int   	salaryTicketMoneyType3;
    private int   	salaryTicketTotalMoney;
    private int   	salaryTicketPayMoney;
    private int   	salaryTicketPayTimes;
    private Date   	salaryTicketPayDate;
    private int   	salaryTicketStatus;
    private int   	salaryFeePrintNeed;
    private String   	salaryTicketPs;
    private int   	salaryTicketNewFeenumber;
    private int   	salaryTicketAcceptStatus;
    private String   	salaryTicketAcceptPs;
    private int   	salaryTicketTeacherParttime;


    public SalaryTicket() {}


    public void init
    (
        int	id,
        Date	created,
        Date	modified,
        Date	salaryTicketMonth,
        int	salaryTicketSanumberId,
        int	salaryTicketTeacherId,
        int	salaryTicketDepartId,
        int	salaryTicketPositionId,
        int	salaryTicketClassesId,
        int	salaryTicketMoneyType1,
        int	salaryTicketMoneyType2,
        int	salaryTicketMoneyType3,
        int	salaryTicketTotalMoney,
        int	salaryTicketPayMoney,
        int	salaryTicketPayTimes,
        Date	salaryTicketPayDate,
        int	salaryTicketStatus,
        int	salaryFeePrintNeed,
        String	salaryTicketPs,
        int	salaryTicketNewFeenumber,
        int	salaryTicketAcceptStatus,
        String	salaryTicketAcceptPs,
        int	salaryTicketTeacherParttime    )
    {
        this.id 	 = id;
        this.created 	 = created;
        this.modified 	 = modified;
        this.salaryTicketMonth 	 = salaryTicketMonth;
        this.salaryTicketSanumberId 	 = salaryTicketSanumberId;
        this.salaryTicketTeacherId 	 = salaryTicketTeacherId;
        this.salaryTicketDepartId 	 = salaryTicketDepartId;
        this.salaryTicketPositionId 	 = salaryTicketPositionId;
        this.salaryTicketClassesId 	 = salaryTicketClassesId;
        this.salaryTicketMoneyType1 	 = salaryTicketMoneyType1;
        this.salaryTicketMoneyType2 	 = salaryTicketMoneyType2;
        this.salaryTicketMoneyType3 	 = salaryTicketMoneyType3;
        this.salaryTicketTotalMoney 	 = salaryTicketTotalMoney;
        this.salaryTicketPayMoney 	 = salaryTicketPayMoney;
        this.salaryTicketPayTimes 	 = salaryTicketPayTimes;
        this.salaryTicketPayDate 	 = salaryTicketPayDate;
        this.salaryTicketStatus 	 = salaryTicketStatus;
        this.salaryFeePrintNeed 	 = salaryFeePrintNeed;
        this.salaryTicketPs 	 = salaryTicketPs;
        this.salaryTicketNewFeenumber 	 = salaryTicketNewFeenumber;
        this.salaryTicketAcceptStatus 	 = salaryTicketAcceptStatus;
        this.salaryTicketAcceptPs 	 = salaryTicketAcceptPs;
        this.salaryTicketTeacherParttime 	 = salaryTicketTeacherParttime;
    }


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getModified   	() { return modified; }
    public Date   	getSalaryTicketMonth   	() { return salaryTicketMonth; }
    public int   	getSalaryTicketSanumberId   	() { return salaryTicketSanumberId; }
    public int   	getSalaryTicketTeacherId   	() { return salaryTicketTeacherId; }
    public int   	getSalaryTicketDepartId   	() { return salaryTicketDepartId; }
    public int   	getSalaryTicketPositionId   	() { return salaryTicketPositionId; }
    public int   	getSalaryTicketClassesId   	() { return salaryTicketClassesId; }
    public int   	getSalaryTicketMoneyType1   	() { return salaryTicketMoneyType1; }
    public int   	getSalaryTicketMoneyType2   	() { return salaryTicketMoneyType2; }
    public int   	getSalaryTicketMoneyType3   	() { return salaryTicketMoneyType3; }
    public int   	getSalaryTicketTotalMoney   	() { return salaryTicketTotalMoney; }
    public int   	getSalaryTicketPayMoney   	() { return salaryTicketPayMoney; }
    public int   	getSalaryTicketPayTimes   	() { return salaryTicketPayTimes; }
    public Date   	getSalaryTicketPayDate   	() { return salaryTicketPayDate; }
    public int   	getSalaryTicketStatus   	() { return salaryTicketStatus; }
    public int   	getSalaryFeePrintNeed   	() { return salaryFeePrintNeed; }
    public String   	getSalaryTicketPs   	() { return salaryTicketPs; }
    public int   	getSalaryTicketNewFeenumber   	() { return salaryTicketNewFeenumber; }
    public int   	getSalaryTicketAcceptStatus   	() { return salaryTicketAcceptStatus; }
    public String   	getSalaryTicketAcceptPs   	() { return salaryTicketAcceptPs; }
    public int   	getSalaryTicketTeacherParttime   	() { return salaryTicketTeacherParttime; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setModified   	(Date modified) { this.modified = modified; }
    public void 	setSalaryTicketMonth   	(Date salaryTicketMonth) { this.salaryTicketMonth = salaryTicketMonth; }
    public void 	setSalaryTicketSanumberId   	(int salaryTicketSanumberId) { this.salaryTicketSanumberId = salaryTicketSanumberId; }
    public void 	setSalaryTicketTeacherId   	(int salaryTicketTeacherId) { this.salaryTicketTeacherId = salaryTicketTeacherId; }
    public void 	setSalaryTicketDepartId   	(int salaryTicketDepartId) { this.salaryTicketDepartId = salaryTicketDepartId; }
    public void 	setSalaryTicketPositionId   	(int salaryTicketPositionId) { this.salaryTicketPositionId = salaryTicketPositionId; }
    public void 	setSalaryTicketClassesId   	(int salaryTicketClassesId) { this.salaryTicketClassesId = salaryTicketClassesId; }
    public void 	setSalaryTicketMoneyType1   	(int salaryTicketMoneyType1) { this.salaryTicketMoneyType1 = salaryTicketMoneyType1; }
    public void 	setSalaryTicketMoneyType2   	(int salaryTicketMoneyType2) { this.salaryTicketMoneyType2 = salaryTicketMoneyType2; }
    public void 	setSalaryTicketMoneyType3   	(int salaryTicketMoneyType3) { this.salaryTicketMoneyType3 = salaryTicketMoneyType3; }
    public void 	setSalaryTicketTotalMoney   	(int salaryTicketTotalMoney) { this.salaryTicketTotalMoney = salaryTicketTotalMoney; }
    public void 	setSalaryTicketPayMoney   	(int salaryTicketPayMoney) { this.salaryTicketPayMoney = salaryTicketPayMoney; }
    public void 	setSalaryTicketPayTimes   	(int salaryTicketPayTimes) { this.salaryTicketPayTimes = salaryTicketPayTimes; }
    public void 	setSalaryTicketPayDate   	(Date salaryTicketPayDate) { this.salaryTicketPayDate = salaryTicketPayDate; }
    public void 	setSalaryTicketStatus   	(int salaryTicketStatus) { this.salaryTicketStatus = salaryTicketStatus; }
    public void 	setSalaryFeePrintNeed   	(int salaryFeePrintNeed) { this.salaryFeePrintNeed = salaryFeePrintNeed; }
    public void 	setSalaryTicketPs   	(String salaryTicketPs) { this.salaryTicketPs = salaryTicketPs; }
    public void 	setSalaryTicketNewFeenumber   	(int salaryTicketNewFeenumber) { this.salaryTicketNewFeenumber = salaryTicketNewFeenumber; }
    public void 	setSalaryTicketAcceptStatus   	(int salaryTicketAcceptStatus) { this.salaryTicketAcceptStatus = salaryTicketAcceptStatus; }
    public void 	setSalaryTicketAcceptPs   	(String salaryTicketAcceptPs) { this.salaryTicketAcceptPs = salaryTicketAcceptPs; }
    public void 	setSalaryTicketTeacherParttime   	(int salaryTicketTeacherParttime) { this.salaryTicketTeacherParttime = salaryTicketTeacherParttime; }
}
