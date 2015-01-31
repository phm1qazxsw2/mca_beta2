<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%!
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String getTableHeaderInfo(int showType,String d1str,String d2str,int bunit)
    {
        StringBuffer sb = new StringBuffer();
        sb.append("<tr bgcolor=\"#FFFF66\" class=es02>");
        sb.append("<td align=middle bgcolor='#ffffff'>&nbsp;<br>&nbsp;</td>");

        switch(showType){
            case 0:
                sb.append("<td align=middle colspan=2 bgcolor='#ffffff'><img src='images/dotx.gif' border=0>&nbsp;未確認缺勤(pending)<br><div align=right><a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=1\">明細</a></div></td>");
                sb.append("<td align=middle bgcolor='#ffffff'></td>");
                sb.append("<td align=middle colspan=5 bgcolor='#99CCFF'><b>不扣薪缺勤</b><br><div align=right><a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=2\">明細</a></div></td>");
                sb.append("<td bgcolor='#ffffff'></td>");
                sb.append("<td align=middle colspan=4><b>扣薪缺勤合計</b><br><div align=right><a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=3\">明細</a></div></td>");
                break;
            case 1:
                sb.append("<td align=middle colspan=2 bgcolor='#ffffff'><img src='images/dotx.gif' border=0>&nbsp;未確認缺勤(pending)<br></td>");
                break;
            case 2:
                sb.append("<td align=middle colspan=5 bgcolor='#99CCFF'><b>不扣薪缺勤</b><br></td>");
                break;
            case 3:
                sb.append("<td align=middle colspan=4><b>扣薪缺勤合計</b></td>");
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
                sb.append("<td align=middle nowrap>系統產生</td>");
                sb.append("<td align=middle nowrap>線上請假</td>");
                sb.append("<td bgcolor='#ffffff'>&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;公假&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;其他假&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;年假&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;補休&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;小計&nbsp;&nbsp;</td>");
                sb.append("<td bgcolor='#ffffff'>&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;缺勤&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;事假&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;病假&nbsp;&nbsp;</td>");
                sb.append("<td align=middle nowrap>&nbsp;&nbsp;小計&nbsp;&nbsp;</td>");
                break;
            case 1:
                sb.append("<td align=middle nowrap>系統產生</td>");
                sb.append("<td align=middle nowrap>線上請假</td>");
                break;
            case 2:
                sb.append("<td align=middle nowrap>公假</td>");
                sb.append("<td align=middle nowrap>其他假</td>");
                sb.append("<td align=middle nowrap>年假</td>");
                sb.append("<td align=middle nowrap>補休</td>");
                sb.append("<td align=middle nowrap>小計</td>");
                break;
            case 3:
                sb.append("<td align=middle nowrap>缺勤</td>");
                sb.append("<td align=middle nowrap>事假</td>");
                sb.append("<td align=middle nowrap>病假</td>");
                sb.append("<td align=middle nowrap>小計</td>");
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

    String getPaddingText(Vector<SchEvent> v,int[] size)
    {
        if (v==null) return "";
        int min = 0;
        for (int i=0; i<v.size(); i++)
            min += v.get(i).getTimeSpan();

        size[0]+=v.size();
        size[1]+=min;

        return v.size() + "次<br>"+printHrMin(min);
    }

    String getPaddingText2(Vector<SchEvent> v,int[] size,Membr membr,String d1str,String d2str,int status,int type,Hashtable<String,String> ha,Map<String, Vector<Entry>> entryMap,Map<String, Entryps> pssMap)
    {
        if (v==null) return "";

        StringBuffer sb=new StringBuffer("");
        int min = 0;
        for (int i=0; i<v.size(); i++){
            SchEvent se=v.get(i);

            sb.append((i+1)+". ");

            sb.append("<font color=blue>"+SchEvent.getChinsesType(se.getType())+"</font>:"+sdf2.format(se.getStartTime()));
            sb.append("("+SchInfo.printDayOfWeek(se.getStartTime().getDay()+1)+")");

            sb.append(" "+sdftime.format(se.getStartTime())+"-"+sdftime.format(se.getEndTime()));
            sb.append("<a href=\"#\" onClick=\"javascript:openwindow_phm('modifySchEvent.jsp?seId="+se.getId()+"', '修改出缺勤', 500, 420, 'addevent');return false\">");
            sb.append(" ("+((se.getLastingHours()!=0)?se.getLastingHours()+"時":"")+((se.getLastingMins()!=0)?se.getLastingMins()+"分":""));
            sb.append(")</a>");

            sb.append("<br>");
            if(ha !=null){

                sb.append("&nbsp;&nbsp;&nbsp;&nbsp;");

                String cardidX=ha.get(sdf1.format(se.getStartTime()));

                if(cardidX !=null){

                    Vector<Entry> vEntry=entryMap.get(sdf1.format(se.getStartTime())+cardidX);

                    if(vEntry !=null && vEntry.size()>=2){
                        Entry en1=vEntry.get(0);
                        Entry en2=vEntry.get(vEntry.size()-1);

                        sb.append("刷卡時間:"+sdftime.format(en1.getCreated())+"-"+sdftime.format(en2.getCreated()));
                    }else if(vEntry==null || vEntry.size()==0){
                        sb.append("沒有刷卡紀錄");
                    }else{
                        sb.append("刷卡異常:"+((vEntry.get(0)!=null)?sdftime.format(vEntry.get(0).getCreated()):""));
                    }
                }
                sb.append("<br>");
            }
            min +=se.getTimeSpan();

            Entryps eps=pssMap.get(sdf3.format(se.getStartTime())+"#"+String.valueOf(membr.getId()));
            if(eps !=null){
                sb.append("&nbsp;&nbsp;&nbsp;&nbsp;註記:"+eps.getPs()+"<br>");
            }
        }




        size[0]+=v.size();
        size[1]+=min;

        return sb.toString();            
    }
%>
<%
    int topMenu=6;
    int leftMenu=3;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    int bunit=(ud2.getUserBunitCard()==0)?-1:ud2.getUserBunitCard();
    String bunitS=request.getParameter("bunit");        
    if(bunitS !=null)
        bunit=Integer.parseInt(bunitS); 

    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws.getBunitSpace("buId"));

    //int type = -1;
    //try { type = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}
    //Date d2 = c.getTime();
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd");
    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);
    Date d1 = c.getTime();
    c.add(Calendar.MONTH, 1);
    c.add(Calendar.DATE, -1); 

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


    // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf1.format(d1) + "' and created<'" + sdf1.format(nextEndDay) + "'", " order by created");
    Map<String, Entryps> pssMap = new SortingMap(pss).doSortSingleton("getDateMembr");


