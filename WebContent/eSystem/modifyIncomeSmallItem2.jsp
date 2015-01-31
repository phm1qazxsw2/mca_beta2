<%@ page language="java" buffer="32kb" import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
 request.setCharacterEncoding("UTF-8");
 int sID=Integer.parseInt(request.getParameter("sid")); 
 JsfAdmin ja=JsfAdmin.getInstance();
 IncomeSmallItem si=ja.getIncomeSmallItemById(sID);
%>

 <h3>次選項修改頁</h3>

<form action="modifyIncomeSmallItem3.jsp" method="post">
<table>
	
	<tr>
		<td>名稱</td><td>
		<input type=text name=smallItem value=<%=si.getIncomeSmallItemName()%>>
		</td>
	</tr>
	
	<tr>
		<td>狀態</td>
		<td>
		<input type=radio name="smallActive" value=1 <%=si.getIncomeSmallItemActive()==1?"checked":""%>>運作中
		<input type=radio name="smallActive" value=0 <%=si.getIncomeSmallItemActive()==0?"checked":""%>>取消
		</td>
	</tr>
	<tr>
		<input type=hidden name=sid value="<%=si.getId()%>">
		<td colspan=2>
		<center>
			<input type=submit value="修改">
		</center>	
		</td>
	</tr>
</table>
</form>
<br>
<br>

<a href=ListIncomeBigItem.jsp>管理收入主項目</a>
