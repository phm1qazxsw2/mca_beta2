<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 		
 	String studentName=request.getParameter("studentName");
 	String studentNickname=request.getParameter("studentNickname"); 
 	int studentSex=Integer.parseInt(request.getParameter("studentSex")); 
	String studentIDNumber=request.getParameter("studentIDNumber"); 
	String studentBirth=request.getParameter("studentBirth");
	String studentPs=request.getParameter("studentPs"); 
	int studentBrother=Integer.parseInt(request.getParameter("studentBrother")); 
 	int studentBigSister=Integer.parseInt(request.getParameter("studentBigSister")); 
 	int studentYoungBrother=Integer.parseInt(request.getParameter("studentYoungBrother")); 
 	int studentYoungSister=Integer.parseInt(request.getParameter("studentYoungSister")); 


	JsfTool jt=JsfTool.getInstance();
	Date studentBirth2=new Date();
	if(!studentBirth.equals(""))
		studentBirth2=jt.ChangeToDate(studentBirth);
			
	
	StudentMgr sm=StudentMgr.getInstance();

	Student st=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 
		
	st.setStudentName(studentName);
	st.setStudentNickname   	(studentNickname);
	st.setStudentSex(studentSex);
	st.setStudentIDNumber(studentIDNumber);
	st.setStudentBirth(studentBirth2);
	st.setStudentPs   	(studentPs);
	st.setStudentBrother(studentBrother);
	st.setStudentBigSister(studentBigSister);
	st.setStudentYoungBrother(studentYoungBrother);
	st.setStudentYoungSister(studentYoungSister);
	
	sm.save(st);



	//response.sendRedirect("detaialStudent.jsp?studentId="+studentId);

%>
	修改完成!!
	
	<br><br>
	<a href="modifyStudent.jsp?studentId=<%=studentId%>">回詳細資料</a>