<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");
 	
 	int teacherId=Integer.parseInt(request.getParameter("teacherId"));
 	String teacherFirstName=request.getParameter("teacherFirstName");
 	String teacherLastName=request.getParameter("teacherLastName"); 
	String teacherNickname=request.getParameter("teacherNickname"); 
	String teacherIdNumber=request.getParameter("teacherIdNumber"); 
	String teacherBirth=request.getParameter("teacherBirth"); 
	String teacherSchool=request.getParameter("teacherSchool"); 
	String teacherFather=request.getParameter("teacherFather"); 
	String teacherMother=request.getParameter("teacherMother"); 
	String teacherMobile=request.getParameter("teacherMobile"); 
	String teacherPhone=request.getParameter("teacherPhone"); 
	String teacherAddress=request.getParameter("teacherAddress"); 
	String teacherEmail=request.getParameter("teacherEmail"); 
	String teacherPs=request.getParameter("teacherPs"); 
	int teacherSex=0;
    try { teacherSex = Integer.parseInt(request.getParameter("teacherSex")); } catch (Exception e) {}
	String teacherMobile2=request.getParameter("teacherMobile2");
	String teacherMobile3=request.getParameter("teacherMobile3");
	String teacherPhone2=request.getParameter("teacherPhone2"); 
	String teacherPhone3=request.getParameter("teacherPhone3"); 
	String teacherZipCode=request.getParameter("teacherZipCode"); 
		
	TeacherMgr tm=TeacherMgr.getInstance();
	Teacher tea=(Teacher)tm.find(teacherId);

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	JsfTool jt=JsfTool.getInstance();
	Date teacherBirth2 = null;
    try { teacherBirth2 = sdf.parse(teacherBirth); } catch (Exception e) {}

	tea.setTeacherFirstName   	(teacherFirstName);
	tea.setTeacherLastName   	(teacherLastName);
	tea.setTeacherSex(teacherSex);
	//tea.setTeacherUserId   	(int teacherUserId);
	tea.setTeacherNickname   	(teacherNickname);
	tea.setTeacherEmail   	(teacherEmail);
	tea.setTeacherIdNumber   	(teacherIdNumber);
	tea.setTeacherBirth   	(teacherBirth2);
    tea.setTeacherBirth(teacherBirth2);
    
    tea.setTeacherSchool   	(teacherSchool);
	
	tea.setTeacherMobile   	(teacherMobile);
	tea.setTeacherPhone   	(teacherPhone);
	tea.setTeacherAddress   	(teacherAddress);
	
	tea.setTeacherPs   	(teacherPs);
	
	tea.setTeacherMobile2(teacherMobile2);
	tea.setTeacherMobile3(teacherMobile3);
	tea.setTeacherPhone2(teacherPhone2);
	tea.setTeacherPhone3(teacherPhone3);
	tea.setTeacherZipCode(teacherZipCode);
		
	tm.save(tea);
    phm.ezcounting.Membr m = phm.ezcounting.MembrMgr.
        getInstance().find("type=" + Membr.TYPE_TEACHER + " and surrogateId=" + tea.getId());
    m.setName(tea.getTeacherFirstName()+tea.getTeacherLastName());
    m.setBirth(tea.getTeacherBirth());
    phm.ezcounting.MembrMgr.getInstance().save(m);
    response.sendRedirect("modifyTeacher.jsp?teacherId=" + teacherId);
%>
