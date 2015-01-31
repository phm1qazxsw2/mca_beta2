<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,201))
    {
        response.sendRedirect("authIndex.jsp?code=201");
    }
%>
<%@ include file="leftMenu2-new.jsp"%>
<%
SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
int tp = 0;
try { tp = Integer.parseInt(request.getParameter("type")); } catch (Exception e) {}

int scriptType=0;

String cond = "";
if(tp==1) {
    scriptType=2;
    cond = "t=4&t=7";
}
else if(tp==0) {
    scriptType=1;
    cond = "t=5&t=6&t=7";
}
%>
<br>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;<b>
<%
    if(tp==0)
        out.println("<img src=pic/costAdd.png border=0>&nbsp;新增支出");        
    else
        out.println("<img src=pic/incomeAdd.png border=0>&nbsp;新增收入");                
%>
</b>

&nbsp;&nbsp;&nbsp;&nbsp;<a href="spending_list.jsp"><img src="pic/last.gif" border=0 width=14>&nbsp;回上一頁</a>
</div>

<%@ include file="spending_content.jsp"%>
<%@ include file="bottom.jsp"%>

<script>
document.xs.action = 'mca_spending_add2.jsp';
document.getElementById("buttons").innerHTML = "<input type=submit value='新增'>";
</script>