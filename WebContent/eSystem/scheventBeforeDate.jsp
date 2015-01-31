<%@ page language="java" import="phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%!
    String getTableHeader() 
    {
        StringBuffer sb = new StringBuffer();

        sb.append("<tr bgcolor=#f0f0f0 class=es02>");
        sb.append("  <td width=40 align=middle>狀態</td>");
        sb.append("  <td width=70 align=middle>類型</td>");
        sb.append("  <td width=40 align=middle>班表</td>");
        sb.append("  <td width=70 align=middle>日期</td>");
        sb.append("  <td width=100 align=middle nowrap>缺勤時段</td>");
        sb.append("  <td width=70 align=middle>缺勤時間</td>");
        sb.append("  <td width=100 align=middle nowrap>刷卡時段</td>");
        sb.append("  <td width=70 align=middle>覆核人</td>");
        sb.append("  <td width=70 align=middle></td>");
        sb.append("</tr>");
        return sb.toString();
    }

    String getDay(SchEvent e)
    {
        int d = e.getEndTime().getDate()-e.getStartTime().getDate();
        if (d==0) return "";
        if (d==1) return "隔天";
        return e.getEndTime().getDate()+"號";
    }

    String printStatus(int status){

        switch(status){
            case SchEvent.STATUS_PERSON_CONFORM :
                return "&nbsp;&nbsp;<font color=blue>正式缺勤</font>";
            case SchEvent.STATUS_READER_CONFORM :
                return "&nbsp;&nbsp;<font color=blue>正式缺勤</font>";
            case SchEvent.STATUS_READER_PENDDING:
                return "<img src='images/dotx.gif' border=0>&nbsp;系統產生";
            case SchEvent.STATUS_PERSON_PENDDING:
                return "<img src='images/dotx.gif' border=0>&nbsp;線上請假";
        }
        return "";
    }
%>

<%

    String query="modifyTime >='" + sdf.format(beforeDate) +"' and status >='2'";

    ArrayList<SchEvent> schevents = SchEventMgr.getInstance().
        retrieveList(query, "order by startTime asc");
	

	if(schevents==null || schevents.size()<=0)
	{
	

	}else{
		
%>

<div class=es02>
<b><img src="images/rfidx.png" width=16 border=0>&nbsp;未確認缺勤</b>&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('scheventDiv');return false"><%=schevents.size()%> 筆</a>
</div>
<div id=scheventDiv style="display:none" class=es02>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
<td>姓名</td> 
<td>狀態</td> 

<td>類型</td>
<td>班表</td>
<td>日期</td>
<td>缺勤時段</td>
<td>缺勤時間</td>
<td></td>
</tr>	
<%
SchDefMgr sdm=SchDefMgr.getInstance();
SimpleDateFormat sdf2zz = new SimpleDateFormat("MM/dd");
SimpleDateFormat sdftimezz = new SimpleDateFormat("HH:mm");
for(int i=0;i<schevents.size();i++)
{
    SchEvent e=schevents.get(i);
    SchDef sd=sdm.find("id="+e.getSchdefId());
    
    Membr membr = MembrMgr.getInstance().find("id='" +e.getMembrId()+"'");
%>
    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td  valign=bottom>
            <%=membr.getName()%>
        </td>
        <td class=es02  valign=bottom>
                <%=printStatus(e.getStatus())%> 
        </td>
        <td class=es02 align=middle nowrap  valign=bottom>
            <%=SchEvent.getChinsesType(e.getType())%>
        </td>
        <td class=es02 align=left nowrap valign=bottom>        
            <%=sd.getName()%>
        </td>
        <td class=es02 align=left nowrap valign=bottom>
            <%  
                Date startDate=e.getStartTime();
                out.println(sdf2zz.format(startDate));
                
                out.println("("+SchInfo.printDayOfWeek(startDate.getDay()+1)+")");
            %>
        </td>
        <td class=es02 align=bottom nowrap valign=bottom><%=sdftimezz.format(e.getStartTime())%>-<%=sdftimezz.format(e.getEndTime())%></td>
        <%
        int lastingHours=e.getLastingHours();
        int lastingMins=e.getLastingMins();
        %>
        <td class=es02 align=right nowrap valign=bottom><%=(lastingHours>0 &&e.getType() <110)?lastingHours+" 時":""%><%=(lastingMins>0)?lastingMins+" 分":""%></td>
        <td class=es02 align=middle valign=bottom>
             <a href="#" onClick="javascript:openwindow_phm('modifySchEvent.jsp?seId=<%=e.getId()%>', '修改出缺勤', 500, 420, 'addevent');return false">修改</a>
        </td>        
    </tr>
<%
}
%>
</table>
</td></tr></table>
</div>
<br>
<%
	}
%>