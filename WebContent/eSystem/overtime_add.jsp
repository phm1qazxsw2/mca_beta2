<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdfRequest=new SimpleDateFormat("yyyyMMdd");
    String requestDate=request.getParameter("d1");
    int bunit=-1;
    try{
        bunit=Integer.parseInt(request.getParameter("bunit"));
    }catch(Exception ex){}

    Date d1 = new Date(); //c.getTime();

    if(requestDate !=null)
        d1=sdfRequest.parse(requestDate);

    c.set(Calendar.HOUR_OF_DAY, 18);
    Date d2 = c.getTime();

    String note = "";
    int type = -2;

    String d1x="08:00";
    String d2x="16:00";

    int membrId=-1;
    String membrIdS=request.getParameter("membrId");

    if(membrIdS !=null)
        membrId=Integer.parseInt(membrIdS);
%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");

    String field = "target"; 

    ArrayList<YearHoliday> yh=YearHolidayMgr.getInstance().retrieveList("","order by id desc");

%>
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
    return true;
}

function doCheck(f)
{
    if (typeof f.target=='undefined' || typeof f.target.value=='undefined' || f.target.value.length==0) {
        alert("請選擇對象");
        return false;
    }
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

function changeTime(type){

    if(type==0){
        f1.xtime.disabled=false;
    }else{
        f1.xtime.disabled=true;
    }
}

</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>
&nbsp;登記加班</b>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
    <br>
    <center>

<form name="f1" action="overtime_add2.jsp" method="post" onsubmit="return doCheck(this);">
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    對象 
                    </td>
                    <td>
                        <% 
                            String extra = "checkScheduleBoundary();";
                        %>
                        <%@ include file="schedule_target_setup.jsp"%>
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
                     <span id="time1">加班時間</span>
                    </td>
                    <td>
            起:<input type=text name=d1 value=<%=d1x%> size=1> 至:<input type=text name=d2 value=<%=d2x%> size=1>
                    </td>
                    </div>
                </tr>
<%
    if(yh.size()==1){

        YearHoliday yhh=yh.get(0);
%>
        <input type=hidden name="yearHolidayId" value="<%=yhh.getId()%>">

<%
    }else{
%>
      <tr bgcolor=#ffffff class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0>
            年度區間
            </td>
            <td>
                <select name="yearHolidayId">
            <%
                for(int i=0;i<yh.size();i++){
                    YearHoliday yhx=yh.get(i);
            %>  
                <option value="<%=yhx.getId()%>"><%=yhx.getName()%></option>
            <%  }   %>
                </select>
            </td>
        </tr>

<%  }   %>
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
                    </td>
                </tr>

                <tr class=es02>
                    <td bgcolor=#f0f0f0>
                    補休時數倍率 
                    </td>
                    <td bgcolor="#ffffff">
                        <select name="xtime" selected>
                            <option value="0">1.0 倍</option>                                
                            <option value="1">1.2 倍</option>                                
                            <option value="2">1.5 倍</option>                                
                        </select>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    覆核內容 
                    </td>
                    <td>
                        <textarea name="confirmPs" cols=30 rows=2></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan=2 align=middle bgcolor='#ffffff'>    
                        <input type=submit name="submit" value="新增加班">
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
    </form>

    </center>


</body>



<%
    if(membrId != -1){

        Membr memX=MembrMgr.getInstance().find(" id= '"+membrId+"'");
%>
    <script>
            setTarget_<%=field%>('<%=membrId%>','<%=memX.getName()%>');
    </script>

<%  }   %>