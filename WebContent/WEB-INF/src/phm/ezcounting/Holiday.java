package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class Holiday
{

    private int   	id;
    private Date   	created;
    private int   	type;
    private String   	name;
    private Date   	startTime;
    private Date   	endTime;
    private int   	userId;


    public Holiday() {}


    public int   	getId   	() { return id; }
    public Date   	getCreated   	() { return created; }
    public int   	getType   	() { return type; }
    public String   	getName   	() { return name; }
    public Date   	getStartTime   	() { return startTime; }
    public Date   	getEndTime   	() { return endTime; }
    public int   	getUserId   	() { return userId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setCreated   	(Date created) { this.created = created; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStartTime   	(Date startTime) { this.startTime = startTime; }
    public void 	setEndTime   	(Date endTime) { this.endTime = endTime; }
    public void 	setUserId   	(int userId) { this.userId = userId; }

    public final static int TYPE_HOLIDAY_OFFICE    = 110;   // 國定假日
    public final static int TYPE_HOLIDAY_WEATHER     = 111;   // 颱風假
    public final static int TYPE_HOLIDAY_COMPANY    = 112;   // 員工旅行
    public final static int TYPE_HOLIDAY_OTHER     = 113;   // 其他

    
    public static boolean isnotConflictTime(Date startDate,Date endDate,Date d1,Date d2){
	
	if(startDate.compareTo(d1)==0 && endDate.compareTo(d2)==0)
		return false;

	if(startDate.compareTo(d2)<0 && d1.compareTo(endDate)<0)
		return false;

	if(d2.compareTo(endDate)<0 && startDate.compareTo(d2)<0)
		return false;
		
	return true;		
    }

    public static long MINS=(long)1000*60;
    
    public static int[] getTimeXX(Date d1,Date d2){

	int[] xtime=new int[2];
	long times=d2.getTime()-d1.getTime();
	int mins=(int)(times/MINS);

	xtime[0]=mins/60;
	xtime[1]=mins%60;
			
	return xtime;
    }

    public static void runEventinside(SchEvent se,Holiday h,Vector v){

	SchEventMgr sem=SchEventMgr.getInstance();

	java.text.SimpleDateFormat sdf2=new java.text.SimpleDateFormat("HH:mm");
	//在holiday 裡
	if(se.getType()<110 && h.getStartTime().compareTo(se.getStartTime())<=0 && se.getEndTime().compareTo(h.getEndTime())<=0){

		//System.out.println("0."+sdf2.format(h.getStartTime())+"-"+sdf2.format(h.getEndTime()));
		se.setType(h.getType());
		se.setHolidayId(h.getId());
		se.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se.setUserId(h.getUserId());
		sem.save(se);
		v.add(new Integer(se.getId()));
	}


	//在holiday前面									
	if(se.getType()<110 && se.getEndTime().compareTo(h.getEndTime())<=0 && h.getStartTime().compareTo(se.getEndTime())<=0){

		//System.out.println("1."+sdf2.format(se.getStartTime())+"-"+sdf2.format(h.getStartTime()));
		//System.out.println(sdf2.format(h.getStartTime())+"-"+sdf2.format(se.getEndTime()));				

		//新的event
		SchEvent se2=new SchEvent(); 
		se2.setMembrId(se.getMembrId());
		se2.setRecordTime(new Date());
		se2.setModifyTime(new Date());
		
		int[] timeX=getTimeXX(se.getStartTime(),h.getStartTime());
		se2.setLastingHours(timeX[0]);
		se2.setLastingMins(timeX[1]);
		se2.setStartTime(se.getStartTime());	
		se2.setEndTime(h.getStartTime());
		se2.setType(se.getType());
		se2.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se2.setUserId(h.getUserId());
		se2.setSchdefId(se.getSchdefId());
		sem.create(se2);					

		v.add(new Integer(se2.getId()));
		//改後面的event	
		se.setType(h.getType());
		se.setHolidayId(h.getId());
		int[] timeX2=getTimeXX(h.getStartTime(),se.getEndTime());
		se.setLastingHours(timeX2[0]);
		se.setLastingMins(timeX2[1]);
		se.setStartTime(h.getStartTime());	
		se.setEndTime(se.getEndTime());
		se.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se.setUserId(h.getUserId());
		sem.save(se);
		v.add(new Integer(se.getId()));

	}

	//在holiday後面									
	if(se.getType()<110 && h.getStartTime().compareTo(se.getStartTime())<=0 && se.getStartTime().compareTo(h.getEndTime())<=0){

		//System.out.println("2."+sdf2.format(se.getStartTime())+"-"+sdf2.format(h.getEndTime()));
		//System.out.println(sdf2.format(h.getEndTime())+"-"+sdf2.format(se.getEndTime()));				

		//新的event 後段
		SchEvent se2=new SchEvent(); 
		se2.setMembrId(se.getMembrId());
		se2.setRecordTime(new Date());
		se2.setModifyTime(new Date());
		int[] timeX2=getTimeXX(h.getEndTime(),se.getEndTime());
		se2.setLastingHours(timeX2[0]);
		se2.setLastingMins(timeX2[1]);
		se2.setStartTime(h.getEndTime());	
		se2.setEndTime(se.getEndTime());
		se2.setType(se.getType());
		se2.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se2.setUserId(h.getUserId());
		se2.setSchdefId(se.getSchdefId());
		sem.create(se2);					

		v.add(new Integer(se2.getId()));
		//改前面的event	

		int[] timeX1=getTimeXX(se.getStartTime(),h.getEndTime());
		se.setLastingHours(timeX1[0]);
		se.setLastingMins(timeX1[1]);
		se.setType(h.getType());
		se.setHolidayId(h.getId());
		se.setStartTime(se.getStartTime());	
		se.setEndTime(h.getEndTime());
		se.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se.setUserId(h.getUserId());
		sem.save(se);
		v.add(new Integer(se.getId()));

	}

	//SchEvent 跨越holiday  
	if(se.getType()<110 && se.getStartTime().compareTo(h.getStartTime())<0 && h.getEndTime().compareTo(se.getEndTime())<0){				

		System.out.println("3."+sdf2.format(se.getStartTime())+"-"+sdf2.format(h.getStartTime()));
		//System.out.println(sdf2.format(h.getStartTime())+"-"+sdf2.format(h.getEndTime()));	
		//System.out.println(sdf2.format(h.getEndTime())+"-"+sdf2.format(se.getEndTime()));					

		//新的event 最前段
		SchEvent se2=new SchEvent(); 
		se2.setMembrId(se.getMembrId());
		se2.setRecordTime(new Date());
		se2.setModifyTime(new Date()); 
		int[] timeX2=getTimeXX(se.getStartTime(),h.getStartTime());
		se2.setLastingHours(timeX2[0]);
		se2.setLastingMins(timeX2[1]);
		se2.setStartTime(se.getStartTime());	
		se2.setEndTime(h.getStartTime());
		se2.setType(se.getType());
		se2.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se2.setUserId(h.getUserId());
		se2.setSchdefId(se.getSchdefId());
		sem.create(se2);
		
		v.add(new Integer(se2.getId()));

		//新的event 最後段
		SchEvent se3=new SchEvent(); 
		se3.setMembrId(se.getMembrId());
		se3.setRecordTime(new Date());
		se3.setModifyTime(new Date());
		int[] timeX3=getTimeXX(h.getEndTime(),se.getEndTime());
		se3.setLastingHours(timeX3[0]);
		se3.setLastingMins(timeX3[1]);				
		se3.setStartTime(h.getEndTime());	
		se3.setEndTime(se.getEndTime());
		se3.setType(se.getType());
		se3.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se3.setUserId(h.getUserId());
		se3.setSchdefId(se.getSchdefId());
		sem.create(se3);

		v.add(new Integer(se3.getId()));
		//改前面的event	
		se.setType(h.getType());
		se.setHolidayId(h.getId());
		int[] timeX4=getTimeXX(h.getStartTime(),h.getEndTime());
		se.setLastingHours(timeX4[0]);
		se.setLastingMins(timeX4[1]);	
		se.setStartTime(h.getStartTime());	
		se.setEndTime(h.getEndTime());
		se.setStatus(SchEvent.STATUS_PERSON_CONFORM);
		se.setUserId(h.getUserId());
		sem.save(se);
		v.add(new Integer(se.getId()));			
	}
    }

    public static Vector runEvent(Holiday h){

	//還沒算時間
	Vector v=new Vector();
	try{

		SchEventMgr sem=SchEventMgr.getInstance();
		java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd");
		java.text.SimpleDateFormat sdf2=new java.text.SimpleDateFormat("HH:mm");
		String dString=sdf.format(h.getStartTime());
		Date d=sdf.parse(dString);

		Calendar c=Calendar.getInstance();
		c.setTime(d);
		c.add(Calendar.DATE,1);
		Date nextDate=c.getTime();

		ArrayList<SchEvent> schevents=sem.retrieveList("'"+sdf.format(d)+"' <=startTime and startTime<'"+sdf.format(nextDate)+"'","");
		for(int i=0;schevents !=null && i<schevents.size();i++){
			SchEvent se=schevents.get(i);
			runEventinside(se,h,v);
		}
	}catch(Exception e){}

	return v;

    }

}
