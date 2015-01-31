package phm.ezcounting;


import java.util.*;
import java.sql.*;
import java.util.Date;


public class SchDef
{

    private int   	id;
    private String   	name;
    private Date   	startDate;
    private Date   	endDate;
    private int   	type;
    private String   	content;
    private String   	note;
    private String   	color;
    private int   	rootId;
    private int   	newestId;
    private int   	autoRun;
    private int   	bunitId;


    public SchDef() {}


    public int   	getId   	() { return id; }
    public String   	getName   	() { return name; }
    public Date   	getStartDate   	() { return startDate; }
    public Date   	getEndDate   	() { return endDate; }
    public int   	getType   	() { return type; }
    public String   	getContent   	() { return content; }
    public String   	getNote   	() { return note; }
    public String   	getColor   	() { return color; }
    public int   	getRootId   	() { return rootId; }
    public int   	getNewestId   	() { return newestId; }
    public int   	getAutoRun   	() { return autoRun; }
    public int   	getBunitId   	() { return bunitId; }


    public void 	setId   	(int id) { this.id = id; }
    public void 	setName   	(String name) { this.name = name; }
    public void 	setStartDate   	(Date startDate) { this.startDate = startDate; }
    public void 	setEndDate   	(Date endDate) { this.endDate = endDate; }
    public void 	setType   	(int type) { this.type = type; }
    public void 	setContent   	(String content) { this.content = content; }
    public void 	setNote   	(String note) { this.note = note; }
    public void 	setColor   	(String color) { this.color = color; }
    public void 	setRootId   	(int rootId) { this.rootId = rootId; }
    public void 	setNewestId   	(int newestId) { this.newestId = newestId; }
    public void 	setAutoRun   	(int autoRun) { this.autoRun = autoRun; }
    public void 	setBunitId   	(int bunitId) { this.bunitId = bunitId; }


    public static final int TYPE_DAY_OF_WEEK  = 1;
    public static final int TYPE_DAY_OF_MONTH = 2;
    public static final int TYPE_EVERYDAY     = 3;
    public static final int TYPE_FLEXABLE     = 4;

    private ArrayList<sch_content> contents = null;
    private Map<String, sch_content> _dayMap = null; // key = schdefId + "#" + day

    public ArrayList<sch_content> getSchContent()
	throws Exception
    {
        parse();
        return contents;
    }

    public int getAllRootId()
    {
	if(this.rootId==0)
		return this.id;
	else
		return this.rootId;
    }

    public void parse()  
    	throws Exception
    {
        if (contents!=null)
            return;
        String[] lines = this.getContent().split("\n");
        _dayMap = new HashMap<String, sch_content>();
        contents = new ArrayList<sch_content>();
        for (int i=0; i<lines.length; i++) {
            if (lines[i].trim().length()==0)
    	        continue;
            try {
                contents.add(new sch_content(lines[i], this.getId(), _dayMap));
            }
            catch (Exception e) {
                System.out.println(lines[i]);
                e.printStackTrace();
                throw new Exception("班表內容格式不對");
            }
        }
    }

    private Date nextEndDay = null;
    public Date getNextEndDate()
    {
        if (nextEndDay==null) {
            Calendar c = Calendar.getInstance();
	    c.setTime(this.getEndDate());
	    c.add(Calendar.DATE, 1);
            nextEndDay = c.getTime();
	}
	return nextEndDay;
    }

    public boolean inDateRange(Date d)
	throws Exception
    {
        parse();
        return d.compareTo(this.getStartDate())>=0 && d.compareTo(this.getNextEndDate())<0;
    }

