<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int seId=Integer.parseInt(request.getParameter("seId"));
    SchEvent se=SchEventMgr.getInstance().find("id="+seId);
    
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2=new SimpleDateFormat("HH:mm");
    SimpleDateFormat sdf3=new SimpleDateFormat("yyyy/MM/dd HH:mm");
    Membr membr = MembrMgr.getInstance().find("id=" + se.getMembrId());

    SchDef sd=SchDefMgr.getInstance().find("id='"+se.getSchdefId()+"'");
    int type=se.getType();

    String m=request.getParameter("m");

    if(m !=null){
%>
        <script>
            alert('修改完成.');
        </script>
<%
    }        

    Calendar c=Calendar.getInstance();
    c.setTime(se.getStartTime());
    c.add(Calendar.DATE,1);
    Date nextDay=c.getTime();    


    // 今天有沒有註記紀錄
    ArrayList<Entryps> pss = EntrypsMgr.getInstance().
        retrieveList("created>='" + sdf.format(se.getStartTime()) + "' and created<'" + sdf.format(nextDay) + "' and membrId='"+membr.getId()+"'", "");


%>    
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/event1.png" border=0>&nbsp;<b><%=membr.getName()%> 缺勤修改</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  
<center>
<form action="modifySchEvent2.jsp" method="post" name="f1" id="f1">

