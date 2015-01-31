<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String printHrMin(int min)
    {
        if (min==0) return " 0 分";
        if (min<60)
            return min+" 分";

        int hr = 0;
        hr = min/60;
        min = min%60;
        StringBuffer sb = new StringBuffer();
        
        sb.append(hr+" 時");
        if(min !=0)
            sb.append(min+" 分");
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

    String switchType(int type){

        switch(type){
            case SchEvent.TYPE_PERSONAL:
                return "事假:";                
            case SchEvent.TYPE_BUSINESS:
                return "公假:";                
            case SchEvent.TYPE_SICK:
                return "病假:";                
            case SchEvent.TYPE_OTHER:
                return "其他假:";                
            case SchEvent.TYPE_AB_START:
                return "遲到:";  
            case SchEvent.TYPE_AB_ENDING:
                return "早退:";   
            case SchEvent.TYPE_NO_APPEAR:
                return "未出席:";               
            case Holiday.TYPE_HOLIDAY_OFFICE:
                return "國定假日:";               
            case Holiday.TYPE_HOLIDAY_WEATHER:
                return "颱風假:";               
            case Holiday.TYPE_HOLIDAY_COMPANY:
                return "員工旅行:";               
            case Holiday.TYPE_HOLIDAY_OTHER:
                return "其他:";               
            default:
                return "";
        }
    }
%>
<%@ include file="jumpTop.jsp"%>
<%
    //int type = -1;
    //try { type = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
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


    Map<String,Vector<SchEvent>> eventMap=new SortingMap(schevents).doSort("dateSchDef");

    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));


    //出勤data
    ArrayList<Entry> entries = null;
    Map<String, Vector<Entry>> entryMap = null;
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    String readerId=SchEventInfo.getMachineId();
    
    entries = emgr.retrieveList("created>='" + sdf.format(d1) + "' and created<'" + 
        sdf.format(nextEndDay)+"' "+readerId, " order by created asc");
    entryMap = new SortingMap(entries).doSort("getDateCard");

    String query="";

    ArrayList<MembrTeacher> all_teachers = MembrTeacherMgr.getInstance().retrieveList(query, "");
    String membrIds = new RangeMaker().makeRange(all_teachers, "getMembrId");
    ArrayList<Membr> membrs = MembrMgr.getInstance().retrieveList("id in (" + membrIds + ")", "");
    Map<Integer, Membr> membrMap = new SortingMap(membrs).doSortSingleton("getId");

    Map<Integer, SchInfo> schinfoMap = SchInfo.getSchInfoForMembrs(membrs, d1, d2);

    ArrayList<SchDef> schdefs = SchInfo.getSchDefsWithin(d1, d2,bunit);
    Map<Integer, Vector<SchDef>> schdefRootMap = new SortingMap(schdefs).doSort("getAllRootId");


    // 處理卡的對應和讀入 membr 打卡的 entry   抓最近的卡片資料
/*
    ArrayList<CardMembr> cards = CardMembrMgr.getInstance().retrieveList("membrId in (" + membrIds + ") and created<'"+sdf.format(nextDay)+"'", " order by created desc");
    Map<Integer, CardMembr> membrcardMap = new SortingMap(cards).doSortSingleton("getMembrId");
*/
%>