    public sch_content hasDay(Date d)
	throws Exception
    {
        parse();
        if (!inDateRange(d))
            return null;
        _cl.setTime(d);
        if (this.getType()==TYPE_DAY_OF_WEEK) {
            int dd = _cl.get(Calendar.DAY_OF_WEEK);
            dd = dd-1; // 因為Calendar回的dayofweek比我們用的大1
            String key = this.getId()+"#"+dd;
            return _dayMap.get(key);
        }
        else if (this.getType()==TYPE_DAY_OF_MONTH) {
            int dd = _cl.get(Calendar.DAY_OF_MONTH);
            String key = this.getId()+"#"+dd;
            return _dayMap.get(key);
        } 
        else {
            String key = this.getId()+"#"+0;
            return _dayMap.get(key);
        }
    }

    private Calendar _cl = Calendar.getInstance();
    private Map<Date, long[]> _startendmap = null;
    private static long[] nulllong = new long[1];
    public boolean getStartEndTime(Date d, Date d1, Date d2)
	throws Exception
    {

        if (_startendmap!=null) {
            long[] tmp = _startendmap.get(d);
            if (tmp!=null) {
                if (tmp.length==2) {
                    d1.setTime(tmp[0]);
                    d2.setTime(tmp[1]);
                    return true;
                }
                else
                    return false;
            }
        }
        else
            _startendmap = new HashMap<Date, long[]>();

        parse();
        if (hasDay(d)==null) {
            _startendmap.put(d, nulllong);
            return false;
        }

        sch_content sc = null;
        _cl.setTime(d);
        try {
            if (this.getType()==TYPE_DAY_OF_WEEK) {
                int dd = _cl.get(Calendar.DAY_OF_WEEK);
                dd = dd - 1;
                String key = this.getId()+"#"+dd;
                sc = _dayMap.get(key);
            }
            else if (this.getType()==TYPE_DAY_OF_MONTH) {
                int dd = _cl.get(Calendar.DAY_OF_MONTH);
                String key = this.getId()+"#"+dd;
                sc = _dayMap.get(key);
            }
            else {
                // String key = this.getId()+"#"+0;
                sc = contents.get(0);           
            }
        }
        catch (Exception e) {}
        if (sc==null) {
            _startendmap.put(d, nulllong);
            return false;
        }

        _cl.setTime(d);
        _cl.set(Calendar.HOUR_OF_DAY, sc.startHr);
        _cl.set(Calendar.MINUTE, sc.startMin);
        d1.setTime(_cl.getTime().getTime());
        _cl.set(Calendar.HOUR_OF_DAY, sc.endHr);
        _cl.set(Calendar.MINUTE, sc.endMin);
        d2.setTime(_cl.getTime().getTime());
        if (d2.compareTo(d1)<0) { // if overday
            _cl.add(Calendar.DATE, 1);
            d2.setTime(_cl.getTime().getTime());
        }

        // setup _startendmap
        {
            long[] tmp = new long[2];
            tmp[0] = d1.getTime();
            tmp[1] = d2.getTime();
            _startendmap.put(d, tmp);
        }

        return true;
    }


    public int[] getStartHours()
	throws Exception
    {
        parse();
        int[] ret = new int[contents.size()];
        for (int i=0; i<contents.size(); i++) {
            sch_content sc = contents.get(i);
            ret[i] = sc.startHr;
        }
        return ret;
    }

    public int[] getEndHours()
	throws Exception
    {
        parse();
        int[] ret = new int[contents.size()];
        for (int i=0; i<contents.size(); i++) {
            sch_content sc = contents.get(i);
            ret[i] = (sc.endHr<sc.startHr)?(sc.endHr+24):sc.endHr;
        }
        return ret;
    }

    public SchDef findNewestCopy()
	throws Exception
    {
        SchDefMgr sdmgr = SchDefMgr.getInstance();
        if (this.getRootId()!=0) {
            SchDef root = sdmgr.find("id=" + this.getRootId());
            SchDef tmp = sdmgr.find("id=" + root.getNewestId());
            if (tmp!=null)
                return tmp;
        }
        else {
            SchDef tmp = sdmgr.find("id=" + this.getNewestId());
            if (tmp!=null)
                return tmp;
        }
        return this;
    }

    public int getMyRootId()
    {
        if (this.getRootId()==0)
            return this.getId();
        return this.getRootId();
    }

