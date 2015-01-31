<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%> 
<%@ include file="leftMenu2.jsp"%>

<%
request.setCharacterEncoding("UTF-8");
JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();

IncomeBigItem[] bi=ja.getAllIncomeActiveBigItem();

if(bi==null)
{
%> 
<br>
<br>
<blockquote>
	尚未設定主項目!!
	<br>
	<br>
	<a href="ListIncomeBigItem.jsp">編輯主項目</a>
</blockquote>	
	<%@ include file="bottom.jsp"%>
<%
	return;
}

User[] um2=ja.getLogUsers();

%>
<head>

<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="openWindow.js"></script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>

</head>

<body>
<font color=blue><h3>收入登入頁</h3></font>

<%
String x=request.getParameter("fi");

if(x!=null)
{
	out.println("<font color=red>*</font>上筆資料登入完成!<br>");
}
%>
<form action="addIncome3.jsp" method="post" name="ax">
<table>
	
	<tr>
		<td bgcolor="lightgrey">入帳日期</td>
		<td><input type=text name=costDate value="<%=jt.ChangeDateToString(new java.util.Date())%>" size=10></td>
	</tr>


	<tr>
		<td bgcolor="lightgrey">主項目
		<a href="#" onClick="javascript:openwindow17();return false">修改</a>
		</td>
		<td>
	
	<select name="b" size=1 onChange="getIncomeSmallItem(this.form.b.value)">
		
	<option value="0">無</option>
		
<%
  	for(int i=0;i<bi.length;i++)
  	{
  %>
  	<option value=<%=bi[i].getId()%>><%=bi[i].getIncomeBigItemName()%></option>

  <%
  	}
  %>
	</select>
	
		
		</td>
		  
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">次項目</td>
		<td>
		<div class="right_content3" id="realtime"></div>
		</td>
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">繳款人</td>
		<td><input type=text name="costTo" size=10></td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">摘要</td>
		<td>
			<textarea name=costSum cols="40" rows="3"></textarea>
		</td>
	
	<tr>
		<td bgcolor="lightgrey">金額</td>
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
		    	for(int i =0;i<um2.length ;i++)
		    	{
		    %>	
		    	<option value="<%=um2[i].getId()%>"><%=um2[i].getUserFullname()%></option>
		   <%
		   	}
		   %>
		    </select>	
		</td>
		
		<input type="hidden" name="costLog" value="<%//u.getId()%>"><%//u.getUserFullname()%>
		   
		</td>
		
	</tr>
	
	<tr>
		
		<td colspan=2><center><input type=submit value=登入></td>
	</tr>	
</form>	
</table>
</body> 

<%@ include file="bottom.jsp"%>