%>
<%@ include file="leftMenu6_sch.jsp"%>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/event1.png" border=0>&nbsp;缺勤統計</b>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
<%=(showType==0)?"全部統計":"<a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=0\">全部統計</a>"%>
 | <%=(showType==1)?"未確認缺勤":"<a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=1\">未確認缺勤</a>"%>
 | <%=(showType==2)?"不扣薪缺勤":"<a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=2\">不扣薪缺勤</a>"%>
 | <%=(showType==3)?"扣薪缺勤":"<a href=\"schedule_event2.jsp?sDate="+d1str+"&eDate="+d2str+"&bunit="+bunit+"&showType=3\">扣薪缺勤</a>"%>
</div>
<div class=es02>
<form action="schedule_event2.jsp" name='f1' id='f1' method="get" onsubmit="return doSubmit(this)">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.sDate,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="sDate" value="<%=sdf.format(d1)%>" size=8> &nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.f1.eDate,'yyyy/mm/dd',this);return false">至:</a><input type=text name="eDate" value="<%=sdf.format(d2)%>" size=8>
    &nbsp;&nbsp;
<%
    if(b !=null && b.size()>0){
%>
    部門: <select name="bunit" size=1  onChange="javascript:changeAction2(this.value)">
                <option value="-1" <%=(bunit==-1)?"selected":""%>>全部</option>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>未定</option>
            </select>
<%
    }else{
%>
        <input type=hidden name="bunit" value="-1">
<%  }   %>

    &nbsp;&nbsp;
    <input type=hidden name="showType" value="<%=showType%>">
    <input type=submit value="查詢">
