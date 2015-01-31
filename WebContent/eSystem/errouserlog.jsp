<%@ page language="java" contentType="text/html;charset=UTF-8"%><%

    int bunitId = _ws.getSessionBunitId();
    String space = null;
    if (bunitId>0)
        space = "bunitId in (0," + bunitId + ")";
    Userlog[] ulsError=ja.getUserlogByIdError(beforeDate, space);
  
   	if(ulsError!=null)
  	{
		int runRow=0;
		
 	    runRow=ulsError.length;
%>  
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;登入錯誤記錄:</b>
&nbsp;

<a href="#" onClick="showForm('errorUserDiv');return false"><%=runRow%> 筆</a>
</div>
<div id=errorUserDiv style="display:none" class=es02>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
				<td>登入時間</tD><td>登入IP</td><td>登入主機</td><td>錯誤紀錄</td>
			</tr>
<%
		for(int i=0;i<runRow;i++)
		{
%> 	
		<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
				<td class=es02><%=sdf.format(ulsError[i].getUserlogDate())%></tD>
				<td class=es02><%=ulsError[i].getUserlogIP()%></td>
				<td class=es02><%=ulsError[i].getUserlogHost()%></td>
				<td class=es02><%=ulsError[i].getUserlogOutPs()%></td>
		</tr>
<%
		}
%>
	</table>	
	
	</td>
	</tr>
	</table>
    </div>	
	<br>
<%
	}
 
%>