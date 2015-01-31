<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=3;
%>
<%@ include file="topMenu.jsp"%>

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
		<img src="pic/add.gif" border=0 width=12>&nbsp;<b>新增收費項目統稱</b>
</div>
    <form action="add_item_alias.jsp" method="post"> 
    <blockquote> 
        <input type=text name="name" value="">
        <input type=submit value="新增">
    </blockquote>
    </form>


<%
    ArrayList<Alias> aliases = AliasMgr.getInstance().retrieveListX("", "", _ws.getMetaBunitSpace("bunitId"));
    if(aliases.size()==0){
%>
        <%@ include file="bottom.jsp"%>
<%
        return;
    }
%>
<div class=es02>
<B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0 width=12>&nbsp;收費項目統稱管理</b>
</div>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote> 

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 align=left valign=middle>
	<td class=es02><b>名稱</b></td>
	<td class=es02><b>狀態</b></td>
	<td class=es02></td>
</tr>

<%
	
    Iterator<Alias> iter = aliases.iterator();
    while (iter.hasNext())
	{
        Alias a = iter.next();		
%>
	<form action="modify_item_alias.jsp" method="post">		
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		
	
		<td class=es02>
		<input type=text name="name" value="<%=a.getName()%>">
		</td>
		<td class=es02>
		<input type=radio name="status" value=1 <%=(a.getStatus()==Alias.STATUS_ACTIVE)?"checked":""%>>運作中
		<input type=radio name="status" value=0 <%=(a.getStatus()!=Alias.STATUS_ACTIVE)?"checked":""%>>取消 
		</td>
		<td>
		
        <input type=hidden name="id" value="<%=a.getId()%>">
		<input type=submit onClick="return(confirm('確認修改 <%=a.getName()%>的名稱及狀態?'))" value="修改">
		
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
