<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,105))
    {
        response.sendRedirect("authIndex.jsp?code=105");
    }

%>
<%@ include file="leftMenu1.jsp"%>
<script>
<% 
	String m=request.getParameter("m");
	
	if(m!=null && m.equals("1"))
 
	{ 
%>
		alert('修改成功!');
<%
	}else if(m!=null && m.equals("2"))
 
	{ 
%>		
		alert('新增完成!');
<%
	}
%>	
</script>
<br>
<div class=es02>
<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<img src="pic/add.gif" border=0 width=12>&nbsp;<b>新增收入統計項目</b>
</div>
    <form action="addIncomeSmallItem2.jsp" method="post"> 
    <blockquote> 
        <input type=text name="isiName" value="">
        <input type="hidden" name="bigItemId" value="1">
        <input type=hidden name="directTo" value="listStuIncomeItem.jsp">
        <input type=submit value="新增" onClick="javascript:confirm('確認新增?')">
    </blockquote>
    </form>

<div class=es02>
<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0 width=12>&nbsp;收入統計項目管理</b>
</div>
<%
String mo=request.getParameter("mo"); 
 JsfAdmin ad=JsfAdmin.getInstance();
 
IncomeSmallItem[] si=ad.getAllIncomeSmallItemByBID(1);

%>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote> 

<% 
 if(si==null)
 {	
%>
    <div class=es02>
        目前尚未設定.
    </div>

</blockquote>

<%@ include file="bottom.jsp"%>
<% 
	return;
 }
%>

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle>
	<td class=es02><b>項目名稱</b></td>
	<td class=es02><b>狀態</b></td>
	<td class=es02></td>
</tr>

 	
<%	
	for(int j=0;j<si.length;j++)
	{
		String isiName=si[j].getIncomeSmallItemName();
		int isiActive=si[j].getIncomeSmallItemActive();
		
%>
	<form action="modifyIncomeSmallItem3.jsp" method="post">		
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		
	
		<td class=es02>
		<input type=text name="isiName" value="<%=isiName%>">
		</td>
		<td class=es02>
		<input type=radio name="isiActive" value=1 <%=(isiActive==1)?"checked":""%>>運作中
		<input type=radio name="isiActive" value=0 <%=(isiActive==0)?"checked":""%>>取消 
		</td>
		<td>
		
        <input type=hidden name="sid" value="<%=si[j].getId()%>">
		<input type=hidden name="directTo" value="listStuIncomeItem.jsp">
		<input type=submit onClick="return(confirm('確認修改 <%=isiName%>的名稱及狀態?'))" value="修改">
<!--
		<a href="deleteIncomeItem.jsp?sid=<%=si[j].getId()%>" onClick="return confirm('確認刪除?')">刪除</a>
-->
		
		</td>
		</tr> 
		</form>
<%		
	
	}	
	
%>

</td>
</tr>
</table>
</td>
</tr>
</table>

</blockquote>
<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>
