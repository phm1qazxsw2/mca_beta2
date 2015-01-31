<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTopNotLogin.jsp"%>
<%
    String indexId=request.getParameter("indexId");
    String mid=request.getParameter("mid");
    String teacherIdS=request.getParameter("teacherId");
    
    int teacherId=Integer.parseInt(teacherIdS);

    String email=request.getParameter("email").trim();

    TeacherMgr tm=TeacherMgr.getInstance();
    Teacher tea=(Teacher)tm.find(teacherId);
    tea.setTeacherEmail(email);
    tm.save(tea);
    
    response.sendRedirect("loginTeacherEmail.jsp?indexId="+indexId+"&m=1");

%>

