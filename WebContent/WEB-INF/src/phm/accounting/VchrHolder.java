package phm.accounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class VchrHolder
{

    private int   	id;
    private Date   	created;
    private Date   	registerDate;
    private String   	serial;
    private int   	userId;
    private int   	type;
    private int   	threadId;
    private int   	note;
    private int   	buId;


    public VchrHolder() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public Date   	getRegisterDate   	() { return registerDate; }
    public String   	getSerial   	() { return serial; }
    public int   	getUserId   	() { return userId; }
    public int   	getType   	() { return type; }
    public int   	getThreadId   	() { return threadId; }
    public int   	getNote   	() { return note; }
    public int   	getBuId   	() { return buId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setRegisterDate   	(Date registerDate) { this.registerDate = registerDate; }
    public void 	setSerial   	(String serial) { this.serial = serial; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setThreadId   	(int threadId) { this.threadId = threadId; }
    public void 	setNote   	(int note) { this.note = note; }
    public void 	setBuId   	(int buId) { this.buId = buId; }

    public static final int TYPE_OBSOLETE = -1;
    public static final int TYPE_TEMPLATE = 1;
    public static final int TYPE_INSTANCE = 2;
    public static final int TYPE_EXPORT   = 3;


    public static final String BILLITEM_DEFAULT	    = "_b_default";
    public static final String BILLITEM_TEMPRECEIPT = "_b_tmprecp";
    public static final String SALARY_BILLITEM_DEFAULT = "_b_salary";

    private static java.text.SimpleDateFormat _sdf = new java.text.SimpleDateFormat("yyyy/MM/dd");
    public String getRegisterDateAsDateStr()
    {
        return _sdf.format(this.registerDate);
    }
  
    public void setRegisterDateCheck(Date r, String space)
        throws Exception
    {
        if (phm.ezcounting.EzCountingService.getInstance().isFreezed(r, space))
	    throw new Exception("已關帳不可修改 [2]");
        this.setRegisterDate(r);
    }

}
