<%@ page import="jsf.*"%>
<%
    WebSecurity ws = WebSecurity.getInstance(pageContext);
    if (!ws.doAuthenticate("/WEB-INF/jsp/login.jsp"))
        return;
%>