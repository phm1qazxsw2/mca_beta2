<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,cardreader.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<script type="text/javascript" src="openWindow.js"></script>
<link rel="stylesheet" href="menu.css" type="text/css">
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<%!
    String switchDay(int day){

        switch(day){
            case 0:
                return "日";
            case 1:
                return "一";
            case 2:
                return "二";
            case 3:
                return "三";
            case 4:
                return "四";
            case 5:
                return "五";
            case 6:
                return "六";
        }
        return "";
    }

%>
<%
    EntryMgr emgr = EntryMgr.getInstance();
    emgr.setDataSourceName("card");


    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
    SimpleDateFormat sdf3 = new SimpleDateFormat("yyyyMMdd");
    SimpleDateFormat sdftime = new SimpleDateFormat("HH:mm");

    String mid=request.getParameter("mid");
    Membr membr = MembrMgr.getInstance().find("id=" +mid );

    Calendar c = Calendar.getInstance();
    c.set(Calendar.DAY_OF_MONTH, 1);

    Date d1 = c.getTime(); //sdf1.parse("2009/01/01");
    Date d2 = new Date();  // sdf1.parse(request.getParameter("d2"));
    
    try { d1 = sdf1.parse(request.getParameter("d1")); } catch (Exception e) {}
    try { d2 = sdf1.parse(request.getParameter("d2")); } catch (Exception e) {}

    c.setTime(d2);
    c.add(Calendar.DATE, 1);
    Date nextEndDay = c.getTime();
    String readerId=SchEventInfo.getMachineId();


        // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf.format(d1) + "' and created<'" + sdf.format(nextEndDay) + "' and membrId='"+mid+"'", " order by created");
    Map<String, Entryps> pssMap = new SortingMap(pss).doSortSingleton("getCreatedString");


    Hashtable ha=CardMembr.getCardDate(d1,d2,membr);
    String indexId=request.getParameter("indexId").trim();

%>
    <div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=membr.getName()%></b>&nbsp;&nbsp;  
    <a href="loginEvent2.jsp?mid=<%=mid%>&indexId=<%=indexId%>">線上請假</a> | 
    <a href="loginOvertime.jsp?mid=<%=mid%>&indexId=<%=indexId%>">加班登記</a> |
    <a href="searchEvent.jsp?mid=<%=mid%>&indexId=<%=indexId%>">缺勤/請假紀錄</a>
    | 刷卡紀錄
    | <a href="searchYearHoliday.jsp?mid=<%=mid%>&indexId=<%=indexId%>">年假/補休查詢</a>
    | <a href="loginTeacherEmail.jsp?mid=<%=mid%>&indexId=<%=indexId%>">刷卡Email</a>

    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
    </div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<div class=es02>
    <blockquote>
        <form action="searchCard.jsp" name='f1' id='f1' method="post" onsubmit="return doSubmit(this)">
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>刷卡紀錄</b>&nbsp;&nbsp;
        <a href="#" onclick="displayCalendar(document.f1.d1,'yyyy/mm/dd',this);return false">起始日期:</a><input type=text name="d1" value="<%=sdf1.format(d1)%>" size=8> &nbsp;&nbsp;
        <a href="#" onclick="displayCalendar(document.f1.d2,'yyyy/mm/dd',this);return false">至:</a><input type=text name="d2" value="<%=sdf1.format(d2)%>" size=8>

        <input type=hidden name="indexId" value="<%=indexId%>">        
        <input type=hidden name="mid" value="<%=mid%>">
        <input type=submit value="查詢">
        </form>
    </blockquote>
</div>

<%
    
    UserMgr um=UserMgr.getInstance();
	int duringDate=(int)((d2.getTime()-d1.getTime())/(long)(1000*60*60*24));
	c.setTime(d1);
    for(int j=0;j<(duringDate+1);j++){

        Date nowDate=c.getTime();		
		c.add(Calendar.DATE,1);
        Date nextDay=c.getTime();

        String dateString=sdf1.format(nowDate);    
        String cardIdX=(String)ha.get(dateString);

        if(cardIdX==null){   
           continue;
        }

        String newdatestring=sdf3.format(nowDate);
        Entryps ep=pssMap.get(newdatestring);
%>

    <font class=es02>&nbsp;&nbsp;&nbsp;&nbsp;<img src="img/flag2.png" border=0>&nbsp;<b><%=sdf.format(nowDate)%></b> &nbsp;(<%=switchDay(nowDate.getDay())%>)

<%
        ArrayList<Entry> ens=emgr.retrieveList("cardId='"+cardIdX+"' and '"+sdf.format(nowDate)+"' <=created and created<'"+sdf.format(nextDay)+"'"+readerId,"order by created asc");



        if(ens !=null && ens.size()>0){
    
        for(int i=0;i<ens.size();i++){
            Entry nen=(Entry)ens.get(i);
            int k=i+1;

            User u=null;
            if(nen.getDatauser()!=0)
                u=(User)um.find(nen.getDatauser());
%>
    [時間: <%=sdftime.format(nen.getCreated())%> <%=(u==null)?"機號:"+nen.getMachineId():u.getUserFullname()%>]
<%
        }
    }else{   %>
    沒有刷卡記錄.
<%  
    }  
%>
<%
    if(ep==null){
%>
&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:openwindow_phm('addEntryps_m.jsp?membrId=<%=mid%>&d=<%=newdatestring%>', '註記', 400, 300, 'addevent');return false">新增註記</a>
    <br><br>
<%  }else{  %>
&nbsp;&nbsp;&nbsp;&nbsp;<%=ep.getPs()%>
<a href="#" onClick="javascript:openwindow_phm('addEntryps_m.jsp?membrId=<%=mid%>&d=<%=newdatestring%>', '註記', 400, 300, 'addevent');return false">編輯註記</a>
    <br><br>
<%  }   %>




<%
    } 
%>

