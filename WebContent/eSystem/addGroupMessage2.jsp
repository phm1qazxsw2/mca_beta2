<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%

request.setCharacterEncoding("UTF-8");
String mobiles[]=request.getParameterValues("mobiles");

if(mobiles==null)
{
	out.println("尚未選擇");
	return;
}
String content=request.getParameter("content");

 	
JsfPay jp=JsfPay.getInstance();

PaySystemMgr em=PaySystemMgr.getInstance();
PaySystem e=(PaySystem)em.find(1);
%>
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>發送號碼</td>
			<td>狀態</td>
		</tr>
<%

for(int i=0;i<mobiles.length;i++)
{
	String outWord=jp.sendMobileMessage(e,mobiles[i],content);

	if(outWord.length()>2)
	{
%>	
	<tr bgcolor=#ffffff class=es02>
		<td><%=mobiles[i]%></td>
		<td><font color=blue><b>發送成功!</b></font></td>
	</tr>
<%	
	}else{
%>
	<tr bgcolor=#ffffff class=es02>
		<td><%=mobiles[i]%></td>
		<td><font color=red><b>發送失敗!</b></font></td>
	</tr>
<%	
	}	
}
%>
 
 	</table>
 		</td>
 		</tr>
 		</table>
 	
