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


    Date d1 = new Date(); //c.getTime();
    MembrTeacher mt=am.get(0);   
    int membrId=mt.getMembrId();
    int teacherId=mt.getTeacherId();
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");

    ArrayList<YearHoliday> yh=YearHolidayMgr.getInstance().retrieveList("","order by id desc");

    Teacher2Mgr ttm=Teacher2Mgr.getInstance();
    Teacher2 tea=ttm.find("id='"+teacherId+"'");

    String d1x="08:00";
    String d2x="16:00";

%>
<script src="js/dateformat.js"></script>
<script src="js/formcheck.js"></script>
<script src="js/string.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<script>
var totalTime="";

function checkTime(xx){

    var runstart=eval(xx*10);
    document.f1.d1.value=totalTime.substring(runstart,(runstart+5));
    document.f1.d2.value=totalTime.substring((runstart+5),(runstart+10));                
}

function checkScheduleBoundary()
{
    return true;
}

function doCheck(f)
{
   
    var s = f.type;

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

    if(confirm("確認新增此加班?")){
        return true;
    }else{
        return false;
    }        
}
</script>
<div class=es02>
    &nbsp;&nbsp;&nbsp;<b><%=mt.getName()%></b>&nbsp;&nbsp;  
    <a href="loginEvent2.jsp?indexId=<%=indexId%>">線上請假</a> | 加班登記 |
    <a href="searchEvent.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">缺勤/請假紀錄</a> |
    <a href="searchCard.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">刷卡紀錄</a>
    | <a href="searchYearHoliday.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">年假/補休查詢</a>
    | <a href="loginTeacherEmail.jsp?mid=<%=membrId%>&indexId=<%=indexId%>">刷卡Email</a>
    &nbsp;　　　　<a href="javascript:parent.sch_qa(1);">Q&A</a>
</div>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<br>
<blockquote>
    <form name="f1" action="loginOvertime2.jsp" method="post" onsubmit="return doCheck(this);">
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
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
                     <span id="time1">加班時間</span>
                    </td>
                    <td>
            起:<input type=text name=d1 value=<%=d1x%> size=1> 至:<input type=text name=d2 value=<%=d2x%> size=1>
                    </td>
                    </div>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    加班註記 
                    </td>
                    <td>
                        <textarea name="ps" cols=30 rows=2></textarea>
                    </td>
                </tr>
                
                
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    專換方式 
                    </td>
                    <td>
                        <input type=radio name="confirmType" value=0 checked>轉換為補休時數
                        <input type=radio name="confirmType" value=1>轉換為加班薪資
                        (僅作為覆核時的參考)
                    </td>
                </tr>

                <tr class=es02>
                    <td bgcolor=#f0f0f0>
                    補休時數倍率 
                    </td>
                    <td bgcolor="#ffffff">
                        <select name="xtime">
                            <option value="0">1.0 倍</option>                                
                            <option value="1">1.2 倍</option>                                
                            <option value="2">1.5 倍</option>                                
                        </select>
                        (僅作為覆核時的參考)
                    </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle>
                        <input type=hidden name="target" value="<%=membrId%>">
                        <input type=hidden name="indexId" value="<%=indexId%>">
                        <input type=submit value="線上申請">                            
                    </td>
                </tr>
            </table>
        </td>
        </tr>
        </table>

</blockquote>

