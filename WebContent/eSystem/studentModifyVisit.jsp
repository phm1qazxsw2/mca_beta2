<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));

	int studentVisitTeacher=0;
    try { studentVisitTeacher=Integer.parseInt(request.getParameter("studentVisitTeacher")); } catch (Exception e) {}
	String studentVisitDate=request.getParameter("studentVisitDate");
	String studentTryDate=request.getParameter("studentTryDate");
	
	int studentPhoneTeacher=0;
    try { studentPhoneTeacher=Integer.parseInt(request.getParameter("studentPhoneTeacher")); } catch (Exception e) {}
	String studentPhoneDate=request.getParameter("studentPhoneDate");		
	int studentGohome=Integer.parseInt(request.getParameter("studentGohome")); 	
	int studentSchool=Integer.parseInt(request.getParameter("studentSchool")); 	
	
	JsfTool jt=JsfTool.getInstance();	
	Date pd=new Date();
	Date vd=new Date();			
	Date td=new Date();
	if(studentPhoneDate !=null && !studentPhoneDate.equals(""))
		pd=jt.ChangeToDate(studentPhoneDate);
	
	if(studentVisitDate !=null &&!studentVisitDate.equals(""))
		vd=jt.ChangeToDate(studentVisitDate);
		
	if(studentTryDate !=null && !studentTryDate.equals(""))
		td=jt.ChangeToDate(studentTryDate);		

	String studentSpecial=request.getParameter("studentSpecial"); 
		
	StudentMgr sm=StudentMgr.getInstance();
	Student st=(Student)sm.find(studentId); 	

	if(studentVisitTeacher !=0)			
		st.setStudentVisitTeacher(studentVisitTeacher);

	if(studentVisitDate !=null && !studentVisitDate.equals(""))
		st.setStudentVisitDate(vd);
	
	if(studentTryDate !=null && !studentTryDate.equals(""))
		st.setStudentTryDate(td);

	if(studentPhoneTeacher !=0)
		st.setStudentPhoneTeacher(studentPhoneTeacher);	
	
	if(studentPhoneDate !=null && !studentPhoneDate.equals(""))
		st.setStudentPhoneDate(pd);
		
	st.setStudentSpecial(studentSpecial);
	sm.save(st);



	//response.sendRedirect("detaialStudent.jsp?studentId="+studentId);

%>	
	&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=st.getStudentName()%></font> -<img src="pic/fix.gif" border=0>入園資訊<br><br>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
	<br>
	<br>
	<blockquote>
		<div class=es02>修改完成!</div>	
	
	<br><br>
	
	<a href="studentVisit.jsp?studentId=<%=studentId%>">回入園資訊</a>

	</blockquote>