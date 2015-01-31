<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
    String studentStuff1=request.getParameter("studentStuff1");
    String studentStuff2=request.getParameter("studentStuff2");
    String studentStuff3=request.getParameter("studentStuff3");
    String studentStuff4=request.getParameter("studentStuff4");
    String studentStuff5=request.getParameter("studentStuff5");
    String studentStuff6=request.getParameter("studentStuff6");
    String studentStuffPs=request.getParameter("studentStuffPs");
	
	StudentMgr sm=StudentMgr.getInstance();
	Student st=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId"));
    st.setStudentStuffDate   	(new Date());
    st.setStudentStuffUserId   	(ud2.getId());
    st.setStudentStuff1   	(studentStuff1);
    st.setStudentStuff2   	(studentStuff2);
    st.setStudentStuff3   	(studentStuff3);
    st.setStudentStuff4   	(studentStuff4);
    st.setStudentStuff5   	(studentStuff5);
    st.setStudentStuff6   	(studentStuff6);
    st.setStudentStuffPs   	(studentStuffPs);	
	sm.save(st);


    response.sendRedirect("studentStuff.jsp?studentId="+studentId);

%>	
