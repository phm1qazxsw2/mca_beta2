<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");


    String printHrMin(int min)
    {
        if (min==0) return " 0 分鐘";
        if (min<60)
            return min+" 分鐘";

        int hr = 0;
        hr = min/60;
        min = min%60;
        StringBuffer sb = new StringBuffer();
        
        sb.append(hr+" 小時");
        if(min !=0)
            sb.append(min+" 分鐘");
        return sb.toString();
    }

    int countEvent(Vector<SchEvent> event){
        
        if(event ==null || event.size()<0)
            return 0;

        int total=0;
        for(int i=0;i<event.size();i++){
            SchEvent se=event.get(i);
            total+=(se.getLastingHours()*60)+se.getLastingMins();
        }
        return total;
    }

    String checkEvent(Map<String,Vector<SchEvent>> eventMap,Map<Integer,Membr> membrMap,String rundate,int type){

        String indexString=rundate+"#"+type;

        Vector v=eventMap.get(indexString);

        if(v ==null || v.size()<=0){
            return "&nbsp;";
        }else{
 
            StringBuffer sb=new StringBuffer();
            for(int i=0;i<v.size();i++){
                SchEvent se=(SchEvent)v.get(i);
                Membr m=membrMap.get(new Integer(se.getMembrId()));
                String xhour="";
                if(se.getLastingHours()!=0)
                    xhour=se.getLastingHours()+"小時";
                if(se.getLastingMins()!=0)
                    xhour+=se.getLastingMins()+"分鐘";
                
                if(se.getStatus()==SchEvent.STATUS_READER_PENDDING)
                    sb.append("<font color=blue>*</font>");

               sb.append("<a href=\"#\" onClick=\"javascript:openwindow_phm('modifySchEvent.jsp?seId="+se.getId()+"', '輸出出勤excel',500, 420, 'addevent');return false\">");
                sb.append(m.getName()+"<br>&nbsp;&nbsp;"+xhour+"<br>");
                sb.append("&nbsp;&nbsp;"+sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime())+"<br><br>");
                sb.append("</a>");
            }
            return sb.toString();
        }
        
    }
