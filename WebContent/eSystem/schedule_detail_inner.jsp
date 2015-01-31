<body>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;
<b><img src="pic/schedule.png" border=0>&nbsp;<%=(sd!=null)?sd.getName()+"-基本資料(修改模式)":"新增班表"%></b>
<%
    if(sd !=null){
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="schedule_detail.jsp?id=<%=id%>">回上一頁</a>
<%  }   %>
</div><br>
<%
    BunitMgr bm=BunitMgr.getInstance();
    ArrayList<Bunit> b=bm.retrieveListX("status ='1' and flag='0'","", _ws2.getBunitSpace("buId"));
%>
<div class=es02>
<%
    if(id !=-1){
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;基本資料(修改模式) | <a href="javascript:openwindow_phm2('schedule_userlist.jsp?id=<%=id%>','設定班表人員',600,600,'schmembrsetup');">班表人員</a> 
    </div>
<%  }else{  %>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;新增班表
<%  }   %>  
</div>  
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<script src="201a.js" type="text/javascript"></script>
<center>    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    班表
                    </td>
                    <td>
<%
    if(b !=null && b.size()>=0){
%>
    部門: <select name="bunit" size=1>
    <%          
                for(int j=0;j<b.size();j++){    
                    Bunit bb=b.get(j);
    %>
                    <option value="<%=bb.getId()%>" <%=(bunit==bb.getId())?"selected":""%>><%=bb.getLabel()%></option>
    <%          }   %>
                <option value="0" <%=(bunit==0)?"selected":""%>>跨部門</option>
            </select>
<%
    }else{
%>
        <input type=hidden name="bunit" value="0">
<%  }   %>
                    名稱:<input type=text name="name" value="<%=phm.util.TextUtil.encodeHtml(name)%>">
                    &nbsp;&nbsp;
       </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    有效區間
                    </td>
                    <td>
                    <a href="#" onclick="displayCalendar(document.f1.startDate,'yyyy/mm/dd',this);return false">起始日</a>
                    <input type=text name="startDate" value="<%=sdf.format(startDate)%>" size=7> 
                    <a href="#" onclick="displayCalendar(document.f1.endDate,'yyyy/mm/dd',this);return false">至</a> 
                    <input type=text name="endDate" value="<%=(endDate!=null)?sdf.format(endDate):""%>" size=7>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    設定類型
                    </td>
                    <td>
                      <input type=radio name="type" value="<%=SchDef.TYPE_EVERYDAY%>" <%=(type==SchDef.TYPE_EVERYDAY)?" checked":""%> onclick="showContentInput(<%=SchDef.TYPE_EVERYDAY%>);"> 有效區間的每一天
                      <input type=radio name="type" value="<%=SchDef.TYPE_DAY_OF_WEEK%>" <%=(type==SchDef.TYPE_DAY_OF_WEEK)?" checked":""%> onclick="showContentInput(<%=SchDef.TYPE_DAY_OF_WEEK%>);"> 每周的某幾天 
                      <input type=radio name="type" value="<%=SchDef.TYPE_DAY_OF_MONTH%>" <%=(type==SchDef.TYPE_DAY_OF_MONTH)?" checked":""%> onclick="showContentInput(<%=SchDef.TYPE_DAY_OF_MONTH%>);"> 每月的某幾天

                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    內容
                    </td>
                    <td>
                    格式:&nbsp;&nbsp;<font color=blue>日期</font> ,&nbsp;&nbsp;<font color=blue>開始時分</font>-<font color=blue>結束時分</font>,<font color=blue>休息分鐘</font>,<font color=blue>遲到緩衝分鐘</font><br>
                    (例) : 1-3-5,0900-1800,60,10 <br>

                   
                    <textarea name="content" cols=60 rows=4><%=content%></textarea>
                    <br>
                         說明:<br>
                         &nbsp;1.不同天有不同時間可用多行表示.<br>
                         &nbsp;2.星期代號為: <font color=blue>0</font>(週日),<font color=blue>1</font>(週一),<font color=blue>2</font>(週二),<font color=blue>3</font>(週三),<font color=blue>4</font>(週四),<font color=blue>5</font>(週五),<font color=blue>6</font>(週六)<br>
                    &nbsp;3.類型為每一天時,日期設為<font color=blue>0</font><br>    
                         &nbsp;4.彈性班表的 <font color=blue>開始時分-結束時分</font> 可用括號表示,範例如下:<br>
                                ...,(0700-1600 or 0800-1700 or 0900-1800),...
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                        班表模式
                    </td>
                    <td>
                        <input type=radio name="autoRun" value="1" <%=(autoRun==1)?"checked":""%>>正常班 (缺勤主動比對)
                        <input type=radio name="autoRun" value="0" <%=(autoRun==0)?"checked":""%>>加班 (出勤時間對比)
                    </td>
                </tr>

                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                    顏色
                    </td>
                    <td>
                    <div id="colorpicker201" class="colorpicker201"></div>
                    Color: <input type="button" onclick="showColorGrid2('color','sample_1');" value="...">&nbsp;<input type="text" ID="color" name="color" size="9" value="<%=color%>">&nbsp;<input type="text" ID="sample_1" size="1" value="">
                    </td>
                </tr>
<% 
    if (membrCount>=0){
%>
           <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                <td bgcolor=#f0f0f0>
                班表人員
                </td>
                <td>
                    合計:<%=membrCount%> 人 <a href="javascript:openwindow_phm2('schedule_userlist.jsp?id=<%=id%>','設定班表人員',600,600,'schmembrsetup');">設定</a>   <br>
                    <%=membrNames%>
                </td>
        </tr>
<%
    }
%>
                <tr>
                    <td colspan=2 align=middle>    
                        <div id="desc"></div>
                        <span id="submitbutton"></span>
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>
        </center>

<script src="js/string.js"></script>
<script src="js/dateformat.js"></script>
<script src="js/myevent.js"></script>
<script>

    var cross_today = <%=cross_day%>;
    document.getElementById("sample_1").style.background = '<%=color%>';
    function doSubmit()
    {
        if (cross_today && !confirm('修改後的起始日會從明天開始生效，今天和之前的不會改變'))
            return false;

        if (trim(document.f1.name.value)=="") {
            alert("請輸入班表名稱");
            return false;
        }
        if (!isDate(document.f1.startDate.value, 'yyyy/MM/dd')) {
            alert("請輸入正確的起始日期");
            document.f1.startDate.focus();
            return false;
        }
        if (!isDate(document.f1.endDate.value, 'yyyy/MM/dd')) {
            alert("請輸入正確的結束日期");
            document.f1.endDate.focus();
            return false;
        }
        if (document.f1.endDate.value<=document.f1.startDate.value) {
            alert("結束日期不可小於起始日期");
            document.f1.endDate.focus();
            return false;
        }
        var type = document.f1.type;
        if (trim(document.f1.content.value)=="") {
            alert("請輸入內容");
            return false;
        }
        if (trim(document.f1.color.value)=="") {
            alert("請輸入顯示顏色");
            return false;
        }
        return true;
   }
</script>