<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
 if(!AuthAdmin.authPage(ud2,2))
 {
    response.sendRedirect("authIndex.jsp?page=9&info=1");
 }

 request.setCharacterEncoding("UTF-8");
  
 String userLoginId=request.getParameter("userLoginId");
 String userPassword=request.getParameter("userPassword");
 String userRole=request.getParameter("userRole");
 String userFullname=request.getParameter("userFullname");
 String userEmail=request.getParameter("userEmail");
 String userPhone=request.getParameter("userPhone");

 int userBunitCard=Integer.parseInt(request.getParameter("userBunitCard"));  
       
 User us=new User();
 us.setUserLoginId   	(userLoginId);
 us.setUserPassword   	(userPassword);
 us.setUserFullname   	(userFullname);
 us.setUserActive(1);    
 us.setUserEmail   	(userEmail);
 us.setUserPhone   	(userPhone);
 us.setUserRole   	(Integer.parseInt(userRole));
 us.setUserBunitAccounting(_ws.getSessionBunitId());
 us.setUserBunitCard(userBunitCard);

 JsfAdmin adm = JsfAdmin.getInstance();
    
    try 
    {
        us = adm.createUser(us);
        response.sendRedirect("addUser3.jsp?uid=" + us.getId());
        //response.sendRedirect("listUser.jsp");
        return;
    }	        
    catch (AlreadyExist a)
    {
      %><script>alert("這個帳號已經存在，請重新選取"); history.go(-1);</script><%
        return;
    }    
%>