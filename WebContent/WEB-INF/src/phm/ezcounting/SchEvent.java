package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchEvent
{

    private int   	id;
    private int   	membrId;
    private Date   	recordTime;
    private Date   	modifyTime;
    private Date   	startTime;
    private Date   	endTime;
    private int   	lastingHours;
    private int   	lastingMins;
    private int   	restMins;
    private int   	userId;
    private int   	type;
    private int   	schdefId;
    private String   	note;
    private int   	status;
    private int   	holidayId;
    private int   	verifystatus;
    private String   	verifyPs;
    private Date   	verifyDate;
    private int   	verifyUserId;


    public SchEvent() {}


    public int   	getId   	() { return id; }
    public int   	getMembrId   	() { return membrId; }
    public Date   	getRecordTime   	() { return recordTime; }
    public Date   	getModifyTime   	() { return modifyTime; }
    public Date   	getStartTime   	() { return startTime; }
    public Date   	getEndTime   	() { return endTime; }
    public int   	getLastingHours   	() { return lastingHours; }
    public int   	getLastingMins   	() { return lastingMins; }
    public int   	getRestMins   	() { return restMins; }
    public int   	getUserId   	() { return userId; }
    public int   	getType   	() { return type; }
    public int   	getSchdefId   	() { return schdefId; }
    public String   	getNote   	() { return note; }
    public int   	getStatus   	() { return status; }
    public int   	getHolidayId   	() { return holidayId; }
    public int   	getVerifystatus   	() { return verifystatus; }
    public String   	getVerifyPs   	() { return verifyPs; }
    public Date   	getVerifyDate   	() { return verifyDate; }
    public int   	getVerifyUserId   	() { return verifyUserId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setRecordTime   	(Date recordTime) { this.recordTime = recordTime; }
    public void 	setModifyTime   	(Date modifyTime) { this.modifyTime = modifyTime; }
    public void 	setStartTime   	(Date startTime) { this.startTime = startTime; }
    public void 	setEndTime   	(Date endTime) { this.endTime = endTime; }
    public void 	setLastingHours   	(int lastingHours) { this.lastingHours = lastingHours; }
    public void 	setLastingMins   	(int lastingMins) { this.lastingMins = lastingMins; }
    public void 	setRestMins   	(int restMins) { this.restMins = restMins; }
    public void 	setUserId   	(int userId) { this.userId = userId; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setSchdefId   	(int schdefId) { this.schdefId = schdefId; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setHolidayId   	(int holidayId) { this.holidayId = holidayId; }
    public void 	setVerifystatus   	(int verifystatus) { this.verifystatus = verifystatus; }
    public void 	setVerifyPs   	(String verifyPs) { this.verifyPs = verifyPs; }
    public void 	setVerifyDate   	(Date verifyDate) { this.verifyDate = verifyDate; }
    public void 	setVerifyUserId   	(int verifyUserId) { this.verifyUserId = verifyUserId; }

    public final static int STATUS_PERSON_CONFORM = 0;   // 人工確認 from 人工登記
    public final static int STATUS_READER_CONFORM = 1;   // 人工確認 from reader登記
    public final static int STATUS_READER_PENDDING = 2;   // 讀卡機產生 pendding 中
    public final static int STATUS_PERSON_PENDDING = 3;  // 人工產生 pendding 中

    public final static int TYPE_PERSONAL = 1;   // 事假
    public final static int TYPE_BUSINESS = 2;   // 公出
    public final static int TYPE_SICK     = 4;   // 生病
    public final static int TYPE_OTHER     = 5;   // 其他假
    public final static int TYPE_YEAR     = 6;   // 年假
    public final static int TYPE_OVERTIME     = 7;   // 補休



    public final static int TYPE_AB_START    = 100;   // 遲到
    public final static int TYPE_AB_ENDING     = 101;   // 早退
    public final static int TYPE_OT_BEFORE    = 102;   // 早到
    public final static int TYPE_OT_AFTER     = 103;   // 晚走加班
    public final static int TYPE_NO_APPEAR     = 104;   // 未出席 其他

    public final static int TYPE_ABSENT    = 109;   // 遲到+早退
    java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyyMMdd");


    public String getDateDefMembr()
    {
        return sdf.format(this.startTime)+"#"+this.schdefId+"#"+this.getMembrId();
    }

    public String getDateDef()
    {
        return sdf.format(this.startTime)+"#"+this.schdefId;
    }
  

    public String getMembrTypeKey()
    {
        return this.getMembrId() + "#" + this.getCombinedType();
    }


    public String statusType()
    {
	int status=this.getStatus();

	int type=this.getType();

	if(type==Holiday.TYPE_HOLIDAY_OFFICE ||type==Holiday.TYPE_HOLIDAY_WEATHER ||type==Holiday.TYPE_HOLIDAY_COMPANY || type==Holiday.TYPE_HOLIDAY_OTHER)
		type=TYPE_BUSINESS;

	if(status==STATUS_PERSON_CONFORM || status==STATUS_READER_CONFORM){

		//缺勤合在一起
		if(type>100)
			type=100;
		return STATUS_PERSON_CONFORM + "#" + type;
	}else if(status==STATUS_READER_PENDDING){
		return STATUS_READER_PENDDING + "#0";
	}else if(status==STATUS_PERSON_PENDDING){
		return STATUS_PERSON_PENDDING + "#0";
	}else{
		return "";
	}
    }
    public int getCombinedStatus(){
	int t=this.getStatus();
	if(t==STATUS_PERSON_CONFORM || t==STATUS_READER_CONFORM)
		return STATUS_PERSON_CONFORM;

	if(t==STATUS_READER_PENDDING || t==STATUS_PERSON_PENDDING)
		return STATUS_READER_PENDDING;

	return t;	

    }

    public int getCombinedType()
    {
        int t = this.getType();
	if (t==TYPE_AB_START || t==TYPE_AB_ENDING)
	    return TYPE_ABSENT;
	return t;
    }

    public int getTimeSpan()
    {
        return this.getLastingHours()*60 + this.getLastingMins();
    }

    public int divideBy15()
    {
        int min = (int) ((this.getEndTime().getTime()-this.getStartTime().getTime())/((long)(60*1000)));
	return min/15;
    }

    public String dateType()
    {
	return sdf.format(this.startTime) + "#" + this.getType();
    }

    public String dateSchDef()
    {
	return sdf.format(this.startTime) + "#" + this.getSchdefId();
    }

    public static String getChinsesType(int t){
	
	switch(t){
		case SchEvent.TYPE_PERSONAL:
			return "事假";
		case SchEvent.TYPE_BUSINESS:
			return "公假";		
		case SchEvent.TYPE_SICK: 
			return "病假";		
		case SchEvent.TYPE_OVERTIME: 
			return "補休";
		case SchEvent.TYPE_OTHER: 
			return "其他假";
		case SchEvent.TYPE_YEAR:
			return "年假";			
		case SchEvent.TYPE_AB_START:
			return "遲到";		
		case SchEvent.TYPE_AB_ENDING:
			return "早退";		
		case SchEvent.TYPE_NO_APPEAR:
			return "缺勤";
		case Holiday.TYPE_HOLIDAY_OFFICE:
			return "國定假日";               
		case Holiday.TYPE_HOLIDAY_WEATHER:
			return "颱風假";               
		case Holiday.TYPE_HOLIDAY_COMPANY:
			return "員工旅行";               
		case Holiday.TYPE_HOLIDAY_OTHER:
			return "其他"; 			
	}
	return "";
    }

    public static boolean createEvent(SchEvent e) throws Exception{

		
	SchEventMgr sem=SchEventMgr.getInstance();

	//年假查看是否有餘額	
	if(e.getType() == SchEvent.TYPE_YEAR){
		int yearHolidayMins=YearHoliday.getYearHolidayMins(e.getMembrId(),e.getStartTime());
		
		int requestMins=e.getLastingHours()*60+e.getLastingMins();
		if(yearHolidayMins <requestMins)
			return false;
	}

	//補休查看是否有餘額	
	if(e.getType() == SchEvent.TYPE_OVERTIME){
		int yearHolidayMins=Overtime.getOvertimeMins(e.getMembrId(),e.getStartTime());
		
		int requestMins=e.getLastingHours()*60+e.getLastingMins();
		if(yearHolidayMins <requestMins)
			return false;
	}
			

	sem.create(e);
	
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");	
	String d1String=sdf.format(e.getStartTime());
	Date d1=sdf.parse(d1String);
	java.util.Calendar c=java.util.Calendar.getInstance();
	c.setTime(d1);
	c.add(Calendar.DATE,1);
	Date d2=c.getTime();

	HolidayMgr hm=HolidayMgr.getInstance();
	ArrayList<Holiday> ah=hm.retrieveList("startTime >='"+sdf.format(d1)+"' and startTime <'"+sdf.format(d2)+"'","");	

	Vector v=new Vector();
	for(int i=0;ah !=null && i<ah.size(); i++){
		Holiday h=ah.get(i);
		Holiday.runEventinside(e,h,v);
	}

	return true;

	/*
	if(v ==null || v.size()<=0)
		return false;
	else
		return true;
	*/
    }

    public static boolean modifyEvent(SchEvent e) throws Exception{

	
	SchEventMgr sem=SchEventMgr.getInstance();

	//年假查看是否有餘額	
	if(e.getType() == SchEvent.TYPE_YEAR){
		int yearHolidayMins=YearHoliday.getYearHolidayMins(e.getMembrId(),e.getStartTime());
		
		int requestMins=e.getLastingHours()*60+e.getLastingMins();
		if(yearHolidayMins <requestMins)
			return false;
	}

	//補休查看是否有餘額	
	if(e.getType() == SchEvent.TYPE_OVERTIME){
		int yearHolidayMins=Overtime.getOvertimeMins(e.getMembrId(),e.getStartTime());
		
		int requestMins=e.getLastingHours()*60+e.getLastingMins();
		if(yearHolidayMins <requestMins)
			return false;
	}

	sem.save(e);
	
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");	
	String d1String=sdf.format(e.getStartTime());
	Date d1=sdf.parse(d1String);
	java.util.Calendar c=java.util.Calendar.getInstance();
	c.setTime(d1);
	c.add(Calendar.DATE,1);
	Date d2=c.getTime();

	HolidayMgr hm=HolidayMgr.getInstance();
	ArrayList<Holiday> ah=hm.retrieveList("startTime >='"+sdf.format(d1)+"' and startTime <'"+sdf.format(d2)+"'","");	

	Vector v=new Vector();
	for(int i=0;ah !=null && i<ah.size(); i++){
		Holiday h=ah.get(i);
		Holiday.runEventinside(e,h,v);
	}

	//if(v ==null || v.size()<=0)
	//	return false;
	//else
		
	return true;
    }

}
