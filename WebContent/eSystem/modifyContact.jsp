<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
int contactId=Integer.parseInt(request.getParameter("contactId")); 

JsfAdmin ja=JsfAdmin.getInstance();

Relation[] ra=ja.getAllRelation(_ws2.getStudentBunitSpace("bunitId"));

ContactMgr cm=ContactMgr.getInstance();
Contact con=(Contact)cm.find(contactId);

StudentMgr sm=StudentMgr.getInstance();

Student stu=(Student)sm.find(con.getContactStuId());

%>
<script type="text/javascript" src="openWindow.js"></script>
<b>&nbsp;&nbsp;&nbsp;<%=stu.getStudentName()%>-修改聯絡人</b>
 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 

<center>
<form action="modifyContact2.jsp" method="post">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>姓名</td>	
	<td bgcolor="ffffff">
		<input type=text name="rName" size=15 value="<%=con.getContactName()%>">
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>
	關係 <font size=2><a href="#" Onclick="javascript:openwindow7('listRelation.jsp');return false">修改</a></font>
	</td>
	<td bgcolor="ffffff">
	<%
	int raId=con.getContactReleationId();
	
	if(ra==null)
	{
		out.println("尚未加入關係");
	}
	else
	{
%>
		<select name="rRelation" size=1>	
<%	
		for(int j=0;j<ra.length;j++)
		{
%>
		<option value="<%=ra[j].getId()%>" <%=(raId==ra[j].getId()?"selected":"")%>><%=ra[j].getRelationName()%></option>
	
<%
		}	
		out.println("</select>");
	}
	%>	
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
		<td>電話</td>
		<td bgcolor="ffffff">
			<input type=text name="rPhone" size=10 value="<%=con.getContactPhone1()%>">	
		</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
		<td>Email</td>
		<td bgcolor="ffffff">
			<input type=text name="rPhone2" size=30 value="<%=con.getContactPhone2()%>">
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>
	手機
	</td>
	<td bgcolor="ffffff">
	<input type=text name="rMobile" size=10 value="<%=con.getContactMobile()%>"><br>
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	<td>
	備註
	</td>
	<td bgcolor="ffffff">
		<textarea name="rPs" rows=4 cols=30><%=con.getContactPs()%></textarea>  
	</td>
	</tr>		

	<tr>
		<td colspan=2 nowrap>
			<center>
				<input type=hidden name="contactId" value="<%=contactId%>">
				<input type=submit value="確認修改">	
			</center>	
                <div class=es02 align=right><a href="deleteContact.jsp?contactId=<%=contactId%>" onClick="return(confirm('確認刪除此筆資料?'))"><img src="pic/delete.gif" border=0>刪除此聯絡人</a></div>
		</td>
	</tr>
	</table>
	</td>	
	</tr>
	</table>		
	</center>
	
	</form>

	
	
	
	