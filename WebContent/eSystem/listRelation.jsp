<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=5;
%>
<%@ include file="topMenu.jsp"%>

<%
    if(!checkAuth(ud2,authHa,604))
    {
        response.sendRedirect("authIndex.jsp?code=604");
    }    
	JsfAdmin ja=JsfAdmin.getInstance();	
	Relation[] ra=ja.getAllRelation(_ws.getStudentBunitSpace("bunitId"));
%>
<%@ include file="leftMenu4.jsp"%>

<br> 

<br> 
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;親屬關係列表</b> 
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
    <div class=es02>
	<form action="addRelation2.jsp" method=post>
        <img src="pic/add.gif" border=0 width=12>&nbsp;新增親屬關係
        <input type=text name=rName size=20>
        <input type=submit value="新增">
	</form>
    </div>
</blockquote>
<blockquote>
<%	
	
	
	if(ra==null)
	{
%>
	<br>
	<br>
    <div class=es02>尚無資料!</div>    
<%
		return;
	}
%>
	<table width="30%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle>
			親屬關係
		</td>
		<td>
		</td>
	</tr>
	

<%	
	for(int i=0;i<ra.length;i++)
	{
%>
<tr class="normal"  bgcolor=ffffff onmouseover="this.className='highlight'" onmouseout="this.className='normal'">	
		<form action="deleteRelation.jsp" onSubmit="return(confirm('確認修改此親屬關係?'))">
		<td class=es02 bgcolor=ffffff>
		
			<input type=text name="rName" value="<%=ra[i].getRelationName()%>" size=10>
		</td>
		
		<td class=es02 bgcolor=ffffff> 
			
			<input type=hidden name="rId" value="<%=ra[i].getId()%>">
			<input type=submit value="修改">
			</form>
		</td>		
	</tr>

<%		
	}
%>
</table>
</td></tr></table>


</blockquote> 


<%@ include file="bottom.jsp"%>	