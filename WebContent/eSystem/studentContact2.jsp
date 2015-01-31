<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8"); 	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));

 	String studentFather=request.getParameter("studentFather"); 
	String studentFathJob=request.getParameter("studentFathJob");
	int studentFatherDegree=Integer.parseInt(request.getParameter("studentFatherDegree")); 
	String studentFatherEmail=request.getParameter("studentFatherEmail"); 
	String studentFatherMobile=request.getParameter("studentFatherMobile"); 
	String studentFatherMobile2=request.getParameter("studentFatherMobile2");
	
	String studentMother=request.getParameter("studentMother"); 
	String studentMothJob=request.getParameter("studentMothJob");
	int studentMothDegree=Integer.parseInt(request.getParameter("studentMothDegree")); 
	String studentMotherEmail=request.getParameter("studentMotherEmail"); 
	String studentMotherMobile=request.getParameter("studentMotherMobile"); 
	String studentMotherMobile2=request.getParameter("studentMotherMobile2");
	String studentZipCode=request.getParameter("studentZipCode");
	String studentAddress=request.getParameter("studentAddress"); 
	String studentPhone=request.getParameter("studentPhone"); 
	String studentPhone2=request.getParameter("studentPhone2");
	String studentPhone3=request.getParameter("studentPhone3");	
	String studentPs=request.getParameter("studentPs");
	String studentWeb=request.getParameter("studentWeb"); 	
	String studentFatherOffice=request.getParameter("studentFatherOffice");
	String studentMotherOffice=request.getParameter("studentMotherOffice"); 	

 	int emailDefault=1;
    try { emailDefault=Integer.parseInt(request.getParameter("emailDefault")); } catch (Exception e) {}
	int mobileDefault=0;//Integer.parseInt(request.getParameter("mobileDefault")); 	
	int skypeDefault=0;//Integer.parseInt(request.getParameter("skypeDefault")); 
	int phoneDefault=Integer.parseInt(request.getParameter("phoneDefault")); 
	String fatherSkype=""; //request.getParameter("fatherSkype");  
	String motheSkype=""; //request.getParameter("motherSkype");  	
	
	
	
	StudentMgr sm=StudentMgr.getInstance();
	Student st=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 
	
	st.setStudentMobileDefault(mobileDefault);
	st.setStudentEmailDefault(emailDefault);
	st.setStudentPhoneDefault(phoneDefault);
	st.setStudentSkypeDefault(skypeDefault);
	st.setStudentFatherSkype(fatherSkype);
	st.setStudentMotherSkype(motheSkype);
	
	
	st.setStudentFather   	(studentFather);
	st.setStudentFathJob(studentFathJob);
	st.setStudebtFatherDegree(studentFatherDegree);
	st.setStudentFatherEmail(studentFatherEmail);
	st.setStudentFatherMobile   	(studentFatherMobile);
	st.setStudentFatherMobile2(studentFatherMobile2);
	
	st.setStudentMother   	(studentMother);
	st.setStudentMothJob(studentMothJob);	
	st.setStudentMothDegree(studentMothDegree);
	st.setStudentMotherEmail(studentMotherEmail);
	st.setStudentMotherMobile   	(studentMotherMobile);
	st.setStudentMotherMobile2(studentMotherMobile2);
	st.setStudentZipCode(studentZipCode);
	st.setStudentAddress   	(studentAddress);
	st.setStudentPhone   	(studentPhone);
	st.setStudentPhone2(studentPhone2);
	st.setStudentPhone3(studentPhone3);	
	st.setStudentPs   	(studentPs);
    st.setStudentWeb(studentWeb);
    st.setStudentFatherOffice(studentFatherOffice);
    st.setStudentMotherOffice(studentMotherOffice);
	sm.save(st);
%>

&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=st.getStudentName()%></font> -<img src="pic/fix.gif" border=0>聯絡資訊<br><br>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
	<br>
	<br>
	<blockquote>
		<div class=es02>修改完成!</div>	
	
	<br><br>
	
	<a href="studentContact.jsp?studentId=<%=studentId%>">回聯絡資料</a>

	</blockquote>