</form>
</div>
 

<form name="f">
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;
<a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=1&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent2.png" border=0>&nbsp;登記缺勤</a> | <a href="javascript:openwindow_phm2('schedule_event_add.jsp?et=2&bunit=<%=bunit%>', '登記缺勤請假', 800, 600, 'addevent');"><img src="pic/addevent.png" border=0>&nbsp;登記請假</a>

<%
/*
%>
 | <a href="#" onClick="javascript:openwindow_phm('schedule_detail_excel_output3.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&bunit=<%=bunit%>&showType=<%=showType%>', '缺勤統計 Excel', 400, 320, 'addevent');return false"><img src="pic/excel2.png" border=0>&nbsp;輸出excel</a>
<%  
*/
%>
<%
/*
    if(showType==1){
%>
<br>&nbsp;&nbsp;&nbsp;&nbsp;<img src="images/dotx.gif" border=0> &nbsp;將尚未確認(pendding)的缺勤資料
<a href="delete_schedule_daily_reader.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&bunit=<%=bunit%>" onClick="return(confirm('確認刪除全部pendding的缺勤資料?'))">全部刪除</a> or 
<a href="confirm_schedule_daily_reader.jsp?d1=<%=sdf.format(d1)%>&d2=<%=sdf.format(d2)%>&bunit=<%=bunit%>"  onClick="return(confirm('確認全部pendding缺勤轉為正式缺勤?'))">全部確認</a>
<%
    }
*/
%>
</div>

<br>
<%
    if (schevents.size()==0) {
%>
    <div class=es02>
    &nbsp;&nbsp;&nbsp;&nbsp;區段內無出缺勤請假資料.
    </div>
    <%@ include file="bottom.jsp"%>
<%
        return;
    }
%>
<div class=es02 align=center>
依名單排序| <a href="schedule_detail_excel.jsp?sDate=<%=d1str%>&eDate=<%=d2str%>&bunit=<%=bunit%>&showType=<%=showType%>">依日期排序</a>

</div>
<blockquote>
<table height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <%=getTableHeaderInfo(showType,d1str,d2str,bunit)%>
<%
    int k = 0;
    Iterator<Membr> iter = info.getMembrIterator();
    while (iter.hasNext()) {
        Membr membr = iter.next();

        if(bunit !=-1){
            if(membr.getBunitId() !=bunit)
                continue;
        }

        if (k%7==0)
            out.println(getTableHeader(showType));

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
%>

    <tr bgcolor=#ffffff align=center valign=middle>
        <td class=es02 nowrap align=left bgcolor="#f0f0f0">
            <%=membr.getName()%><BR>
<a href="javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid=<%=membr.getId()%>&d1=<%=d1str%>&d2=<%=d2str%>&stutus=-1', '出缺勤記錄', 800,600,'scheventmembr');">全部明細</a>
        </td>
        
    <%
    if(showType==0 || showType==1){
    %>

        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_READER_PENDDING)+"#0");
            
            if(showType==0){
                String xtext=getPaddingText(v,size1);

                if(size1[1]>0){
%>
<a href="javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid=<%=membr.getId()%>&d1=<%=d1str%>&d2=<%=d2str%>&stutus=1', '未確認的缺勤', 800,600,'scheventmembr');">            
<%
                }
                out.println(xtext);
                if(size1[1]>0){
                    out.println("</a>");
                }                   

            }else{
                out.println(getPaddingText2(v,size1,membr,d1str,d2str,SchEvent.STATUS_READER_PENDDING,SchEvent.TYPE_AB_START,ha,entryMap,pssMap));
            }
            if(size1[1]>0)
                out.println("</a>");
        %>
            

        </td>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%

            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_PENDDING)+"#0");

            if(showType==0){                

                String xtext=getPaddingText(v,size1);

                if(size1[1]>0){
        %>
                <a href="javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid=<%=membr.getId()%>&d1=<%=d1str%>&d2=<%=d2str%>&stutus=1', '未確認的缺勤', 800,600,'scheventmembr');">            
        <%
                }
                out.println(xtext);
                if(size1[1]>0)
                    out.println("</a>");
            }else{
                out.println(getPaddingText2(v,size1,membr,d1str,d2str,SchEvent.STATUS_PERSON_PENDDING,SchEvent.TYPE_PERSONAL,ha,entryMap,pssMap));
            }
        %>
        </td>
