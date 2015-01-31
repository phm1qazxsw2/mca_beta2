<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
 	request.setCharacterEncoding("UTF-8");	
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
		
 	String studentName=request.getParameter("studentName");
 	String studentNickname=request.getParameter("studentNickname"); 
 	int studentSex=1;
    try { studentSex=Integer.parseInt(request.getParameter("studentSex")); } catch (Exception e) {}
	String studentIDNumber=request.getParameter("studentIDNumber"); 
	String studentBirth=request.getParameter("studentBirth");
	String studentPs=request.getParameter("studentPs"); 
	int studentBrother=Integer.parseInt(request.getParameter("studentBrother")); 
 	int studentBigSister=Integer.parseInt(request.getParameter("studentBigSister")); 
 	int studentYoungBrother=Integer.parseInt(request.getParameter("studentYoungBrother")); 
 	int studentYoungSister=Integer.parseInt(request.getParameter("studentYoungSister")); 			

	String studentNumber=request.getParameter("studentNumber"); 
	String studentShortName=request.getParameter("studentShortName"); 
	
	String bloodType=request.getParameter("bloodType"); 

	StudentMgr sm=StudentMgr.getInstance();
	Student st=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 

    JsfTool jt=JsfTool.getInstance();


	Date studentBirth2=null;
    if(studentBirth !=null && studentBirth.length()>0){        
        studentBirth2=JsfTool.saveDate(studentBirth);
    }

	st.setStudentName(studentName);
    st.setStudentNumber(studentNumber);
    st.setStudentShortName(studentShortName);
	st.setStudentNickname   	(studentNickname);
	st.setStudentSex(studentSex);
	st.setStudentIDNumber(studentIDNumber);
	st.setStudentBirth(studentBirth2);
	st.setStudentPs   	(studentPs);
	st.setStudentBrother(studentBrother);
	st.setStudentBigSister(studentBigSister);
	st.setStudentYoungBrother(studentYoungBrother);
	st.setStudentYoungSister(studentYoungSister);

    st.setBloodType(bloodType);
	sm.save(st);

    phm.ezcounting.Membr m = phm.ezcounting.MembrMgr.
        getInstance().find("type=" + Membr.TYPE_STUDENT + " and surrogateId=" + st.getId());
    m.setName(st.getStudentName());
    m.setBirth(st.getStudentBirth());
    phm.ezcounting.MembrMgr.getInstance().save(m);

%>


&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=st.getStudentName()%></font> -<img src="pic/fix.gif" border=0>聯絡資訊<br><br>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
	<br>
	<br>
	<blockquote>
		<div class=es02>修改完成!</div>
	
	<br><br>
	<a href="modifyStudent.jsp?studentId=<%=studentId%>">回詳細資料</a>

	
	</blockquote>