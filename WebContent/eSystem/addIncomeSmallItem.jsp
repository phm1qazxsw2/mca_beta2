<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
 request.setCharacterEncoding("UTF-8");
  
 String BIname=request.getParameter("BIname");	 
 int bID=Integer.parseInt(request.getParameter("bigItemId")); 

%>
<font color="red"><h3><%=BIname%></font>新增收入次項目</h3>


<br><br>
<form action="addIncomeSmallItem2.jsp" method="post">
<table>
<tr>
	<td>次項目名稱</td>
	<td>
	<input type=text name=itemName>
	</td>
</tr>
<tr>
	<td colspan=2><center>
	<input type=hidden name="bid" value="<%=bID%>">
	<input type=submit value="新增">
	</center></td>
</tr>
</form>

</table>