%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdfday = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("yyyyMMdd");
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date d1 = c.getTime();
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1); 
    Date d2 = new Date();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

    long oneday=(long)(1000*60*60*24);
    long duringLong2=d2.getTime()-d1.getTime();
    if(duringLong2 <0)
        return;

    int duringDate=(int)(duringLong2/oneday);
    duringDate++;


    int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'", "");    
    SchEventInfo infoevent = new SchEventInfo(schevents);

    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));


    ArrayList<Entry> entries = null;
    Map<String, Vector<Entry>> entryMap = null;
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    String readerId=SchEventInfo.getMachineId();
    
    entries = emgr.retrieveList("created>='" + sdf.format(d1) + "' and created<'" + 
        sdf.format(nextEndDay)+"' "+readerId, " order by created asc");
    entryMap = new SortingMap(entries).doSort("getDateCard");



    String query="teacherStatus!=0";

    if(bunit !=-1)
        query+=" and teacherBunitId='"+bunit+"'";

    ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, "");
    String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
    Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, d1, d2);


    ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(d1, d2,bunit);
    Map<Integer, Vector<SchDef>> schdefRootMap = new SortingMap(schdefs).doSort("getAllRootId");

    if(schdefs ==null || schdefs.size()<=0){
%>
        <blockquote>
        <div class=es02>
        本期間沒有班表.
        </div>            
        </blockquote>
<%
        return;
    }

    Vector alltable=new Vector();
    Vector row1=new Vector();
    StringCell sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setExcelCellattibute(20);
    sc.setCell("班別 \\ 教職員");
    row1.add(sc);

    Iterator<Integer> iter = schdefRootMap.keySet().iterator();
    int nowRun=1;
    while (iter.hasNext()) {
        Integer defIn=iter.next();
        Vector<SchDef> sdv = schdefRootMap.get(defIn);
        SchDef sd=null;
        if(sdv !=null)
            sd=(SchDef)sdv.get(0);
            
        sc=new StringCell();
        sc.setColspan(0);
        sc.setRowspan(0);
        sc.setExcelCellattibute(50);
        sc.setCell(sd.getName()+"\n"+(sd.getAutoRun()==1?"(正常班模式)":"(加班模式)"));
        row1.add(sc);
    }

    alltable.add(row1);

    for (int i=0;membrs!=null && i<membrs.size(); i++) {

        Membr membr = membrs.get(i);
        SchInfo info = schinfoMap.get(new Integer(membr.getId()));

        row1=new Vector();

        sc=new StringCell();
        sc.setColspan(0);
        sc.setRowspan(0);
        sc.setExcelCellattibute(15);
        sc.setExcelAlign(1);
        sc.setExcelVAlign(1);
        sc.setCell(((membr !=null)?membr.getName():""));
        row1.add(sc);

        //拿這段區間的卡號
        Hashtable<String,String> ha=CardMembr.getCardDate(d1,d2,membr);

        Date rightnow=new Date();
        long mins=(long)1000*60;
        iter = schdefRootMap.keySet().iterator();
        while (iter.hasNext()) {

            int totalWork=0;
            Integer defIn=iter.next();
            Vector<SchDef> sdv = schdefRootMap.get(defIn);        

            StringBuffer outString=new StringBuffer("");

    
            for(int j=0;sdv !=null && j<sdv.size();j++){

                SchDef sd=sdv.get(j);
                Date startDate=new Date();
                Date endDate=new Date();
                int validTime=0;
                for(int k=0;k<duringDate;k++){                                
                    Calendar c2=Calendar.getInstance();
                    c2.setTime(d1);
                    c2.add(Calendar.DATE,k);
                    Date rundate=c2.getTime();

                    if(rundate.compareTo(sd.getStartDate())<0 || sd.getEndDate().compareTo(rundate)<0 || rightnow.compareTo(rundate)<=0)
                        continue;

                    boolean isOriginal = info.isOriginal(rundate, sd.getId());
                    int switchStatus = info.getSwitchStatus(rundate, sd.getId());
                    int entryX=0;  //沒班 但有刷
                    StringBuffer sbx=new StringBuffer();
                    Vector<Entry> vEntry=null;
                    if(ha !=null){
                        String cardidX=ha.get(sdf.format(rundate));
                        if(cardidX !=null){
                            vEntry=entryMap.get(sdf.format(rundate)+cardidX);

                            if(vEntry !=null && vEntry.size()>=1){
                                if(info.isSchDef(sd.getId()))
                                    entryX++;
                                if(vEntry.size()==1){
                                    sbx.append("刷卡記錄不完整:"+sdftime.format(vEntry.get(0).getCreated()));                            
                                }else{
                                    validTime++;
                                    for(int k2=0;k2<vEntry.size();k2++){
                                        Entry en=vEntry.get(k2);
                                        if(k2==0 || (k2==(vEntry.size()-1))){
                                            if(k2 ==0)
                                                sbx.append("刷卡時間:");
                                            if(k2 !=0)
                                                sbx.append("-");                        
                                            sbx.append(sdftime.format(en.getCreated()));
                                        }
                                    }
                                }
                            }else{
                                sbx.append("無刷卡記錄");                        
                            }
                        }else{
                                sbx.append("未設定卡片");                        
                        }
                    }

                    if ((isOriginal && switchStatus!=SchswRecord.TYPE_OFF) || (switchStatus==SchswRecord.TYPE_ON)) { // 有班

                        sch_content s_c=info.getSchContent(rundate,sd.getId());                
                        sd.getStartEndTime(rundate, startDate, endDate);                            
                        if(sd.getAutoRun()==1){
                            outString.append(sdfday.format(startDate));
                            int offtime=0;                    
                            if(s_c !=null)    
                                offtime=s_c.offtime;
                            int thismins=(int)((endDate.getTime()-startDate.getTime())/mins)-offtime;

                            Vector vEvent=infoevent.getDateDefMembr(rundate,sd.getId(),membr.getId());
                            
                            int totalEvent=0;

                            totalWork+=thismins;
                            if(vEvent !=null && vEvent.size()>0){
                                totalEvent=countEvent(vEvent);
                                //out.println("-"+printHrMin(totalEvent));                        
                                //out.println("=<font color=blue>"+printHrMin(thismins-totalEvent)+"</font>");
                                totalWork-=totalEvent;
                            }

                            outString.append("  出勤時間:"+printHrMin(thismins-totalEvent));  
                            if(vEvent !=null && vEvent.size()>0){
                                if(vEvent.size()==1){
                                    SchEvent se=(SchEvent)vEvent.get(0);
                                    outString.append("   ("+se.getChinsesType(se.getType())+":"+printHrMin(totalEvent)+")");  
                                }else{
                                    outString.append("   (缺勤:"+printHrMin(totalEvent)+")");  
                                }
                            }
                            outString.append("\n");
                            outString.append("          "+sbx.toString()+"\n");
                        }else{
                            outString.append(sdfday.format(startDate)+"  ");
                            if(vEntry==null){
                                outString.append("無刷卡記錄");
                                
                            }else if(vEntry.size()<=1){
                                outString.append("刷卡記錄不完整 "+sdftime.format(vEntry.get(0).getCreated()));
                            }else{

                                Date[] validDate=CardMembr.getValidTime(vEntry,startDate, endDate);
                                int validMins=(int)((validDate[1].getTime()-validDate[0].getTime())/(long)(1000*60));
                                outString.append(" *出勤時間:"+printHrMin(validMins)+"\n");
                                outString.append("            "+sbx.toString());   
                                totalWork+=validMins;

                            }

                            outString.append("\n");
                        }                            
                    }else{
                         if(entryX !=0){
                            if(sd.getAutoRun()==1)
                                outString.append(sdfday.format(rundate)+" "+sbx.toString()+"\n");
                            else
                                outString.append(sdfday.format(rundate)+" *"+sbx.toString()+"\n");
                        }
                    }
                } 
                if(totalWork !=0)
                    outString.append("\n\n有效刷卡:"+validTime+" 天  小計:"+printHrMin(totalWork));
            }   
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setExcelCellattibute(40);
            sc.setCell(outString.toString());
            row1.add(sc);
        }
    
        alltable.add(row1);   
    }

    String attribute=" border=1 width=95%";
    CellPrinter cp=CellPrinter.getInstance();

    String filename=String.valueOf(new Date().getTime());       
    String path=application.getRealPath("/")+"eSystem/exlfile/"+filename+".xls";

    String bunitName="";
    BunitMgr bm=BunitMgr.getInstance();

    if(bunit !=-1){
        if(bunit==0){
            bunitName=" 部門:未定 ";
        }else{
            Bunit bb=bm.find("id='"+bunit+"'");
            if(bb !=null)
                bunitName=" 部門:"+bb.getLabel()+" ";
        }                
    }    

    cp.printExcel(path,pd2.getPaySystemCompanyName()+" "+bunitName+" "+sdf.format(d1)+"-"+sdf.format(d2)+" 出勤報表",false,alltable);

    //cp.printHTML(attribute,alltable)
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;出勤報表-輸出excel</b>
</div> 

<form name="f">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<blockquote>
<a href="exlfile/<%=filename%>.xls"><img src="pic/excel2.png" border=0>&nbsp;下載excel檔</a>
</blockquote>