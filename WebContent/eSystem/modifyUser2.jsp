<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
 request.setCharacterEncoding("UTF-8");
  
 String userLoginId=request.getParameter("userLoginId");
 String userPassword=request.getParameter("userPassword");
 int userRole=Integer.parseInt(request.getParameter("userRole"));
 String userFullname=request.getParameter("userFullname");
 String userEmail=request.getParameter("userEmail");
 String userPhone=request.getParameter("userPhone");
 int userId=Integer.parseInt(request.getParameter("userId")); 
 //int userEmailReport=Integer.parseInt(request.getParameter("userEmailReport"));
 int userActive=Integer.parseInt(request.getParameter("userActive"));
 int userBunitCard=Integer.parseInt(request.getParameter("userBunitCard"));  
 
 int userConfirmUpdate=Integer.parseInt(request.getParameter("userConfirmUpdate"));
 

UserMgr umgr = UserMgr.getInstance();
User tmp = umgr.findLoginId(userLoginId);
if (tmp!=null && tmp.getId()!=userId) {
    response.sendRedirect("userExists.jsp");
    return;
}

UserMgr um=UserMgr.getInstance();
User us=(User)um.find(userId);

us.setUserLoginId   	(userLoginId);
if (!userPassword.equals("--password--"))
 us.setUserPassword   	(userPassword);
us.setUserFullname   	(userFullname);
us.setUserEmail   	(userEmail);
us.setUserPhone   	(userPhone);
us.setUserRole   	(userRole);

us.setUserActive(userActive);
us.setUserBunitCard(userBunitCard);
us.setUserConfirmUpdate(userConfirmUpdate);

um.save(us);

response.sendRedirect("listUser.jsp?m=1");
%>

