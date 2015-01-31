<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%@ include file="authCheck.jsp"%>
<%
    HttpSession session2=request.getSession(true);
    Hashtable authHa=(Hashtable)session2.getAttribute("auth");

    WebSecurity _ws2 = WebSecurity.getInstance(pageContext);
    if(authHa ==null){
        JsfAdmin ja22=JsfAdmin.getInstance();
        User authud2 = _ws2.getCurrentUser();
        authHa=ja22.getHaAuthuser(authud2.getId());    
        session2.setAttribute("auth",authHa);
    }

    User ud2 = _ws2.getCurrentUser();
    PaySystemMgr pmx2=PaySystemMgr.getInstance();
    PaySystem pd2=(PaySystem)pmx2.find(1);
    if(ud2==null)
    {
%>
        <%@ include file="noUser.jsp"%>
<% 
        return;
    }
%>