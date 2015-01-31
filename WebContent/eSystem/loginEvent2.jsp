<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%
    String indexId=request.getParameter("indexId").trim();

    if(indexId ==null || indexId.length()!=5)
    {
        response.sendRedirect("loginEvent.jsp?r=1");
        return;
    }

    MembrTeacherMgr mtm=MembrTeacherMgr.getInstance();
    
    String query=" teacherIdNumber like '%"+indexId + "'";
    ArrayList<MembrTeacher> am=mtm.retrieveList(query,"");

    if(am==null || am.size()<=0)
    {
        response.sendRedirect("loginEvent.jsp?r=2");
        return;
    }


    MembrTeacher mt=am.get(0);   

    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdfRequest=new SimpleDateFormat("yyyyMMdd");
    String requestDate=request.getParameter("d1");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");

    int membrId=mt.getMembrId();
    int bunit=0;
    int et=2;
    String field = "target";
    int type = -2;
    int hours = 0;
    int mins = 0;
    String note = "";

    Date d1 = new Date(); //c.getTime();

    if(requestDate !=null)
        d1=sdfRequest.parse(requestDate);

    c.set(Calendar.HOUR_OF_DAY, 18);
    Date d2 = c.getTime();

    String extra = "checkScheduleBoundary();";

%>
<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=mt.getName()%></b>&nbsp;&nbsp;  線上請假 | 
    <a href="loginOvertime.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">加班登記</a> |
    <a href="searchEvent.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">缺勤/請假紀錄</a>
    |
    <a href="searchCard.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | <a href="searchYearHoliday.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">年假/補休查詢</a>
    | <a href="loginTeacherEmail.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">刷卡Email</a>
    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<script src="js/dateformat.js"></script>
<script src="js/formcheck.js"></script>
<script src="js/string.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>

<script>
var totalTime="";

function checkTime(xx){

    var runstart=eval(xx*10);
    document.f1.d1.value=totalTime.substring(runstart,(runstart+5));
    document.f1.d2.value=totalTime.substring((runstart+5),(runstart+10));                
}

function checkScheduleBoundary()
{

        if (typeof document.f1.target=='undefined' || 
            typeof document.f1.target.value=='undefined' || !IsNumeric(document.f1.target.value)){
         
           find_target_<%=field%>();
           return;
        }
        var s = document.f1.type;
        var date = document.f1.startTime.value;
        var mid = document.f1.target.value;
        var tp = s.options[s.selectedIndex].value;

        

        var url ="schedule_boundary_et2.jsp?"+
            "&date=" + encodeURI(date) + "&mid=" + mid +
            "&r=" + new Date().getTime();
        var req = new XMLHttpRequest();

        if (req) 
        {
            req.onreadystatechange = function() 
            {
                if (req.readyState == 4 && req.status == 200) 
                {
                    var text = document.getElementById("time_text");
                    var str = "";
                    
                    var lines2 = req.responseText;

                    if(lines2 ==null || lines2.length<=5){
                        document.f1.xbptton.disabled=true;
                        text.innerHTML = "本日沒有班表";
                    }else{

                        var lines =lines2.split("\n");
                        var nowChecked=true;

                        for (var i=0,j=0; i<lines.length; i++) {
                            var l = trim(lines[i]);
                            if (l.length==0) continue;
                            var tokens = l.split(",");
                            var runCheck="";

                            if(tokens[5].indexOf('0')!=-1){
                                runCheck="disabled";
                                
                            }

                            str += "<input type=radio name=boundaryTime value='"+tokens[0]+"'"+((nowChecked)?" checked":"")+" onClick='checkTime("+j+")' "+runCheck+" >" +tokens[1]+"<br>\n";

                            if(tokens[5].indexOf('0')==-1){
                                if(nowChecked){
                                    document.f1.d1.value=tokens[2];
                                    document.f1.d2.value=tokens[3];
                                    nowChecked=false;
                                    document.f1.xbptton.disabled=false;
                                }
                            }                           
                            totalTime+=tokens[4];
                            j++;
                        }
                        text.innerHTML = str;
                    }

                    if(nowChecked){
                        document.f1.xbptton.disabled=true;
                    }

                    if(document.f1.type.value==<%=SchEvent.TYPE_PERSONAL%>){
                        alert('事假必須於三天前提出申請.');
                    }
                }
            }
        };
        req.open('GET', url);
        req.send(null);        
}

