<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,java.util.*,java.util.zip.*" contentType="text/html;charset=UTF-8"%>
<%
    WebSecurity __ws = WebSecurity.getInstance(pageContext);
    __ws.clearSession();    

    session.invalidate();
%>
<script>
    location.href = "index.jsp";
</script>