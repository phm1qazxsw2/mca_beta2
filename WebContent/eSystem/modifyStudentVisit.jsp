﻿<%@ page language="java"  import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<head>

<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
<script language="JavaScript" src="js/in.js"></script>
</head>

<body>

<%
	int stuId=Integer.parseInt(request.getParameter("studentId"));

	StudentMgr sm=StudentMgr.getInstance();
	
	Student stu=(Student)sm.find(stuId);
	JsfAdmin ja=JsfAdmin.getInstance();
	JsfTool jt=JsfTool.getInstance();
	Degree[] degree=ja.getAllActiveDegree(_ws2.getStudentBunitSpace("bunitId"));
	Classes[] cl=ja.getAllActiveClasses();
	
%>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>

<form action="modifystudentVisit2.jsp" method=post name="xs"> 

<div align=left><b>&nbsp;&nbsp;&nbsp;<%=stu.getStudentName()%>-參觀紀錄單
</b></div> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>  
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#f0f0f0 class=es02>
<td width=200>帶領參觀人員</td>
<td  bgcolor=#ffffff colspan=2>

<%

	Teacher[] tea=ja.getActiveTeacher(7);


	if(tea==null)
	{
		out.println("尚未登入老師資料!");
	
	
	}
	else
	{
	%>
		<select size=1 name="studentVisitTeacher">
	<%
		for(int i=0;i<tea.length;i++)
		{
	%>
			<option value="<%=tea[i].getId()%>"><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></option>	
	
	<%
		}
		
		out.println("</select>");
	}
	%>

</td></tr>
<tr bgcolor=#f0f0f0 class=es02>
	<td>參觀日期</td>
	<td bgcolor=#ffffff  colspan=2>
		<input  class="textInput" type=text size=10 name="studentVisitDate" size=10 value="<%=jt.ChangeDateToString(new Date())%>"> 
		ex:2006/10/10  
	</td>
</tr>
<tr bgcolor=#f0f0f0 class=es02>
	<td>預定試讀日期</td>
	<td colspan=2 bgcolor=#ffffff><input  class="textInput" onKeyDown="if(event.keyCode==13) event.keyCode=9;" type=text size=10 name="studentTryDate" size=10  onkeyup="up2tab(this)"> 
<a href="javascript:show_calendar('xs.studentTryDate');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
<font size=2>
<a href="#" onClick="checkYear9()">轉換日期格式</a>
ex:2006/10/10  
</td>
</tr>

<tr bgcolor=#f0f0f0 class=es02>
	<td>預定單位 <font size=2>
	<a href="#" Onclick="javascript:openwindow7('listDepart.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a></font></td>
	<td bgcolor=#ffffff colspan=2>

<%

	
	Depart[] de=ja.getAllDepart();
	if(de==null)
	{
		out.println("<font size=2 color=red><b>尚未加入單位</b></font>");
	}
	else
	{
	%>
		<input type=radio name="studentDepart" value="0" <%=(stu.getStudentDepart()==0)?"checked":""%>>未定

	<%

		for(int i=0;i<de.length;i++)
		{
%>
		<input type=radio name="studentDepart" value=<%=de[i].getId()%> <%=(stu.getStudentDepart()==de[i].getId())?"checked":""%>><%=de[i].getDepartName()%>
<%
		
		}	
		
	}
	%>	
	
	</td></tr>	

<tr bgcolor=#f0f0f0 class=es02>
	<td>預定班別<font size=2>	
	<a href="#" Onclick="javascript:openwindow7('listClass.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a></font></td>
	<td bgcolor=#ffffff colspan=2>			
	
	<%
	
	if(cl!=null){
	%>
		<input type=radio name="studentClassId" value=0 <%=(stu.getStudentClassId()==0)?"checked":""%>>未定
	<%
	
	for(int i=0;i<cl.length;i++)
	{
	%>
	<input type=radio name="studentClassId" value=<%=cl[i].getId()%> <%=(stu.getStudentClassId()==cl[i].getId())?"checked":""%>><%=cl[i].getClassesName()%>
	<%
		
	}
	}else{
		out.println("<font size=2 color=red><b>尚未加入班別</b></font>");
	}
	%>
	</td></tr>
	