function doCheck(f)
{
    if (typeof f.target=='undefined' || typeof f.target.value=='undefined' || f.target.value.length==0) {
        alert("請選擇對象");
        return false;
    }
    var s = f.type;
    if (s.options[s.selectedIndex].value==-1) {
        alert("請輸入一事由");
        f.type.focus();
        return false;
    }
    var timepattern ="yyyy/MM/dd";
    var timepattern2 ="HH:mm";
    if (!isDate(f.startTime.value, timepattern)) {
        alert("請輸入正確的開始時間");
        f.startTime.focus();
        return false;
    }

    if (!isDate(f.d1.value, timepattern2)) {
        alert("請輸入正確的結束時間");
        f.d1.focus();
        return false;
    }

    if (!isDate(f.d2.value, timepattern2)) {
        alert("請輸入正確的結束時間");
        f.d2.focus();
        return false;
    }
    return true;
}


function find_target_<%=field%>()
{
    openwindow_phm2('schedule_find_target.jsp?field=<%=field%>&bunit=<%=bunit%>','設定對象',400,500,'settarget<%=field%>');
}

function setTarget_<%=field%>(id, name)
{
    var sdiv = document.getElementById('<%=field%>');
    sdiv.innerHTML = "<input type=hidden name=<%=field%> value=" + id + ">" + name;
    <%=extra%>
}


</script>


<body>
    <br>
    <center>

    <form name="f1" action="loginEvent3.jsp" method="post" onsubmit="return doCheck(this);">
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    對象 
                    </td>
                    <td>
                        <div class=es02 name="<%=field%>" id="<%=field%>">請選擇對象</div>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    缺勤事由
                    </td>
                    <td>
                        <select name="type" onchange="checkScheduleBoundary();">

                        <option value="<%=SchEvent.TYPE_SICK%>" <%=(type==SchEvent.TYPE_SICK)?"selected":""%>>病&nbsp;&nbsp;&nbsp;假&nbsp;(扣薪)</option> 
                        <option value="<%=SchEvent.TYPE_PERSONAL%>" <%=(type==SchEvent.TYPE_PERSONAL)?"selected":""%>>事&nbsp;&nbsp;&nbsp;假&nbsp;(扣薪)</option>                         
                        <option value="<%=SchEvent.TYPE_BUSINESS%>" <%=(type==SchEvent.TYPE_BUSINESS)?"selected":""%>>公&nbsp;&nbsp;&nbsp;假&nbsp;(不扣薪,不扣年假)</option>
                        <option value="<%=SchEvent.TYPE_NO_APPEAR%>" <%=(type==SchEvent.TYPE_NO_APPEAR)?"selected":""%>>其他假&nbsp;(不扣薪,不扣年假)</option>  
                        <option value="<%=SchEvent.TYPE_YEAR%>" <%=(type==SchEvent.TYPE_YEAR)?"selected":""%>>年&nbsp;&nbsp;&nbsp;假&nbsp;(不扣薪,扣年假)</option>
                        <option value="<%=SchEvent.TYPE_OVERTIME%>" <%=(type==SchEvent.TYPE_OVERTIME)?"selected":""%>>補&nbsp;&nbsp;&nbsp;休&nbsp;(不扣薪,扣補休時數)</option>
                        </select>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    日期
                    </td>
                    <td>
                        <input type=text name="startTime" value="<%=sdf1.format(d1)%>" size=8 onChange="checkScheduleBoundary();">
                        <a href="#" onclick="displayCalendar(document.f1.startTime,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        請假班別
                    </td>
                    <td>
                        <span id="time_text"></span>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                     <span id="time1">請假時間</span>
                    </td>
                    <td>
            起:<input type=text name=d1 value=<%=hours%> size=5>
            至:<input type=text name=d2 value=<%=mins%> size=5>
                    </td>
                    </div>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    補充說明 
                    </td>
                    <td>
                        <textarea name="note" cols=30 rows=4><%=note%></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle bgcolor='#ffffff'>    
                        <div id="desc"></div>
                        <input type=hidden name="restMins" value="0">
                        <input type=hidden name="indexId" value="<%=indexId%>">

                    <%  if(et ==2){ %> 
                        <input type=submit name="submit" value="新增請假" name="xbptton" id="xbptton" disabled>
                    <%  }else{  %>
                        <input type=submit name="submit" value="新增缺勤" name="xbptton" id="xbptton" disabled>
                    <%  }   %>
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
        </form>
    </center>
</body>

<script>
    setTarget_<%=field%>('<%=mt.getMembrId()%>','<%=mt.getName()%>')
</script>