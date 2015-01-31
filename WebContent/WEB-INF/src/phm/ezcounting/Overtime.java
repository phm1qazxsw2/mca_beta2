package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Overtime
{

    private int   	id;
    private Date   	created;
    private int   	membrId;
    private Date   	startDate;
    private Date   	endDate;
    private int   	mins;
    private String   	ps;
    private int   	editUser;
    private int   	status;
    private int   	times;
    private int   	confirmType;
    private int   	confirmMins;
    private String   	confirmPs;
    private int   	userId;


    public Overtime() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public int   	getMembrId   	() { return membrId; }
    public Date   	getStartDate   	() { return startDate; }
    public Date   	getEndDate   	() { return endDate; }
    public int   	getMins   	() { return mins; }
    public String   	getPs   	() { return ps; }
    public int   	getEditUser   	() { return editUser; }
    public int   	getStatus   	() { return status; }
    public int   	getTimes   	() { return times; }
    public int   	getConfirmType   	() { return confirmType; }
    public int   	getConfirmMins   	() { return confirmMins; }
    public String   	getConfirmPs   	() { return confirmPs; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setMembrId   	(int membrId) { this.membrId = membrId; }
    public void 	setStartDate   	(Date startDate) { this.startDate = startDate; }
    public void 	setEndDate   	(Date endDate) { this.endDate = endDate; }
    public void 	setMins   	(int mins) { this.mins = mins; }
    public void 	setPs   	(String ps) { this.ps = ps; }
    public void 	setEditUser   	(int editUser) { this.editUser = editUser; }
    public void 	setStatus   	(int status) { this.status = status; }
    public void 	setTimes   	(int times) { this.times = times; }
    public void 	setConfirmType   	(int confirmType) { this.confirmType = confirmType; }
    public void 	setConfirmMins   	(int confirmMins) { this.confirmMins = confirmMins; }
    public void 	setConfirmPs   	(String confirmPs) { this.confirmPs = confirmPs; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

    public final static int STATUS_ONLINE    = 0;   // ��w����
    public final static int STATUS_USER     = 1;   // �䭷��
   
    public String getMembrSatus(){
	
	return String.valueOf(this.membrId)+"#"+String.valueOf(this.status);
    }    

    public static int getOvertimeMins(int membrId,Date rundate){

	int avalibleDate=0;
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");		

	YearHolidayJoinMgr ym=YearHolidayJoinMgr.getInstance();
	String query="startDate <='"+sdf.format(rundate)+"' and '"+sdf.format(rundate)+"' <= endDate and membrId='"+membrId+"'";
					
	ArrayList<YearHolidayJoin> yh=ym.retrieveList(query,"");
	if(yh==null || yh.size()<=0){
		return avalibleDate;
	}
	
	YearHolidayJoin yhj=yh.get(0);
	SchEventMgr sem=SchEventMgr.getInstance();
	String seQuery="'"+sdf.format(yhj.getStartDate())+"' <= startTime and endTime <='"+sdf.format(yhj.getEndDate())+"' and type='"+SchEvent.TYPE_OVERTIME+"' and membrId='"+membrId+"'";	
	ArrayList<SchEvent> ase=sem.retrieveList(seQuery,"");
	
	if(ase==null || ase.size()<=0){	
		return yhj.getOvertime();
	}
	int eventLong=0;
	for(int i=0;i<ase.size();i++){
		SchEvent se=ase.get(i);
		eventLong+=(se.getLastingHours()*60)+se.getLastingMins();
	}
	avalibleDate=yhj.getOvertime()-eventLong;
	return avalibleDate;
    }

}