<%
    if (schevents==null || schevents.size()<=0) {
%>
    <div class=es02>
    &nbsp;&nbsp;&nbsp;&nbsp;區段內無出缺勤請假資料.
    </div>
<%
        return;
    }

    Vector alltable=new Vector();
    Vector row1=new Vector();
    StringCell sc=null;
    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setExcelAlign(1);
    sc.setExcelVAlign(1);
    sc.setExcelCellattibute(25);
    sc.setCell("日期/班表");
    row1.add(sc);

    Iterator<Integer> iter = schdefRootMap.keySet().iterator();
    while (iter.hasNext()) {
        Integer defIn=iter.next();
        Vector<SchDef> sdv = schdefRootMap.get(defIn);
        if(sdv !=null){
            SchDef sd=sdv.get(0);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setExcelCellattibute(60);
            sc.setCell(sd.getName()+(sd.getAutoRun()==1?"(正常班模式)":"(加班模式)"));
            row1.add(sc);
        }
    }
    alltable.add(row1);
    
    for(int i=0;i<duringDate;i++)
    {
        Calendar c2=Calendar.getInstance();
        c2.setTime(d1);
        c2.add(Calendar.DATE,i);
        Date rundate=c2.getTime();
        String rx=sdf2.format(rundate);

        row1=new Vector();
        sc=new StringCell();
        sc.setColspan(0);
        sc.setRowspan(0);
        sc.setExcelAlign(1);
        sc.setExcelVAlign(1);
        sc.setExcelCellattibute(15);
        sc.setCell(sdf.format(rundate)+" ("+SchInfo.printDayOfWeek(c2.get(Calendar.DAY_OF_WEEK))+")");
        row1.add(sc);

        for(int j=0;j<schdefs.size();j++){

            SchDef sd=schdefs.get(j);
            String eventIndex=sdf2.format(rundate)+"#"+sd.getId();
            Vector v=eventMap.get(eventIndex);
            
            StringBuffer sb=new StringBuffer();                

            for(int k=0;v !=null &&k<v.size();k++){
                    SchEvent se=(SchEvent)v.get(k); 
                    Membr m=membrMap.get(new Integer(se.getMembrId()));
                    if(m !=null){

                        if(se.getStatus()==SchEvent.STATUS_READER_PENDDING)
                            sb.append("*");
                        else
                            sb.append(" ");
                        sb.append(switchType(se.getType())+" ");
                        sb.append(m.getName()+" \n");
                        sb.append("    ");                        
                        sb.append("缺勤時間:"+sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime())+"(共:"+ ((se.getLastingHours()!=0)?se.getLastingHours()+"小時":"")+((se.getLastingMins()!=0)?se.getLastingMins()+"分鐘":"")+")\n");                        
                        Hashtable<String,String> ha=CardMembr.getCardDate(rundate,rundate,m);
                        if(ha !=null){
                            String cardidX=ha.get(sdf.format(rundate));
                            if(cardidX !=null){

                                Vector<Entry> vEntry=entryMap.get(sdf.format(rundate)+cardidX);

                                if(vEntry !=null && vEntry.size()>=2){
                                    Entry en1=vEntry.get(0);
                                    Entry en2=vEntry.get(vEntry.size()-1);

                                    sb.append("    刷卡紀錄:"+sdftime.format(en1.getCreated())+"-"+sdftime.format(en2.getCreated())+"\n\n");
                                }else if(vEntry==null || vEntry.size()==0){                
                                    sb.append("    沒有刷卡紀錄\n\n");                                                  
                                }else{
                                    sb.append("    刷卡異常:"+((vEntry.get(0)!=null)?sdftime.format(vEntry.get(0).getCreated()):"")+"\n\n");
                               }
                            }
                        }
                    }
                }
                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelAlign(1);
                sc.setExcelVAlign(1);
                sc.setExcelCellattibute(40);
                sc.setCell(sb.toString());
                row1.add(sc);
            }
            alltable.add(row1);
        }
        
        row1=new Vector();
        sc=new StringCell();
        sc.setColspan(3);
        sc.setRowspan(0);
        sc.setExcelAlign(1);
        sc.setCell(" * 為尚未確認(Pendding)的缺勤.");
        row1.add(sc);
        alltable.add(row1);

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
        cp.printExcel(path,pd2.getPaySystemCompanyName()+" "+bunitName+sdf.format(d1)+"-"+sdf.format(d2)+" 缺勤日報表",false,alltable);
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;缺勤日報表-輸出excel</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<blockquote>
<div class=es02>
    <a href="exlfile/<%=filename%>.xls"><img src="pic/excel2.png" border=0>&nbsp;下載excel檔</a>
</div>
</blockquote>


