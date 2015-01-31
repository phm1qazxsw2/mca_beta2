<%@ page language="java" import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%><%
    String FeenumberId = request.getParameter("FeenumberId");
%>
<script>
    if (confirm("帳單將被鎖定,確認產生繳款單?"))
        location.href = "makePDF.jsp?FeenumberId=<%=FeenumberId%>";
    else
    {
        setTimeout("window.close();", 3000);
        document.writeln("<h1>此視窗將在三秒鐘後關閉</h1>");
    }
</script>