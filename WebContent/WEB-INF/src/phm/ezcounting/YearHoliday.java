package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class YearHoliday
{

    private int   	id;
    private Date   	created;
    private String   	name;
    private Date   	startDate;
    private Date   	endDate;


    public YearHoliday() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public String   	getName   	() { return name; }
    public Date   	getStartDate   	() { return startDate; }
    public Date   	getEndDate   	() { return endDate; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStartDate   	(Date startDate) { this.startDate = startDate; }
    public void 	setEndDate   	(Date endDate) { this.endDate = endDate; }

    public static int getYearHolidayMins(int membrId,Date rundate){

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
	String seQuery="'"+sdf.format(yhj.getStartDate())+"' <= startTime and endTime <='"+sdf.format(yhj.getEndDate())+"' and type='"+SchEvent.TYPE_YEAR+"' and membrId='"+membrId+"'";	
	ArrayList<SchEvent> ase=sem.retrieveList(seQuery,"");
	
	if(ase==null || ase.size()<=0){	
		return yhj.getMins();
	}
	int eventLong=0;
	for(int i=0;i<ase.size();i++){
		SchEvent se=ase.get(i);
		eventLong+=(se.getLastingHours()*60)+se.getLastingMins();
	}
	avalibleDate=yhj.getMins()-eventLong;
	return avalibleDate;
    }

}
