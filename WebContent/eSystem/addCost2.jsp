<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
JsfTool jt=JsfTool.getInstance();
JsfAdmin ja=JsfAdmin.getInstance();

BigItem[] bi=ja.getAllActiveBigItem();

User[] u=ja.getLogUsers();

if(bi==null)
{
	out.println("尚未設定支出主項目!!<br><br>");
%>
	<a href="#" onClick="javascript:openwindow19();return false">編輯主項目</a>
<%
	return;
}

%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<br>
<blockquote>
<font color=blue><h3>支出登入頁</h3></font>
<%
String x=request.getParameter("fi");

if(x!=null)
{
	out.println("<font color=red>*</font>上筆資料登入完成!<br>");
}
%>


<form action="addCost3.jsp" method="post" name="ax">
<table>
	<tr>
		<td bgcolor="lightgrey">入帳日期</td>
		<td><input type=text name=costDate value="<%=jt.ChangeDateToString(new java.util.Date())%>" size=10></td>
	</tr>
	
	
	<tr>
		<td bgcolor="lightgrey">項目
		<a href="#" onClick="javascript:openwindow19();return false">修改</a>
		</td>
		<td>
	<select name="b" size=1 onChange="getIncomeSmallItem2(this.form.b.value)">
	<option value="0">無
	<%
	  	for(int i=0;i<bi.length;i++)
	  	{
	  %>
	  	<option value=<%=bi[i].getId()%>><%=bi[i].getBigItemName()%>
	
	  <%
	  	}
	  %>
	</select>
		</td>
		  
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">次項目</td>
		<td>
		<div class="right_content3" id="realtime" name="realtime"></div>
		</td>
	</tr>
		
		
		
	</tr>
	<tr>
		<td bgcolor="lightgrey">受款人</td>
		<td><input type=text name="costTo" size=10></td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">摘要</td>
		<td>
			<textarea name=costSum cols="40" rows="3"></textarea>
		</td>
	
	<tr>
		<td bgcolor="lightgrey"><font color=red>*</font>金額</td>
		<td>
		<input type=text name=costMoney size=10>	
		</td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">付款方式</td>
		<td>
			<input type=radio name=payWay value=1 checked>現金<br>
			<input type=radio name=payWay value=2>匯款<br>
			<input type=radio name=payWay value=3>支票<br>
			<input type=radio name=payWay value=4>其他
		</td>
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">記帳人</td>
		<td>
		    <select name="costLog" size=1>
		    <%
		    	for(int i =0;i<u.length ;i++)
		    	{
		    %>	
		    	<option value="<%=u[i].getId()%>"><%=u[i].getUserFullname()%></option>
		   <%
		   	}
		   %>
		    </select>	
		</td>
	</tr>
	
	<tr>
		
		<td colspan=2><center><input type=submit value=登入></td>
	</tr>	
</form>	
</table>
</blockquote>
<%@ include file="bottom.jsp"%>