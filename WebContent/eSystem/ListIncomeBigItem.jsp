<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>

<blockquote>
<br>

<font color=blue><h3>雜費收入項目管理</h3></font>
<%

 JsfAdmin ad=JsfAdmin.getInstance();
 
 IncomeBigItem[] bis=ad.getAllIncomeBigItem2();
 
 if(bis==null)
 {
%>

<br>
<table>
<tr bgcolor="#c9c9c9"><td colspan=4 height=10></td></tr>

<tr>
	<td colspan=2>
	<form action="AddIncomeBigItem2.jsp" method="post">
	<input type=text name="newBigItemName"><input type=submit value="新增主項目">
	</td>
	<td colspan=2>
	</form>
	</td>
	</tr>	
</table> 
 	<%@ include file="bottom.jsp"%>

<% 	
 	return;
 }
 
 %>
 
 <table>
 	<tr bgcolor="#c9c9c9">
 	<td>主項目</td><td>狀態</td><td>次項目</td><td></td><td></td>
 	</tr>
<%
 for(int i=0;i<bis.length;i++)
 {
 	out.print("<tr><td>");
 	int bitActive=bis[i].getIncomeBigItemActive();
 %>	
 	<form action="ModifyIncomeBigItem2.jsp" method=post>
 	<font color=red>*</font>
 	<input type="text" name="biName" value="<%=bis[i].getIncomeBigItemName()%>" size=15>
	
	</td> 
	
 	<td>
 	
 	<input type=radio name="iActive" value=1 <%=(bitActive==1)?"checked":""%>>運作中
 	<input type=radio name="iActive" value=0 <%=(bitActive==0)?"checked":""%>>取消
	<input type=hidden name=id value="<%=bis[i].getId()%>">
	<input type=submit onClick="return(confirm('確認修改主項目名稱及狀態?'))" value="修改">
	</form>
	</td>
	<td>
	<td></td><td></td><tr>
	
	
	
<%
	IncomeSmallItem[] si=ad.getAllIncomeSmallItemByBID(bis[i].getId());
	
	if(si !=null)
	{
%>
	
<%	
	
		for(int j=0;j<si.length;j++)
		{
			String isiName=si[j].getIncomeSmallItemName();
			int isiActive=si[j].getIncomeSmallItemActive();
			
%>
			<tr><td></td><td></td>
			<td>
			<form action="modifyIncomeSmallItem3.jsp" method="post">
			<input type=text name="isiName" value="<%=isiName%>">
			</td>
			<td>
			<input type=radio name="isiActive" value=1 <%=(isiActive==1)?"checked":""%>>運作中
			<input type=radio name="isiActive" value=0 <%=(isiActive==0)?"checked":""%>>取消
			<input type=hidden name="sid" value="<%=si[j].getId()%>">
			<input type=hidden name="directTo" value="ListIncomeBigItem.jsp">
			<input type=submit onClick="return(confirm('確認修改 <%=isiName%>的名稱及狀態?'))" value="修改">
			</form>
			</td>
			</tr>
<%		
		
		}	
	}
%>

	<tr><td></td><td></td>
	<td>
	<form action="addIncomeSmallItem2.jsp" method="post"> 
	<input type=text name="isiName" value="">
	</td>
	<td>
	<input type="hidden" name="bigItemId" value="<%=bis[i].getId()%>">
	<input type=hidden name="directTo" value="ListIncomeBigItem.jsp ">
	<input type=submit value="新增次項目">
	</form>
	</td>
	</tr>
	
<%
 }
%>	
<tr bgcolor="#c9c9c9"><td colspan=4 height=10></td></tr>
<tr>
	<td colspan=2>
	<form action="AddIncomeBigItem2.jsp" method="post">
	<input type=text name="newBigItemName"><input type=submit value="新增主項目">
	
	
	</td>
	<td colspan=2>
	
	</td>
	</tr>	

</table> 

</blockquote>
 <%@ include file="bottom.jsp"%>

