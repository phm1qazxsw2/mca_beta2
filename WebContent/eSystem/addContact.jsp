<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
int studentId=Integer.parseInt(request.getParameter("studentId")); 

JsfAdmin ja=JsfAdmin.getInstance();

Relation[] ra=ja.getAllRelation(_ws2.getStudentBunitSpace("bunitId"));


StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId); 


%>
<script type="text/javascript" src="openWindow.js"></script>
<b>&nbsp;&nbsp;&nbsp;<%=stu.getStudentName()%>-新增聯絡人</b> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 

<center>

<form action="addContact2.jsp" method="post">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>姓名</td>	
	<td bgcolor="ffffff">
	<input type=text name="rName" size=15>
	</td>
	</tr>
<%
    if(pd2.getCustomerType()==0){
%>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td bgcolor="f0f0f0">
	
    關係 <font size=2><a href="#" Onclick="javascript:openwindow7('listRelation.jsp');return false">修改</a></font>
	</td>
	<td bgcolor=ffffff>

		<select name="rRelation" size=1>	
<%	
		for(int j=0;j<ra.length;j++)
		{
%>
		<option value="<%=ra[j].getId()%>"><%=ra[j].getRelationName()%></option>
	
<%
		}	
		out.println("</select>");
	
	%>	
	</td>
	</tr>
<%
    }else{  
%>
        <input type=hidden name="rRelation" value="0">
<%
    }
%>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>
	電話
	</td>
	<td bgcolor="ffffff">
		<input type=text name="rPhone" size=10>	
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>
	Email
	</td>
	<td bgcolor="ffffff">
	<input type=text name="rPhone2" size=30>
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>
	手機
	</td>
	<td bgcolor="ffffff">
		<input type=text name="rMobile" size=10><br>
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
		<td>
		備註
		</td>
		<td bgcolor="ffffff">
		<textarea name="rPs" rows=4 cols=30></textarea>  
		</td>
	</tr>		

	<tr>
	<td colspan=2><center>
	<input type=hidden name="studentId" value="<%=studentId%>">
		<input type=submit value="確認新增">	
	</center>
	</td>
	</tr>
	</table>
	</td>
	</tr>
	</table>
	</form>
	</center>	