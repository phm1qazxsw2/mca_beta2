<%@ page language="java" import="phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>

<%
    String queryZ2="created >='" + sdf.format(beforeDate) +"' and status ='0'";

    ArrayList<Overtime> overtime = OvertimeMgr.getInstance().retrieveList(queryZ2, "order by created asc");
	
	if(overtime==null || overtime.size()<=0)
	{
	}else{
%>

<div class=es02>
<b><img src="images/rfidx.png" width=16 border=0>&nbsp;未確認加班</b>&nbsp;&nbsp;&nbsp;更動概況: <a href="#" onClick="showForm('overtimeDiv');return false"><%=overtime.size()%> 筆</a>
</div>
<div id=overtimeDiv style="display:none" class=es02>
<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
<td>姓名</td> 
<td>狀態</td> 

<td>類型</td>
<td>日期</td>
<td>加班時段</td>
<td>加班時間</td>
<td></td>
</tr>	
<%
SimpleDateFormat sdf2zz2 = new SimpleDateFormat("MM/dd");
SimpleDateFormat sdftimezz2 = new SimpleDateFormat("HH:mm");
DecimalFormat mnfzz2 = new DecimalFormat("###,###,##0.0");
for(int i=0;i<overtime.size();i++)
{
    Overtime o=overtime.get(i);
    
    Membr membr2 = MembrMgr.getInstance().find("id='" +o.getMembrId()+"'");
%>
    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
        <td  valign=bottom>
            <%=membr2.getName()%>
        </td>
        <td class=es02  valign=bottom>
            <img src="images/dotx.gif" border=0>&nbsp;線上申請 
        </td>
        <td class=es02 align=middle nowrap  valign=bottom>
            加班
        </td>
        <td class=es02 align=left nowrap valign=bottom>
            <%  
                out.println(sdf2zz2.format(o.getStartDate()));
                out.println("("+SchInfo.printDayOfWeek(o.getStartDate().getDay()+1)+")");


            %>
        </td>
        <td class=es02 align=bottom nowrap valign=bottom><%=sdftimezz2.format(o.getStartDate())%>-<%=sdftimezz2.format(o.getEndDate())%></td>
        <%
            float hrs=(float)o.getMins()/(float)60;
            
        %>
        <td class=es02 align=right nowrap valign=bottom>
        <%=mnfzz2.format(hrs)%>
        </td>
        <td class=es02 align=middle valign=bottom>
            <a href="javascript:openwindow_phm('overtime_edit.jsp?id=<%=o.getId()%>', '修改加班記錄', 800, 600,'addevent');">主管覆核</a>
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