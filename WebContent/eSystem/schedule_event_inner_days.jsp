<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy/MM/dd");
    int et = Integer.parseInt(request.getParameter("et")); // 1:請假加班  2:超缺勤

    String field = "target"; 
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

        if (typeof document.f1.target=='undefined' || 
            typeof document.f1.target.value=='undefined' || !IsNumeric(document.f1.target.value)){
         
            find_target_<%=field%>();
           return;
        }
        var s = document.f1.type;
        var date = document.f1.startTime.value;
        var date2 = document.f1.endTime.value;
        var mid = document.f1.target.value;
        var tp = s.options[s.selectedIndex].value;

        

        var url ="schedule_boundary_et2_days.jsp?"+
            "&date=" + encodeURI(date)+"&date2=" + encodeURI(date2) + "&mid=" + mid +
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

                            str += "<input type=checkbox name=boundaryTime value='"+tokens[0]+"' onClick='checkTime("+j+")' "+runCheck+" >" +tokens[1]+"<br>\n";
                            
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

</script>
<body>
<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>
<% if (et==1) { %>
<img src="pic/addevent.png" border=0>&nbsp;登記缺勤</b>
<% } else { %>
<img src="pic/addevent.png" border=0>&nbsp;登記多日請假</b>&nbsp;&nbsp;&nbsp;

    <a href="schedule_event_add.jsp?et=1<%=(membrId!=-1)?"&membrId="+membrId:""%>&bunit=<%=bunit%>">登入缺勤</a> | <a href="schedule_event_add.jsp?et=2<%=(membrId!=-1)?"&membrId="+membrId:""%>&bunit=<%=bunit%>">單日請假</a>  | 多日請假
<% } %>
</font>
</div>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>
<center>
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
                    缺勤事由
                    </td>
                    <td>
                        <select name="type" onchange="checkScheduleBoundary();">
                    <% if (et==2) { %>
                        <option value="<%=SchEvent.TYPE_PERSONAL%>" <%=(type==SchEvent.TYPE_PERSONAL)?"selected":""%>>事&nbsp;&nbsp;&nbsp;假&nbsp;(扣薪)</option> 
                        <option value="<%=SchEvent.TYPE_SICK%>" <%=(type==SchEvent.TYPE_SICK)?"selected":""%>>病&nbsp;&nbsp;&nbsp;假&nbsp;(扣薪)</option> 
                        <option value="<%=SchEvent.TYPE_NO_APPEAR%>" <%=(type==SchEvent.TYPE_NO_APPEAR)?"selected":""%>>不明原因&nbsp;(扣薪)</option>  
                        <option value="<%=SchEvent.TYPE_BUSINESS%>" <%=(type==SchEvent.TYPE_BUSINESS)?"selected":""%>>公&nbsp;&nbsp;&nbsp;假&nbsp;(不扣薪,不扣年假)</option>
                        <option value="<%=SchEvent.TYPE_OTHER%>" <%=(type==SchEvent.TYPE_OTHER)?"selected":""%>>其他假&nbsp;(不扣薪,不扣年假)</option>  
                        <option value="<%=SchEvent.TYPE_YEAR%>" <%=(type==SchEvent.TYPE_YEAR)?"selected":""%>>年&nbsp;&nbsp;&nbsp;假&nbsp;(不扣薪,扣年假)</option>
                    <% } else { %>
                        <option value="<%=SchEvent.TYPE_AB_START%>" <%=(type==SchEvent.TYPE_AB_START)?"selected":""%>>遲到&nbsp;(扣缺勤)</option> 
                        <option value="<%=SchEvent.TYPE_AB_ENDING%>" <%=(type==SchEvent.TYPE_AB_ENDING)?"selected":""%>>早退&nbsp;(扣缺勤)</option>     
                        <!--<option value="<%=SchEvent.TYPE_OT_BEFORE%>" <%=(type==SchEvent.TYPE_OT_BEFORE)?"selected":""%>>早到(超) -->
                        <!--<option value="<%=SchEvent.TYPE_OT_AFTER%>" <%=(type==SchEvent.TYPE_OT_AFTER)?"selected":""%>>晚走(超) -->
                    <% } %>
                        </select>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    日期
                    </td>
                    <td>
                        <a href="#" onclick="displayCalendar(document.f1.startTime,'yyyy/mm/dd',this);return false">起</a>:<input type=text name="startTime" value="<%=sdf1.format(d1)%>" size="8" onChange="checkScheduleBoundary()">
                        <a href="#" onclick="displayCalendar(document.f1.endTime,'yyyy/mm/dd',this);return false">至</a>:<input type=text name="endTime" value="<%=sdf1.format(d2)%>" size="8" onChange="checkScheduleBoundary()"><input type=button value="搜尋" onClick="checkScheduleBoundary()">


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
                    <td class=es02>
            起:<input type=text name=d1 value=<%=hours%> size=1>
            至:<input type=text name=d2 value=<%=mins%> size=1>  (將套用於全部已選的班表中)
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
                    <td colspan=2 align=middle>    
                        <div id="desc"></div>
                        <input type=hidden name="restMins" value="0">
                        <input type=submit name="submit" value="新增多日請假" name="xbptton" id="xbptton" disabled>
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>

</center>

</body>
