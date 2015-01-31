<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.find(studentId); 	
%>	
<table>

<tr><td bgcolor="lightgrey">學生姓名</td><td><%=stu.getStudentName()%></td><td></td></tr>
<tr><td bgcolor="lightgrey">English Name</td><td><%=stu.getStudentNickname()%><td></td></tr>
<tr><td bgcolor="lightgrey">生日</td><td><%=sdf1.format(stu.getStudentBirth())%></td><td></td></tr>
<tr><td bgcolor="lightgrey">父親</td><td><%=stu.getStudentFather()%>
		 email: <%=stu.getStudentFatherEmail()%></td>
		<td bgcolor="lightgrey">手機<%=stu.getStudentFatherMobile()%></td></tr>
<tr><td bgcolor="lightgrey">母親</td><td><%=stu.getStudentMother()%>
		 email: <%=stu.getStudentMotherEmail()%>
		</td>
		<td bgcolor="lightgrey">手機 <%=stu.getStudentMotherMobile()%></td></tr>
<tr><td bgcolor="lightgrey">家中電話</td><td><%=stu.getStudentPhone()%></td><td></td></tr>
<tr><td bgcolor="lightgrey">地址</td><td><%=stu.getStudentAddress()%></td><td></td></tr>
<tr><td bgcolor="lightgrey">入學日期</td><td><%=sdf1.format(stu.getStudentComeDate())%></td><td></td></tr>
<tr><td bgcolor="lightgrey">目前狀態</td><td>
		<%
			int status=stu.getStudentStatus();
			
			out.println(ja.getStudentStatus(status));
		%>
		
	</td><td></td></tr>
<tr><td bgcolor="lightgrey">班別</td><td>			
	<%
		int ClassId=stu.getStudentClassId();
		out.println(ja.getClassById(ClassId));
	%>	
	</td><td></td></tr>
<tr><td bgcolor="lightgrey">年級</td><td>	
	<%	
		
		int level=stu.getStudentLevel();
		out.println(ja.getLevelById(level));
	%>
	</td><td></td></tr>	
<tr><td bgcolor="lightgrey">匯款帳戶1</td>
	<td>
	銀行:<%=stu.getStudentBank1()%>
	帳號:<%=stu.getStudentAccountNumber1()%>
	</td><td></td></tr>
<tr><td bgcolor="lightgrey">匯款帳戶2</td>
	<td>
	銀行:<%=stu.getStudentBank2()%>
	帳號:<%=stu.getStudentAccountNumber2()%>
	</td><td></td></tr>
<tr><td bgcolor="lightgrey">備註</td><td colspan=2>
	<%=stu.getStudentPs()%>
	</td></tr>	

<tr><td colspan=3>
	<center>
	<form action="modifyStudent.jsp" method="post">
		<input type=hidden name="studentId" value="<%=stu.getId()%>">
		<input type=submit value="修改資料">
	</form>
	</center>
	</td></tr>	
	</table>	