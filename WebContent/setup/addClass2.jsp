<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%

 request.setCharacterEncoding("UTF-8");
  
 String classesName=request.getParameter("className");	 
 String classesEName=request.getParameter("classEName");
  
 String allPeople=request.getParameter("allPeople");
 int allPeopleX=Integer.parseInt(allPeople); 

 Classes cl=new Classes();
 
 cl.setClassesName(classesName);
 cl.setClassesEnglishName(classesEName);
 cl.setClassesStatus(1); 
 cl.setClassesAllPeople(allPeopleX);
 ClassesMgr cm=ClassesMgr.getInstance();
 
 cm.createWithIdReturned(cl);
 
	response.sendRedirect("listClass.jsp");
 %>
 