<table width="80%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 class=es02>
            <td>覆核狀態</td>
            <td bgcolor=ffffff>
        <%
            switch(se.getStatus()){
                case SchEvent.STATUS_PERSON_CONFORM :
                case SchEvent.STATUS_READER_CONFORM :
        %>
                    <input type=radio name="conformStatus" value="<%=SchEvent.STATUS_PERSON_CONFORM%>>" checked><font color=blue>正式缺勤</font>
        <% 
                   break;
                case SchEvent.STATUS_READER_PENDDING:
        %>
                    <input type=radio name="conformStatus" value="<%=SchEvent.STATUS_READER_PENDDING%>" checked><img src='images/dotx.gif' border=0>&nbsp;系統產生缺勤 Pending  <br>
                    <input type=radio name="conformStatus" value="<%=SchEvent.STATUS_PERSON_CONFORM%>">&nbsp;&nbsp;<font color=blue>正式缺勤</font>                      
        <%
                    break;
                case SchEvent.STATUS_PERSON_PENDDING:
        %>
                    <input type=radio name="conformStatus" value="<%=SchEvent.STATUS_PERSON_PENDDING%>" checked><img src='images/dotx.gif' border=0>&nbsp;線上自行請假<br>
                    <input type=radio name="conformStatus" value="<%=SchEvent.STATUS_PERSON_CONFORM%>">&nbsp;&nbsp;<font color=blue>正式缺勤</font>                      
        <%            
                    break;
            }
       %>
            </tD>
        </tr>
    <%  if(pss !=null && pss.size()>0){ %>
        <tr bgcolor=#f0f0f0 class=es02>
            <td>註記</td>
            <td bgcolor=ffffff>
                <%=pss.get(0).getPs()%>-
                <%
                    if(pss.get(0).getUserId()==0){
                        out.println("線上登入");
                    }else{
                        User ux=(User)UserMgr.getInstance().find(pss.get(0).getUserId());
                        if(ux !=null)    
                            out.println(ux.getUserFullname());                        
                    }
                %>                
            </td>
        </tr>
    <%  }   %>
    <tr bgcolor=#f0f0f0 class=es02>
            <td>覆核內容</td>
            <td bgcolor=ffffff>
                <textarea name="ps" rows=2 cols=30><%=(se.getVerifyPs()==null)?"":se.getVerifyPs()%></textarea>
            </td>
    </tr>

    <tr bgcolor=#f0f0f0 class=es02>
            <td>假別</td>
            <td bgcolor=ffffff>
            <%
            if(se.getHolidayId()==0){   
            %>
                <select name="type">
                        <option value="<%=SchEvent.TYPE_AB_START%>" <%=(type==SchEvent.TYPE_AB_START)?"selected":""%>>遲到&nbsp;(扣薪)</option> 
                        <option value="<%=SchEvent.TYPE_AB_ENDING%>" <%=(type==SchEvent.TYPE_AB_ENDING)?"selected":""%>>早退&nbsp;(扣薪)</option>
              <option value="<%=SchEvent.TYPE_NO_APPEAR%>" <%=(type==SchEvent.TYPE_NO_APPEAR)?"selected":""%>>不明原因&nbsp;(扣薪)</option>     
                        <option value="<%=SchEvent.TYPE_PERSONAL%>" <%=(type==SchEvent.TYPE_PERSONAL)?"selected":""%>>事&nbsp;&nbsp;&nbsp;假&nbsp;(扣薪)</option> 
                        <option value="<%=SchEvent.TYPE_SICK%>" <%=(type==SchEvent.TYPE_SICK)?"selected":""%>>病&nbsp;&nbsp;&nbsp;假&nbsp;(扣薪)</option> 
                        
                        <option value="<%=SchEvent.TYPE_BUSINESS%>" <%=(type==SchEvent.TYPE_BUSINESS)?"selected":""%>>公&nbsp;&nbsp;&nbsp;假&nbsp;(不扣薪,不扣年假)</option>
                        <option value="<%=SchEvent.TYPE_OTHER%>" <%=(type==SchEvent.TYPE_OTHER)?"selected":""%>>其他假&nbsp;(不扣薪,不扣年假)</option>  
                        <option value="<%=SchEvent.TYPE_YEAR%>" <%=(type==SchEvent.TYPE_YEAR)?"selected":""%>>年&nbsp;&nbsp;&nbsp;假&nbsp;(不扣薪,扣年假)</option> 
                        <option value="<%=SchEvent.TYPE_OVERTIME%>" <%=(type==SchEvent.TYPE_OVERTIME)?"selected":""%>>補&nbsp;&nbsp;&nbsp;休&nbsp;(不扣薪,扣補休時數)</option> 

                </select>
            <%  }else{  
                    Holiday ho=HolidayMgr.getInstance().find(" id='"+se.getHolidayId()+"'");
            %>
                    <%=(ho!=null)?ho.getName():""%>
                    <input type=hidden name="type" value="<%=type%>">
            <%  }   %>                
            </tD>
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>
            <td>班表</tD>
            <td bgcolor=ffffff>
                <%=(sd==null)?"未與班表連結":"<b>"+sd.getName()+"</b>"%>
            </td>    
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>
            <td>日期</tD>
            <td bgcolor=ffffff>
                <%=sdf.format(se.getStartTime())%>&nbsp;
            <input type=hidden name="xx" value="<%=sdf.format(se.getStartTime())%>">
            <a href="#" onclick="displayCalendar(document.f1.xx,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
            </td>    
        </tr>
        <tr bgcolor=#f0f0f0 class=es02>
            <td>缺勤時間</td>
            <td bgcolor=ffffff>
            起:<input type=text name="sTime" value="<%=sdf2.format(se.getStartTime())%>" size=4>
            至:<input type=text name="eTime" value="<%=sdf2.format(se.getEndTime())%>" size=4>
            </tD>
        </tr>
        <tr bgcolor=#ffffff class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0>
                休息扣除時間
            </td>
            <td>
                <input type=text name="restMins" value="<%=se.getRestMins()%>" size=2> 分鐘
            </td>
        </tr>
        <tr bgcolor=#ffffff class=es02 align=left valign=middle>
            <td bgcolor=#f0f0f0>
                登入人
            </td>
            <td>
            <%
                String userName="系統登入";
                UserMgr um=UserMgr.getInstance();
                User u=(User)um.find(se.getUserId());
                if(u!=null)
                    userName=u.getUserFullname();
            %>
            <%=userName%>
            </td>
        </tr>
        <%
        if(se.getVerifyUserId() !=0){
            User vUser=(User)um.find(se.getVerifyUserId());
            
        %>
        <tr>
            <td class=es02>覆核人</td><td class=es02><%=(vUser !=null)?vUser.getUserFullname():""%>-<%=sdf3.format(se.getVerifyDate())%></td>
        </tr>
        <%  }   %>
        <tr bgcolor=#ffffff class=es02 align=right>
            <td colspan=2>
                <input type=hidden name="seId" value="<%=seId%>">
                <input type=hidden name="sDate" value="<%=sdf.format(se.getStartTime())%>">
                <input type=submit value="修改" onClick="return confirm('確認修改此筆缺勤記錄?')">
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="deleteSchEvent.jsp?seId=<%=seId%>" onClick="return confirm('確認刪除此筆缺勤記錄?')"><img src="pic/no2.gif" border=0>&nbsp;刪除此記錄</a>

            </td>
        </tr>   
    </table>
    </td>
    </tr>
    </table>
    </center>
    </form>