    java.text.SimpleDateFormat _sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
    java.text.SimpleDateFormat _sdf2 = new java.text.SimpleDateFormat("MM/dd");
    public SchDef doSplitOrNot(int tran_id)
        throws Exception
    {
        if (new Date().compareTo(this.getStartDate())<0) {
            return this;
	    }

        SchDef newdef = null;
        SchDefMgr sdmgr = new SchDefMgr(tran_id);            
        Date today = _sdf.parse(_sdf.format(new Date()));
        Calendar c = Calendar.getInstance();
        c.setTime(today);
        c.add(Calendar.DATE, 1);
        Date tomorrow = c.getTime();

        newdef = new SchDef();
        newdef.setStartDate(tomorrow);
        newdef.setEndDate(this.getEndDate());
        newdef.setName(this.getName());
        newdef.setType(this.getType());
        newdef.setContent(this.getContent());
        newdef.setNote(this.getNote());
        newdef.setColor(this.getColor());
        newdef.setRootId((this.getRootId()!=0)?this.getRootId():this.getId());
        sdmgr.create(newdef);

        if (this.getRootId()!=0) {
            SchDef root = sdmgr.find("id=" + this.getRootId());
            root.setNewestId(newdef.getId());
            sdmgr.save(root);
        }
        else {
            this.setNewestId(newdef.getId());
        }

        this.setEndDate(today);
        sdmgr.save(this);
	   
        // copy SchMembr
        SchMembrMgr smmgr = new SchMembrMgr(tran_id);
        ArrayList<SchMembr> schmembrs = smmgr.retrieveList("schdefId=" + this.getId(), "");
        for (int i=0; i<schmembrs.size(); i++) {
            SchMembr sm = schmembrs.get(i);
            sm.setSchdefId(newdef.getId());
            smmgr.create(sm);
        }

        return newdef;
    }


    public static boolean checkConflictSchdef(Membr membr,SchInfo info, ArrayList<SchDef> schdefs,SchDef mySD,Date startDate,Date endDate,int duringDate,String[] ss)
        throws Exception
    {
    	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm");
        Date d1=new Date();
        Date d2=new Date();
        Date myd1=new Date();
        Date myd2=new Date();        

        Calendar c=Calendar.getInstance();

        for (int i=0; i<schdefs.size(); i++) {
            SchDef sd = schdefs.get(i);
            
            if(mySD.getId()==sd.getId())
                continue;

            for(int j=0;j<duringDate;j++){            

                c.setTime(startDate);
                c.add(Calendar.DATE,j);
                Date d=c.getTime();

                boolean isOriginal = info.isOriginal(d, sd.getId());
                int switchStatus = info.getSwitchStatus(d, sd.getId());
                
                if ((isOriginal && switchStatus!=SchswRecord.TYPE_OFF) || (switchStatus==SchswRecord.TYPE_ON)) { // 有班

                    if(mySD.getStartEndTime(d,myd1,myd2)){
                        long md1L=myd1.getTime();
                        long md2L=myd2.getTime();
        
                        //判斷有沒有押到         
                        sd.getStartEndTime(d, d1, d2);

                        long d1L=d1.getTime();
                        long d2L=d2.getTime();
                        
                        boolean failx=false;

                        if(md1L==d1L)
                            failx=true;
                    
                        if(md1L > d1L && d2L>md1L)
                            failx=true;
                    
                        if(d1L>md1L && md2L> d1L)
                            failx=true;                                                        
                        
                        if(failx){
                            
   // System.out.println("d="+sdf.format(d)+" d1="+sdf.format(d1)+"  myd1="+sdf.format(myd1));
   // System.out.println("d="+sdf.format(d)+" d2="+sdf.format(d2)+"  myd2="+sdf.format(myd2));

                            ss[0]=membr.getName()+"加入失敗. id:"+sd.getId()+";"+sd.getName()+"於"+sdf.format(d1)+"-"+sdf.format(d2)+"衝堂.";
                            return false;
                        }
                    }                        
                }
            }
        }
        return true;
    }

