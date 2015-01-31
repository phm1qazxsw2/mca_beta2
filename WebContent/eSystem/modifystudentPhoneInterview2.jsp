<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");

 	String studentName=request.getParameter("studentName");
 	String studentNickname=request.getParameter("studentNickname"); 
 	int studentSex=Integer.parseInt(request.getParameter("studentSex")); 
 	String studentBirth=request.getParameter("studentBirth");
 	int studentBrother=Integer.parseInt(request.getParameter("studentBrother")); 
 	int studentBigSister=Integer.parseInt(request.getParameter("studentBigSister")); 
 	int studentYoungBrother=Integer.parseInt(request.getParameter("studentYoungBrother")); 
 	int studentYoungSister=Integer.parseInt(request.getParameter("studentYoungSister")); 
 	
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

	String sg=request.getParameter("studentGohome");
	int studentGohome=0;
	if(sg !=null)
		studentGohome=Integer.parseInt(sg); 
		

	int studentSchool=Integer.parseInt(request.getParameter("studentSchool")); 
	String studentSpecial=request.getParameter("studentSpecial");  
	
	int studentId=Integer.parseInt(request.getParameter("studentId")); 
	int studentPhoneTeacher=Integer.parseInt(request.getParameter("studentPhoneTeacher")); 
	int studentStatus=Integer.parseInt(request.getParameter("studentStatus")); 
	String studentPhoneDate=request.getParameter("studentPhoneDate");
	String studentPs=request.getParameter("studentPs");
	
	String studentVisitDate=request.getParameter("studentVisitDate");
	
	int emailDefault=Integer.parseInt(request.getParameter("emailDefault")); 	
	int mobileDefault=Integer.parseInt(request.getParameter("mobileDefault")); 	
	int skypeDefault=Integer.parseInt(request.getParameter("skypeDefault")); 
	int phoneDefault=Integer.parseInt(request.getParameter("phoneDefault")); 
	String fatherSkype=request.getParameter("fatherSkype");  
	String motheSkype=request.getParameter("motherSkype");  	
	
	StudentMgr sm=StudentMgr.getInstance();
	Student st=(Student)sm.find(studentId);

    JsfTool jt=JsfTool.getInstance();
    Date studentBirth2=jt.ChangeToDate(studentBirth, st.getStudentBirth());
    Date studentPhoneDate2=jt.ChangeToDate(studentPhoneDate, st.getStudentPhoneDate());
    Date vd=jt.ChangeToDate(studentVisitDate, st.getStudentVisitDate());

	st.setStudentMobileDefault(mobileDefault);
	st.setStudentEmailDefault(emailDefault);
	st.setStudentPhoneDefault(phoneDefault);
	st.setStudentSkypeDefault(skypeDefault);
	st.setStudentFatherSkype(fatherSkype);
	st.setStudentMotherSkype(motheSkype);
	
	st.setStudentName(studentName);
	st.setStudentNickname(studentNickname);
	st.setStudentSex(studentSex);
	st.setStudentBirth(studentBirth2);
	st.setStudentBrother(studentBrother);
	st.setStudentBigSister(studentBigSister);
	st.setStudentYoungBrother(studentYoungBrother);
	st.setStudentYoungSister(studentYoungSister);
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
	st.setStudentGohome(studentGohome);
	st.setStudentSchool(studentSchool);
	st.setStudentSpecial(studentSpecial);
	
	st.setStudentStatus   	(studentStatus);
	st.setStudentPhoneTeacher(studentPhoneTeacher);
	st.setStudentPhoneDate(studentPhoneDate2);
	st.setStudentPs(studentPs);
	if(!studentVisitDate.equals(""))
		st.setStudentVisitDate(vd);
	
	
	sm.save(st);
%>
修改完成!

