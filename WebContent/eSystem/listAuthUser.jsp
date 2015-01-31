<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%

if(!AuthAdmin.authPage(ud2,2))
{
    response.sendRedirect("authIndex.jsp?page=9&info=1");
}

 JsfAdmin ja=JsfAdmin.getInstance();
 User[] u2=ja.getAllRunUsers(_ws.getBunitSpace("userBunitAccounting"));
 
 
 int uRole=ud2.getUserRole();

String m=request.getParameter("m");
 

 SimpleDateFormat sdfLog=new SimpleDateFormat("MM/dd HH:mm");
%>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/key2.png" border=0> <b>權限管理</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<BR> 
<blockquote>
<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>姓名</td>
	<td bgcolor=#f0f0f0 class=es02>使用狀態</td>
	<td bgcolor=#f0f0f0 class=es02>登入身份</td>
    <td bgcolor=#f0f0f0 class=es02></td>
</tr>	
<% 


 for(int i=0;u2!=null&&i<u2.length;i++)
 {

    if(u2[i].getUserRole()<=2)
        continue;
        
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
	
	<td class=es02><%=u2[i].getUserFullname()%></td>
 
	<td class=es02 nowrap>
 
	<%
		int active=u2[i].getUserActive();
		
		if(active==1)
 
		{ 
			out.println("<img src=\"pic/yes2.gif\" border=0>&nbsp;使用中");		
		} else{
			out.println("<img src=\"pic/no2.gif\" border=0>&nbsp;停用");	
		}

	%>
	</td>	
    <td class=es02><%=ja.getChineseRole(u2[i].getUserRole())%></td>
    <td class=es02 align=middle>	        
    		<a href="authUser.jsp?userId=<%=u2[i].getId()%>">編輯權限</a> 
	</td>
<%
}
%>
</tr>
</table>

</td></tr></table>
 
	<br>
	<br>
 
	
</blockquote>

<%
if(m!=null)
 
{ 
%> 
	<script>
		alert('修改完成!');
	</script>
<%
}
%>
<%@ include file="bottom.jsp"%>