<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    String info = request.getParameter("info");
    String sep = request.getParameter("sep");
    String[] lines = info.split("\n");
    int n = 0; %>
 <table border=1>
 <tr>
    <td>中文姓名</td>
    <td>媽媽姓名</td>
    <td>媽媽手機</td>
    <td>電話1</td>
    <td>電話2</td>
    <td>電話3</td>
 </tr>
 <%
    for (int i=0; i<lines.length; i++) {
        if (lines[i].trim().length()==0)
            continue;
        String[] tokens = lines[i].split(sep);
        if (tokens.length>3) {
            System.out.println(tokens[0] + " " + tokens.length + " " + lines[i]);
%>
 <tr>
    <td><%=tokens[0]%></td>
    <td><%=tokens[1]%></td>
    <td><%=tokens[2]%></td>
    <td><%=tokens[3]%></td>
    <td><%=tokens[4]%></td>
    <td><%=tokens[5]%></td>
 </tr>
<%      }
    }
%>
</table>

<form name="f1" action="student_info_parse2.jsp" method="post">
<input type=hidden name=info value="<%=info%>">
<input type=hidden name=sep value="<%=sep%>">
<br>
<input type=submit value="確認並產生">
</form>