    public String getDescription()
        throws Exception
    {
        StringBuffer sb = new StringBuffer();
        sb.append("\t有效期間:" + _sdf2.format(this.getStartDate()) + "至" + _sdf2.format(this.getEndDate()));
        ArrayList<sch_content> schcontents = getSchContent();
        if (this.getType()==TYPE_DAY_OF_WEEK) {
            sb.append("&nbsp;每周:");
            for (int i=0; i<schcontents.size(); i++) {
                int[] days = schcontents.get(i).days;
                for (int j=0; j<days.length; j++) {
                    if (j>0) sb.append(",");
                    sb.append(days[j]);
                }
            }
        }
        else if (this.getType()==TYPE_DAY_OF_MONTH) {
            sb.append("&nbsp;每月:");
            for (int i=0; i<schcontents.size(); i++) {
                int[] days = schcontents.get(i).days;
                for (int j=0; j<days.length; j++) {
                    if (j>0) sb.append(",");
                    sb.append(days[j]);
                }
            }
            sb.append("號");
        } 
        else {
            sb.append("&nbsp;每天:");
        }
        return sb.toString();
    }

    public ArrayList<Date[]> rundate(Date d,ArrayList<int[]> flexTime){
            
        java.text.SimpleDateFormat rsdf1=new java.text.SimpleDateFormat("yyyy/MM/dd");
        java.text.SimpleDateFormat rsdf2=new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm");        

        ArrayList<Date[]> x=new ArrayList<Date[]>();


        for(int i=0;flexTime !=null && i<flexTime.size();i++){
            try{                
                Date[] changeDate=new Date[2];
                int[] timex=flexTime.get(i);
                String startHour=((timex[0]<10)?"0":"")+String.valueOf(timex[0]);
                String startMins=((timex[1]<10)?"0":"")+String.valueOf(timex[1]);
                String startTime=rsdf1.format(d)+" "+startHour+":"+startMins;
                changeDate[0]=rsdf2.parse(startTime);
                String endHour=((timex[2]<10)?"0":"")+String.valueOf(timex[2]);
                String endMins=((timex[3]<10)?"0":"")+String.valueOf(timex[3]);
                String endTime=rsdf1.format(d)+" "+endHour+":"+endMins;
                changeDate[1]=rsdf2.parse(endTime);
                x.add(changeDate);
            }catch(Exception e){
            }
        }
        return x;
    }

    public Date[] getFlexable(Date d,Date d1,Date d2,ArrayList<Date[]> flexDate,Vector<cardreader.Entry> ve2)
    {
	Date[] resultD=new Date[2];
	Date enStartTime=ve2.get(0).getCreated();
	Date enEndTime=ve2.get((ve2.size()-1)).getCreated();                    
	java.text.SimpleDateFormat sdf=new java.text.SimpleDateFormat("HH:mm");
	for(int k=0;k<flexDate.size();k++){

		Date[] nowRun=flexDate.get(k);

		if(k < (flexDate.size()-1)){  //中間的班表

			if(enStartTime.compareTo(nowRun[0])<=0){       

				resultD[0]=nowRun[0];
				resultD[1]=nowRun[1];
				break;                                    
			}
			Date[] nextRun=flexDate.get(k+1);
			if(nowRun[0].compareTo(enStartTime) <0 && enStartTime.compareTo(nextRun[0])<=0){

				if(enEndTime.compareTo(nextRun[1])<0){
				    resultD[0]=nowRun[0];
				    resultD[1]=nowRun[1];
				    break;                                          
				}else{
				    resultD[0]=nextRun[0];
				    resultD[1]=nextRun[1];
				    break;   
				}
			}
		}else{   //最後一個                            
			resultD[0]=nowRun[0];
			resultD[1]=nowRun[1];
			break; 
		}
	}
	return resultD;
    }

}
