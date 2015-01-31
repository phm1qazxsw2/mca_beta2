<body>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;
<b><img src="pic/schedule.png" border=0>&nbsp;假期設定</b>
</div><br>

        <div class=es02>
<%
    Holiday h=new Holiday();
    if(id !=-1){

        h=HolidayMgr.getInstance().find(" id='"+id+"'");
%>
    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;修改假期    </div>
<%  }else{  %>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;新增假期    </div>
<%  }   %>  
      </div>  
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<br>
<center>    
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                       假期形式
                    </td>
                    <td>
                        <input type=radio name="type" value="<%=Holiday.TYPE_HOLIDAY_OFFICE%>" <%=(id ==-1 || h.getType()==Holiday.TYPE_HOLIDAY_OFFICE)?"checked":""%>>國定假日
                        <input type=radio name="type" value="<%=Holiday.TYPE_HOLIDAY_WEATHER%>" <%=(h.getType()==Holiday.TYPE_HOLIDAY_WEATHER)?"checked":""%>>颱風假
                        <input type=radio name="type" value="<%=Holiday.TYPE_HOLIDAY_COMPANY%>" <%=(h.getType()==Holiday.TYPE_HOLIDAY_COMPANY)?"checked":""%>>公司特定假
                        <input type=radio name="type" value="<%=Holiday.TYPE_HOLIDAY_OTHER%>" <%=(h.getType()==Holiday.TYPE_HOLIDAY_OTHER)?"checked":""%>>其他假
                    </td>
                </tr>
    <%
            SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
            SimpleDateFormat sdf2=new SimpleDateFormat("HH:mm");

    if(id ==-1){
    %>

                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                      日期/名稱
                    </td>
                    <td>
                    <textarea name="days" rows=4 cols=30></textarea>
                    <br>格式:日期#名稱 (2008/10/10#國慶日),多日請已分行予以間隔                        
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                      放假時間
                    </td>
                    <td>
                        起始:<input type=text name="startTime" value="00:00" size=5>
                        至:<input type=text name="endTime" value="24:00" size=5>
                    </td>
                </tr>
    <%
    }else{

    %>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                      名稱
                    </td>
                    <td>
                        <input type=text name="namex" value="<%=h.getName()%>">
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                      日期
                    </td>
                    <td>
                        <%=sdf.format(h.getStartTime())%>
                    </td>
                </tr>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                      放假時間
                    </td>
                    <td>
                       起始:<%=sdf2.format(h.getStartTime())%>
                        至:<%=sdf2.format(h.getEndTime())%>
                    </td>
                </tr>
    <%  
    }
    %>         
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td colspan=2 align=middle>
                        <input type=submit value="確認">
                    </td>
                </tr>
            </table>
            </td>
            </tr>
            </table>

    <%
    if(id ==-1)
        return;

    ArrayList<SchEvent> sea=SchEventMgr.getInstance().retrieveList("holidayId='"+id+"'","");
    

    if(sea ==null || sea.size()<=0){
    %>
        <br>
        <div class=es02 align=right>
        <a href="deleteHoliday.jsp?id=<%=id%>">刪除此假日</a>  
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
    <%
    }
    
    if(sea !=null && sea.size()>0){
        int totalHour=0;
        int totalMins=0;
        UserMgr um=UserMgr.getInstance();        
        SchDefMgr sdm=SchDefMgr.getInstance();
    %>

        <br>
        <div class=es02>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;請假列表</div>
        </div>  
        <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table> 
        <br>
        <center>
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff class=es02 align=left valign=middle>
                    <td bgcolor=#f0f0f0>
                       姓名
                    </td>
                    <td bgcolor=#f0f0f0>
                       班表
                    </td>
                    <td bgcolor=#f0f0f0>
                    日期
                    </td>
                    <td bgcolor=#f0f0f0>
                    開始-結束時間
                    </td>
                    <td bgcolor=#f0f0f0>
                    休息時間
                    </td>
                    <td bgcolor=#f0f0f0>
                    時間小計
                    </td>
                     <td bgcolor=#f0f0f0>
                    缺勤時間
                    </td>
                     <td bgcolor=#f0f0f0>
                    登入人
                    </td>
                     <td bgcolor=#f0f0f0>
                    </td>
                </tr>

        <%
            MembrMgr mm=MembrMgr.getInstance();

            for(int i=0;i<sea.size();i++){  
                SchEvent e = sea.get(i);
                SchDef sd=sdm.find("id="+e.getSchdefId());

                Membr mx=mm.find("id="+e.getMembrId());
        %>
 <tr bgcolor=#ffffff  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td class=es02 align=left nowrap valign=top>        
            <%=(mx !=null)?mx.getName():""%>
        </td>        
        <td class=es02 align=left nowrap valign=top>        
            <%=sd.getName()%>
        </td>
        <td class=es02 align=left nowrap valign=top><%=sdf.format(e.getStartTime())%></td>
        <td class=es02 align=middle nowrap valign=top><%=sdf2.format(e.getStartTime())%>-<%=sdf2.format(e.getEndTime())%></td>
        <td class=es02 align=right nowrap valign=top><%=(e.getRestMins()!=0)?e.getRestMins()+"(分)":""%></td>
        <td class=es02 align=right nowrap valign=top>
            <%
            int lastingHours=e.getLastingHours();
            int lastingMins=e.getLastingMins();
            
            if(e.getType() <110){
                totalHour+=lastingHours;
                totalMins+=lastingMins;            
            }
            %>
            <%=(lastingHours>0)?lastingHours+" 小時":""%><%=(lastingMins>0)?lastingMins+" 分鐘":""%>
        </td>
        <td class=es02 align=right><%=(lastingHours>0 &&e.getType() <110)?lastingHours+" 小時":""%><%=(lastingMins>0)?lastingMins+" 分鐘":""%></td>
        <td class=es02 align=center nowrap valign=top>
            <%
            int userid=e.getUserId();
            if(userid==0){
                out.println("系統");
            }else{
                User u=(User)um.find(userid);
                if(u !=null)
                    out.println(u.getUserFullname());
            }
            %>
        </td>
        <td class=es02 align=center nowrap valign=top>
            <a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=e.getId()%>', '修改出缺勤', 400, 420, 'addevent');return false">修改</a>
        </td>
    </tr>	
        <%  }   %>
    </table>
    </td>
    </tr>
    </table>
    <%
           
    }
    %>
