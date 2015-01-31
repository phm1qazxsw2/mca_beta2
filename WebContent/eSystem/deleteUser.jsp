<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
JsfAdmin ja=JsfAdmin.getInstance();		
int uRole=ud2.getUserRole();
	
if(uRole >=3)
{
%>
	<%=ud2.getUserFullname()%>(<%=ja.getChineseRole(ud2.getUserRole())%>)-
	<font color=red>沒有<b>刪除使用者</b>權限!!</font>
	
	<%@ include file="bottom.jsp"%>
<%
	return;
}


 
 int userId=Integer.parseInt(request.getParameter("userId"));

 UserMgr um=UserMgr.getInstance();
 
 um.remove(userId);

 response.sendRedirect("listUser.jsp");
%>