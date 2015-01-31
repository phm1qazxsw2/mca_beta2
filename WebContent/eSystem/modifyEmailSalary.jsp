<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
	String m=request.getParameter("m");
    EsystemMgr em=EsystemMgr.getInstance();	
	Esystem e=(Esystem)em.find(1);
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/email.png" border=0>&nbsp;Email 薪資條設定</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action="modifyEmailSalary2.jsp" method="post">

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>Email形式</td>
	<td  class=es02>
		<input type=radio name="paySystemNoticeEmailType" value="0" <%=(e.getEsystemEmailType()==0)?"checked":""%>>純文字
		<input type=radio name="paySystemNoticeEmailType" value="1" <%=(e.getEsystemEmailType()==1)?"checked":""%>>HTML格式
	</td>
</tr> 
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>Email預設標題</td>
<td class=es02>
	<input type=text name="paySystemNoticeEmailTitle" size=50 value="<%=(e.getEsystememailTitle()!=null)?e.getEsystememailTitle():""%>">
	<br>
</td>
</tr>
 


<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>Email預設內容</td>
<td class=es02>
	<textarea name="paySystemNoticeEmailText" cols=60 rows=15><%=(e.getEsystemEmailContent()!=null)?e.getEsystemEmailContent():""%></textarea>
		<br><br>
		說明:<br>
		1 代號規則:  以 <font color=blue>XXX</font> 表示<%=(pZ2.getCustomerType()==0)?"教職員姓名":"員工"%>   <font color=blue>YYY</font> 表示薪資條編號<br>
		2 Email標題及內容皆適用		
		</td>
</tr> 


<tr bgcolor=#ffffff align=left valign=middle>
<td colspan=2 class=es02><center><input type=submit value="修改"></center></td>
</tr>
</form>
</table>

</td></tr></table>
</blockquote>

<%
	if(m !=null)
	{
%>
	<script>
		alert('修改完成!');
	</script>		
<%	
	}
%>

<%@ include file="bottom.jsp"%>