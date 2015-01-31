<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=5;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,604))
    {
        response.sendRedirect("authIndex.jsp?code=604");
    }    
%>
<%@ include file="leftMenu4.jsp"%>
<br>
<b>&nbsp;&nbsp;&nbsp;離校原因列表</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>
<div class=es02>
    <form action=addLeaveReason.jsp method=post>
    <img src="pic/add.gif" border=0 width=12>&nbsp;新增離校原因:
	<input type=text name="dName" size=20>
	<input type=submit value="新增">
	</form>
</div>
</blockquote>
<%
	JsfAdmin ja=JsfAdmin.getInstance();

	LeaveReason[] rl=ja.getAllLeaveReason(_ws.getStudentBunitSpace("bunitId"));
	
	if(rl==null)
	{
		
		out.println("目前尚未登入資料!!");
		return;
	
	}
	else
	{
%>
<blockquote>
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td align=middle>名&nbsp;&nbsp;稱</td><td align=middle>使用狀態</td><td></td>
		</tr>
<%
	for(int i=0;i<rl.length;i++)
	{	
%> 
	<form action="modifyLR.jsp" method="post">

		<tr bgcolor=#ffffff class=es02>
		<td>
			<input type=text name="dName" value="<%=rl[i].getLeaveReasonName()%>">
		</td>
			<input type=hidden name="lrId" value="<%=rl[i].getId()%>">
		<td>
		<input type=radio name="active" value="1" <%=(rl[i].getLeaveReasonActive()==1)?"checked":""%>>使用中
		<input type=radio name="active" value="0" <%=(rl[i].getLeaveReasonActive()==0)?"checked":""%>>停用
		</td>	
		<td><input type=submit onClick="return(confirm('確認修改此筆資料?'))" value="修改"></td>
		</form>
	</tr>
<%
	}
%>
</table>
 

<%
	}
%>
</tD>
</tr>
</table>
</blockquote>
 


<%@ include file="bottom.jsp"%>	