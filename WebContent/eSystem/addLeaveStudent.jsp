<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
	request.setCharacterEncoding("UTF-8");
 	String ps=request.getParameter("ps");
	int lrId=Integer.parseInt(request.getParameter("lrId"));
	int leaveStudentId=Integer.parseInt(request.getParameter("leaveStudentId"));

	LeaveStudentMgr lsm=LeaveStudentMgr.getInstance();
	LeaveStudent lsX=(LeaveStudent)lsm.find(leaveStudentId);

	lsX.setLeaveStudentReasonId(lrId);
	lsX.setLeaveStudentPs(ps);
	
	lsm.save(lsX);
    StudentMgr sm=StudentMgr.getInstance();
    Student st=(Student)sm.find(lsX.getLeaveStudentStudentId());
%>

	<br>
		<B>&nbsp;&nbsp;&nbsp;<%=st.getStudentName()%>-離校原因登入:</b>
 
		<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
		<br>
        
    <blockquote>
        <div class=es02>登入完成!</font>
        <br>
        <br>                

        <div class=es02>請關閉此視窗.</font>
	</blockquote>
	<br><br>