<tr bgcolor=#f0f0f0 class=es02>
	<td>預定年級
	<font size=2>	
	<a href="#" Onclick="javascript:openwindow7('listLevel.jsp');return false" onKeyDown="if(event.keyCode==13) event.keyCode=9;">修改</a></font>
	</td>
	<td  bgcolor=#ffffff colspan=2>

<%
	
	Level[] le=ja.getAllLevel();
	if(le!=null){
	%>
		<input type=radio name="studentLevel" value=0 <%=(stu.getStudentLevel()==0)?"checked":""%>>未定
	<%
	for(int i=0;i<le.length;i++)
	{
	%>
	<input type=radio name="studentLevel" value=<%=le[i].getId()%> <%=(stu.getStudentLevel()==le[i].getId())?"checked":""%>><%=le[i].getLevelName()%>
	<%
	
	}
	}else{
		out.println("<font size=2 color=red><b>尚未加入年級</b></font>");
	}
	%>
	</font></td></tr>	
		

	<tr bgcolor=#f0f0f0 class=es02>
	<td>入學狀態</td>
	<td bgcolor=#ffffff colspan=2>
			<%
				int status=stu.getStudentStatus();
			%> 
				<table border=0>
		<tr> 
			<td bgcolor=f0f0f0><font color=blue>準備入學:</font></tD>
			<td>
				<input type=radio name="studentStatus" value=1 <%=(status==1)?"checked":""%>>參觀登記
				<input type=radio name="studentStatus" value=2 <%=(status==2)?"checked":""%>>報名/等待入學
			</tD>
		</tr>
		<tr>
			<td bgcolor=f0f0f0><font color=blue>就讀:</font></tD>
			<td>
			<input type=radio name="studentStatus" value=3  <%=(status==3)?"checked":""%>>試讀
			<input type=radio name="studentStatus" value=4  <%=(status==4)?"checked":""%>>入學
			</tD>
		</tr>
		<tr>
			<td bgcolor=f0f0f0><font color=blue>不入學:</font></tD>
			<td>
				<input type=radio name="studentStatus" value=98 <%=(status==98)?"checked":""%>>取消
			</tD>
		</tr>
	</table>

</td></tr>



<tr bgcolor=#f0f0f0 class=es02>
	<td>備註</td>
	<td colspan=2 bgcolor=#ffffff> 
	<textarea name=studentPs rows=10 cols=40><%=stu.getStudentPs()%></textarea>
	</td></tr>
	<input type=hidden name="studentId" value="<%=stu.getId()%>">
	
<tr><td colspan=3><center><input type=submit onClick="checkYear2(); return(confirm('確認修改此筆資料?'))" value="修改"></center></td></tr>
</table>
</td>
</tr>
</table>
</center>
<br>
<div align=left><b>&nbsp;&nbsp;&nbsp;電訪資訊
</b></div> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 class=es02>
	<td>電訪老師</td>
	<td bgcolor=ffffff colspan=2>
<%
	if(tea==null)
	{
		out.println("尚未登入老師資料!");
	}
	else
	{
	%>
		<select size=1 name="studentPhoneTeacher">
		
		<option value=0>無</option>
	<%
		for(int i=0;i<tea.length;i++)
		{
	%>
			<option value="<%=tea[i].getId()%>" <%=(tea[i].getId()==stu.getStudentPhoneTeacher())?"selected":""%>><%=tea[i].getTeacherFirstName()%><%=tea[i].getTeacherLastName()%></option>	
	
	<%
		}
		
		out.println("</select>");
	}
	%>
</td></tr>
<tr bgcolor=#f0f0f0 class=es02>
	<td>電訪日期</td>
<%
String phoneDate="";
if(stu.getStudentPhoneDate()!=null)
	phoneDate=jt.ChangeDateToString(stu.getStudentPhoneDate());

%>
	<td bgcolor=ffffff><input  class="textInput" type=text size=10 name="studentPhoneDate" value="<%=phoneDate%>" size=10></td>
</tr> 
</table>
<td>
</tr>
</table>

</center>

<%@ include file="studentBasicData.jsp" %>


</form>
</body>





