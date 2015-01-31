<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String getTableHeaderInfo(int showType)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=\"#FFFF66\" class=es02>");
        sb.append("<td align=middle bgcolor='#ffffff'>&nbsp;<br>&nbsp;</td>");

        switch(showType){
            case 0:
                sb.append("<td align=middle colspan=4 bgcolor='#ffffff'><img src='images/dotx.gif' border=0>&nbsp;未確認的缺勤(pending)<br></td>");
                sb.append("<td align=middle bgcolor='#ffffff'></td>");
                sb.append("<td align=middle colspan=3 bgcolor='#ffffff'>不扣薪缺勤<br></td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle colspan=4><b>缺勤記錄</b><br></td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle colspan=4><b>請假記錄</b><br></td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle><b>正式缺勤合計</b></td>");
                break;
            case 1:
                sb.append("<td align=middle colspan=4 bgcolor='#ffffff'><img src='images/dotx.gif' border=0>&nbsp;未確認的缺勤(pending)<br></td>");
                break;
            case 2:
                sb.append("<td align=middle colspan=3 bgcolor='#ffffff'>不扣薪缺勤<br></td>");
                break;
            case 3:
                sb.append("<td align=middle colspan=4><b>缺勤記錄</b><br></td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle colspan=4><b>請假記錄</b><br></td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle><b>正式缺勤合計</b></td>");
                break;
        }
        sb.append("</tr>");
        return sb.toString();
    }

    String getTableHeader(int showType)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("<td align=middle bgcolor=#ffffff></td>");

        switch(showType){
            case 0:
                sb.append("<td align=middle>遲到</td>");
                sb.append("<td align=middle>早退</td>");
                sb.append("<td align=middle>缺勤</td>");
                sb.append("<td>小計</td>");
                sb.append("<td bgcolor='#ffffff'>&nbsp;&nbsp;</td>");
                sb.append("<td align=middle>公假</td>");
                sb.append("<td align=middle>年假</td>");
                sb.append("<td align=middle>小計</td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle>遲到</td>");
                sb.append("<td align=middle>早退</td>");
                sb.append("<td align=middle>其他</td>");
                sb.append("<td align=middle>小計</td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle>事假</td>");
                sb.append("<td align=middle>病假</td>");
                sb.append("<td align=middle>其他假</td>");
                sb.append("<td align=middle>小計</td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td></td>");
                break;
            case 1:
                sb.append("<td align=middle>遲到</td>");
                sb.append("<td align=middle>早退</td>");
                sb.append("<td align=middle>其他</td>");
                sb.append("<td>小計</td>");
                break;
            case 2:
                sb.append("<td align=middle>公假</td>");
                sb.append("<td align=middle>年假</td>");
                sb.append("<td align=middle>小計</td>");
                break;
            case 3:
                sb.append("<td align=middle>遲到</td>");
                sb.append("<td align=middle>早退</td>");
                sb.append("<td align=middle>其他</td>");
                sb.append("<td align=middle>小計</td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle>事假</td>");
                sb.append("<td align=middle>病假</td>");
                sb.append("<td align=middle>其他假</td>");
                sb.append("<td align=middle>小計</td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td></td>");
                break;
        }            
        sb.append("</tr>");
        return sb.toString();
    }

    String printHrMin(int min)
    {
        if (min==0) return "";
        if (min<60)
            return min + "分";
        int hr = 0;
        hr = min/60;
        min = min%60;

        StringBuffer sb = new StringBuffer();
        if (hr>0)
            sb.append(hr+"時");
        if (min>0)
            sb.append(min+"分");
        return sb.toString();
    }

    String getPaddingText(Vector<SchEvent> v,int[] size,Membr membr,String d1str,String d2str,int status,int type)
    {
        if (v==null) return "";
        int min = 0;
        for (int i=0; i<v.size(); i++)
            min += v.get(i).getTimeSpan();

        size[0]+=v.size();
        size[1]+=min;

        return v.size() + "次";            
    }

    String getPaddingText2(Vector<SchEvent> v,int[] size,Membr membr,String d1str,String d2str,int status,int type,Hashtable<String,String> ha,Map<String, Vector<Entry>> entryMap)
    {
        if (v==null) return "";

        StringBuffer sb=new StringBuffer("");
        int min = 0;
        for (int i=0; i<v.size(); i++){
            SchEvent se=v.get(i);

            sb.append((i+1)+". ");
   
            sb.append("缺勤時間:     \n     "+sdf2.format(se.getStartTime())+" "+sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime())+
                        "\n     ( 共:"+((se.getLastingHours()!=0)?se.getLastingHours()+"小時":"")+((se.getLastingMins()!=0)?se.getLastingMins()+"分鐘":""));
            sb.append(" )");    
            sb.append("\n");

            if(ha !=null){

                String cardidX=ha.get(sdf1.format(se.getStartTime()));

                if(cardidX !=null){

                    Vector<Entry> vEntry=entryMap.get(sdf1.format(se.getStartTime())+cardidX);

                    if(vEntry !=null && vEntry.size()>=2){
                        Entry en1=vEntry.get(0);
                        Entry en2=vEntry.get(vEntry.size()-1);

                        sb.append("     刷卡時間:\n     "+sdftime.format(en1.getCreated())+"-"+sdftime.format(en2.getCreated()));
                    }else if(vEntry==null || vEntry.size()==0){
                        sb.append("     沒有刷卡紀錄");
                    }else{
                        sb.append("     刷卡異常:\n     "+((vEntry.get(0)!=null)?sdftime.format(vEntry.get(0).getCreated()):""));
                    }
                }
                sb.append("\n");
            }
            min +=se.getTimeSpan();
        }

        size[0]+=v.size();
        size[1]+=min;

        return sb.toString();
    }
