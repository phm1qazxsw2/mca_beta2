<%@ page import="jsf.*" contentType="text/html;charset=UTF-8"%>
<%    
    WebSecurity ws = WebSecurity.getInstance(pageContext);
    String user=request.getParameter("user");
    String pwd=request.getParameter("pwd");  
    String num=request.getParameter("num");
    String pagex=request.getParameter("page");
%>
<form name="xs" id="xs" action='<%=pagex%>.jsp' method='POST'>
<input type=hidden name="<%=ws.getDoLoginSubmitName()%>" value="admin">
<input type=hidden name='<%=ws.getLoginIdElementName()%>' value="<%=user%>">
<input type=hidden name='<%=ws.getPasswordElementName()%>' value="<%=pwd%>">
<input type=hidden name='num' value="<%=num%>">
<input type="submit" value="test" style="display:none;"> 
</form>

<script>
    document.xs.submit();
</script>