<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

<%@ include file="leftMenu2.jsp"%>

<%
if(!AuthAdmin.authPage(ud2,4))
{
    response.sendRedirect("authIndex.jsp?page=6&info=1");
}

JsfTool jt=JsfTool.getInstance();
JsfAdmin ja=JsfAdmin.getInstance();

BigItem[] bi=ja.getAllActiveBigItem();
User[] u=ja.getLogUsers();

if(bi==null)
{
	out.println("<br><br>尚未設定支出主項目!!<br><br>");
%>
	<a href="ListBigItem.jsp">編輯主項目</a>

	<%@ include file="bottom.jsp"%>
<%
	return;
}
 

Costtrade[] ct=ja.getActiveCosttrade();
 
if(ct==null)
{
	out.println("<br><br><blockquote>尚未設定交易對象!!<br><br>");
%>
	<a href="#" onClick="javascript:openwindow71();return false">新增</a>
	
	</blockquote>
	<%@ include file="bottom.jsp"%>
<%
	return;
}
 

int type=Integer.parseInt(request.getParameter("type"));

%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<script>
 
	function goX()
	{
 
		window.location.reload();
	}
</script>

<br>
<blockquote>
 

<%
String x=request.getParameter("fi");

if(x!=null)
{
	out.println("<font color=red>*</font>上筆資料登入完成!<br>");
}
%>
<table>
<tr>
	<td class=es02>

<% if(type==1){ %>
 	<img src="pic/ticketA2.gif" border=0 alt="新增支出傳票"> <font color=blue>&nbsp;新增支出傳票</font>
<% }else{  %>
    <img src="pic/add.gif" border=0><font color=red>&nbsp;新增收入傳票</font>
<% } %>


<form action="addCostbook2.jsp" method="post" name="ax" id="ax">
	<table width="" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr>
		<td bgcolor=#f0f0f0 class=es02 nowrap>入帳日期</td>
		<td bgcolor=#ffffff class=es02><input type=text name=costDate value="<%=jt.ChangeDateToString(new java.util.Date())%>" size=20 onkeyup="javascript:showWord('Xdate',this.form.costDate.value)"></td>
	</tr>
	
		
	</tr>
	<tr>
		<td  bgcolor=#f0f0f0 class=es02>交易對象</td>
		<td bgcolor=#ffffff class=es02>
			<select size=1 name="costtradeId">
			<%
				for(int k=0;k<ct.length;k++)
 
				{
			%>
				<option value="<%=ct[k].getId()%>"><%=ct[k].getCosttradeName()%></option> 
			<%
				}
			%>		
			</select> 
				<a href="#" onClick="javascript:openwindow71();return false">新增</a>
		</td>
	</tr>
 
	<tr>
		<td bgcolor=#f0f0f0 class=es02 nowrap>
			<font color=red>*</font>傳票抬頭</td>
		<td bgcolor=#ffffff class=es02>
		<input type=text name="costbookName" size=20 onkeyup="javascript:showWord('Xtitle',this.form.costbookName.value)">	
		</td>
	</tr>
	

	
  	<tr>
		<td bgcolor=#f0f0f0 class=es02 nowrap>
			附件狀態</td>
		<td bgcolor=#ffffff class=es02>
			<input type=radio name=attachStatus value=1 checked>未附
			<input type=radio name=attachStatus value=2>不完整
			<input type=radio name=attachStatus value=99>完整
		</td>
	</tr>
 
<%
if(type==1)
{
%>
	
	<tr>
		<td bgcolor=#f0f0f0 class=es02>
			附件方式</td>
		<td bgcolor=#ffffff class=es02>
			<input type=radio name=attachway value=1 checked>無<br>
			<input type=radio name=attachway value=91>統一發票<br> 
			<input type=radio name=attachway value=93>收據
		</td>
	</tr>
<% }else{  %>
		<input type="hidden" name="attachway" value="1">
		
<%  }  %>



	
	<tr>
		<td bgcolor=#f0f0f0 class=es02 nowrap>
			登入註記</td>
		<td bgcolor=#ffffff class=es02>
			<textarea name=ps cols="20" rows="3"></textarea>
		</td>
	</tr>
	
	
	
	
	<tr>
		
		<input type=hidden name="typeX" value="<%=type%>">
		<td colspan=2><center><input type=submit value=產生傳票號碼></td>
	</tr>	
</form>	
</table>
 

	</td>
	</tr>
	</table>
</blockquote>
 

	</tD>
	<td valign=middle>
	
		<table background="pic/<%=(type==0)?"in":""%>ticket.gif" width=480>
			<tr class=es02 height=20>
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr>
 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250>
						
						<div id="Xtitle"></div>
				
				</tD>
				<tD width=80></tD>
			</tr>
			<tR  class=es02 height=10> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr>
 
			<tR  class=es02 height=20> 	
				<tD width=150>
				
<% if(type==1){ %>
 	<font color=blue>(借)</font>
<% }else{  %>
	<font color=red>(貸)</b></font>
<% } %>

				</tD>
				<tD width=250><div id="Xdate"></div></tD>
				<tD width=80></tD>
			</tr> 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 

			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 

			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 
			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80></tD>
			</tr> 

			<tR  class=es02 height=20> 	
				<tD width=150></tD>
				<tD width=250></tD>
				<tD width=80><%=ud2.getUserFullname()%></tD>
			</tr> 
		</table>
			 	
	
	</td>
	</tR>
	</table>

<script>
	
<!--
  	
	function showWord(divName,wordValue)
 
	{ 
 
		var aa=document.getElementById(divName);
		aa.innerHTML=wordValue;
	} 
 
	
	document.getElementById('Xdate').innerHTML=document.ax.costDate.value;
  	document.ax.costbookName.focus(); 	

	//-->

</script>


<%@ include file="bottom.jsp"%>