%>
<%@ include file="jumpTop.jsp"%>
<%
   int bunit=-1;
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    //int type = -1;
    //try { type = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date d1 = c.getTime();
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1); 
//    Date d2 = c.getTime();
    Date d2=new Date();
    try { d1 = sdf.parse(request.getParameter("sDate")); } catch (Exception e) {}
    try { d2 = sdf.parse(request.getParameter("eDate")); } catch (Exception e) {}
    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList("startTime>='" + sdf1.format(d1) + "' and startTime<'" + sdf1.format(nextEndDay) + "'", "");
    
    SchEventInfo info = new SchEventInfo(schevents);
    String d1str = java.net.URLEncoder.encode(sdf.format(d1));
    String d2str = java.net.URLEncoder.encode(sdf.format(d2));

    int showType=0;
    String showTypeS=request.getParameter("showType");
    if(showTypeS!=null)
        showType=Integer.parseInt(showTypeS);

    //出勤data
    ArrayList<Entry> entries = null;
    Map<String, Vector<Entry>> entryMap = null;
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");
    String readerId=SchEventInfo.getMachineId();
    
    entries = emgr.retrieveList("created>='" + sdf.format(d1) + "' and created<'" + 
        sdf.format(nextEndDay)+"' "+readerId, " order by created asc");
    entryMap = new SortingMap(entries).doSort("getDateCard");

    Vector alltable=new Vector();
    Vector row1=new Vector();

    //名稱
    StringCell sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setExcelCellattibute(10);
    sc.setCell("");
    row1.add(sc);

    switch(showType){
        case 0:
            sc=new StringCell();
            sc.setColspan(5);
            sc.setRowspan(0);
            sc.setExcelCellattibute(10);
            sc.setCell("未確認的缺勤(pending)");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(4);
            sc.setRowspan(0);
            sc.setCell("不扣薪缺勤");
            row1.add(sc);


            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(4);
            sc.setRowspan(0);
            sc.setCell("缺勤記錄");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(3);
            sc.setRowspan(0);
            sc.setCell("請假記錄");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("正式缺勤合計");
            row1.add(sc);

            break;
        case 1:
            sc=new StringCell();
            sc.setColspan(5);
            sc.setRowspan(0);
            sc.setCell("未確認的缺勤(pending)");
            row1.add(sc);

            break;
        case 2:
            sc=new StringCell();
            sc.setColspan(4);
            sc.setRowspan(0);
            sc.setCell("不扣薪缺勤");
            row1.add(sc);
            break;
        case 3:
            sc=new StringCell();
            sc.setColspan(4);
            sc.setRowspan(0);
            sc.setCell("缺勤記錄");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(3);
            sc.setRowspan(0);
            sc.setCell("請假記錄");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("");
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("正式缺勤合計");
            row1.add(sc);

            break;
    }

    alltable.add(row1);

    row1=new Vector();
    sc=new StringCell();
    sc.setColspan(0);
    sc.setRowspan(0);
    sc.setCell("");
    row1.add(sc);

    switch(showType){
            case 0:
                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("遲到");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("早退");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("不明原因");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("線上請假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(10);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(5);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("公假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("其他假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("年假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(10);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("遲到");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("早退");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("不明原因");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(10);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(5);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("事假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("病假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(5);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(15);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);
                break;
            case 1:
                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("遲到");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("早退");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("不明原因");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("線上請假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(10);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                break;
            case 2:
                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("公假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("其他假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("年假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(10);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);
                break;
            case 3:
                 sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("遲到");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("早退");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("不明原因");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(10);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(5);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("事假");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("病假");
                row1.add(sc);


                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(20);
                sc.setExcelAlign(1);
                sc.setCell("小計");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(5);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);

                sc=new StringCell();
                sc.setColspan(0);
                sc.setRowspan(0);
                sc.setExcelCellattibute(15);
                sc.setExcelAlign(1);
                sc.setCell("");
                row1.add(sc);
                break;
        }            

    alltable.add(row1);

    int k = 0;
    Iterator<Membr> iter = info.getMembrIterator();
    while (iter.hasNext()) {
        
        Membr membr = iter.next();
        if(bunit !=-1){
            if(membr.getBunitId() !=bunit)
                continue;
        }

        row1=new Vector();

        k++;
        Vector<SchEvent> events = info.getMembrEvents(membr);   
        Map<String,Vector<SchEvent>> statusTypeEventMap=new SortingMap(events).doSort("statusType");

        int size1[]=new int[2];  //pendding
        int size2[]=new int[2];  //不扣薪缺勤 
        int size3[]=new int[2];  //正式 - 缺勤
        int size4[]=new int[2];  //正式 - 請假

        Vector v=null;
        //membr 卡片資訊
        Hashtable<String,String> ha=CardMembr.getCardDate(d1,d2,membr);

        sc=new StringCell();
        sc.setColspan(0);
        sc.setRowspan(0);
        sc.setExcelAlign(1);
        sc.setCell(membr.getName());
        row1.add(sc);

        if(showType==0 || showType==1){

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_READER_PENDDING)+"#"+String.valueOf(SchEvent.TYPE_AB_START));

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size1,membr,d1str,d2str,SchEvent.STATUS_READER_PENDDING,SchEvent.TYPE_AB_START,ha,entryMap));
            row1.add(sc);                


            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_READER_PENDDING)+"#"+String.valueOf(SchEvent.TYPE_AB_ENDING));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size1,membr,d1str,d2str,SchEvent.STATUS_READER_PENDDING,SchEvent.TYPE_AB_ENDING,ha,entryMap));
            row1.add(sc);

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_READER_PENDDING)+"#"+String.valueOf(SchEvent.TYPE_NO_APPEAR));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size1,membr,d1str,d2str,SchEvent.STATUS_READER_PENDDING,SchEvent.TYPE_NO_APPEAR,ha,entryMap));
            row1.add(sc);

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_PENDDING)+"#0");
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size1,membr,d1str,d2str,SchEvent.STATUS_PERSON_PENDDING,SchEvent.TYPE_NO_APPEAR,ha,entryMap));
            row1.add(sc);


            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(((size1[0]!=0)?size1[0]+"次\n小計 :  "+printHrMin(size1[1]):""));
            row1.add(sc);
        }

        if(showType==0){
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setCell("");
            row1.add(sc);
        }

        if(showType==0 || showType==2){

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_BUSINESS));

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_BUSINESS,ha,entryMap));
            row1.add(sc);  

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_OTHER));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_OTHER,ha,entryMap));
            row1.add(sc);


            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_YEAR));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_YEAR,ha,entryMap));
            row1.add(sc);  

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(((size2[0]!=0)?size2[0]+"次 \n小計:"+printHrMin(size2[1]):""));
            row1.add(sc);
        }

        if(showType==0){
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setCell("");
            row1.add(sc);
        }

        if(showType==0 || showType==3){
        
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_AB_START));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size3,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_AB_START,ha,entryMap));
            row1.add(sc);


            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_AB_ENDING));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size3,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_AB_ENDING,ha,entryMap));
            row1.add(sc);

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_NO_APPEAR));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size3,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_NO_APPEAR,ha,entryMap));
            row1.add(sc);

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_NO_APPEAR));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(((size3[0]!=0)?size3[0]+" 次":""));
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell("+");
            row1.add(sc);

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_PERSONAL));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size4,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_PERSONAL,ha,entryMap));
            row1.add(sc);

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_SICK));
            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(getPaddingText2(v,size4,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_SICK,ha,entryMap));
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(((size4[0]!=0)?size4[0]+" 次":""));
            row1.add(sc);

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setCell("=");
            row1.add(sc);
            
            int totalSize=size3[0]+size4[0];

            sc=new StringCell();
            sc.setColspan(0);
            sc.setRowspan(0);
            sc.setExcelAlign(1);
            sc.setExcelVAlign(1);
            sc.setCell(((totalSize!=0)?totalSize+"次 \n小計:"+printHrMin(size3[1]+size4[1]):""));
            row1.add(sc);
        }

        alltable.add(row1);
    }
        
    String attribute=" border=1 width=95%";
    CellPrinter cp=CellPrinter.getInstance();

    String filename=String.valueOf(new Date().getTime());       
    String path=application.getRealPath("/")+"eSystem/exlfile/"+filename+".xls"; 

    BunitMgr bm=BunitMgr.getInstance();


    String showTitle=pd2.getPaySystemCompanyName();
    if(bunit !=-1){
        if(bunit==0){
            showTitle+=" 部門:未定 ";
        }else{
            Bunit bu=bm.find("id='"+bunit+"'");
            if(bu !=null)
                showTitle+=" 部門:"+bu.getLabel();
        }
    }
    
    showTitle+="  "+sdf.format(d1)+"-"+sdf.format(d2)+" 缺勤報表";
   
    cp.printExcel(path,showTitle,false,alltable);
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;缺勤統計 Excel</b>
</div> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>

<blockquote>
<a href="exlfile/<%=filename%>.xls"><img src="pic/excel2.png" border=0>&nbsp;下載excel檔</a>
</blockquote>