<%
    }
    if(showType==0){
%>
        <td class=es02></td>
<%
    }

    if(showType==0 || showType==2){
%>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_BUSINESS));
            if(showType==0)
                out.println(getPaddingText(v,size2));
            else
                out.println(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_BUSINESS,ha,entryMap,pssMap));
        %>
        </td>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_OTHER));

            if(showType==0)
                out.println(getPaddingText(v,size2));
            else
                out.println(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_OTHER,ha,entryMap,pssMap));
        %>
        </td>

        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_YEAR));

            if(showType==0)
                out.println(getPaddingText(v,size2));
            else
                out.println(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_YEAR,ha,entryMap,pssMap));
        %>
        </td>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_OVERTIME));

            if(showType==0)
                out.println(getPaddingText(v,size2));
            else
                out.println(getPaddingText2(v,size2,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_OVERTIME,ha,entryMap,pssMap));
        %>
        </td>
        <td class=es02 align=right nowrap>
            <%=(size2[0]!=0)?"<font color=blue>"+size2[0]+"次</font> <br><a href=\"javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid="+membr.getId()+"&d1="+d1str+"&d2="+d2str+"&stutus=2', '出缺勤記錄', 800,600,'scheventmembr');\">"+printHrMin(size2[1])+"</a>":""%>
        </td>
<%
    }

    if(showType==0){
%>
        <td class=es02 align=right nowrap>
        </td>
<%  }   

    if(showType==0 || showType==3){
%>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_AB_START));

            if(showType==0)
                out.println(getPaddingText(v,size3));
            else
                out.println(getPaddingText2(v,size3,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_AB_START,ha,entryMap,pssMap));
        %>
        </td>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_PERSONAL));

            if(showType==0)
                out.println(getPaddingText(v,size4));
            else
                out.println(getPaddingText2(v,size4,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_PERSONAL,ha,entryMap,pssMap));
        %>
        </td>
        <td class=es02 align=<%=(showType==0)?"right":"left"%> nowrap valign=top>
        <%
            v=statusTypeEventMap.get(String.valueOf(SchEvent.STATUS_PERSON_CONFORM)+"#"+String.valueOf(SchEvent.TYPE_SICK));

            if(showType==0)
                out.println(getPaddingText(v,size4));
            else
                out.println(getPaddingText2(v,size4,membr,d1str,d2str,SchEvent.STATUS_PERSON_CONFORM,SchEvent.TYPE_SICK,ha,entryMap,pssMap));
        %>
        </td>
        <%
            int totalSize=size3[0]+size4[0];
        %>
        <td class=es02 nowrap align=right valign=top>
            <%=(totalSize!=0)?"<font color=blue>"+totalSize+"次</font> <br><a href=\"javascript:openwindow_phm2 ('schedule_event_membr.jsp?mid="+membr.getId()+"&d1="+d1str+"&d2="+d2str+"&stutus=3', '出缺勤記錄', 800,600,'scheventmembr');\">"+printHrMin(size3[1]+size4[1])+"</a>":"無扣薪缺勤"%>
        </td>

<%
    }  //end showType =3
%>
    </tr>	
<%
    }
%>
    </table> 

</td>
</tr>
</table>
</form>
</blockquote>
<br>
<br>
<%@ include file="bottom.jsp"%>
