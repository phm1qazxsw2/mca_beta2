<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
JsfAdmin ja=JsfAdmin.getInstance();

Classes[] cl=ja.getAllClasses2();
%>
<br>
<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>班級列表</b>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote> 

	<table width="75%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
    	<td>班級</td><td>班級英文名稱</td><td>滿額數</tD><td>狀態</td><td></td>
     </tr>
<%

if(cl==null)
	return;
for(int i =0;i<cl.length;i++)
{
%>
<form action="modifyClass2.jsp" method=post>	
<tr bgcolor=ffffff class=es02>
    	<td><input type=text name=className value="<%=cl[i].getClassesName()%>"></td>
    	<td><input type=text name=classEName value="<%=cl[i].getClassesEnglishName()%>" size=5></td>
    	<tD><input type=text name=allPeople value="<%=cl[i].getClassesAllPeople()%>" size=3></td>
    	<td><%
    	       int cS=cl[i].getClassesStatus();
    	    %> 
    	     <input type=radio name="status" value=1 <%=(cS==1)?"checked":""%>>使用中 
    	   	<input type=radio name="status" value=0 <%=(cS==0)?"checked":""%>>停用  	 
      	    
    	    </td>
    	<td>
    	
    		<input type=hidden name=classesId value="<%=cl[i].getId()%>">
    		<input type=submit value="修改" onClick="return(confirm('確認修改?'))">
    	
    	</td>
     </tr>
</form>
<%
}
%>
</table>
</td></tr></table> 
<br>
<a href="addClass.jsp"> <img src="pic/add.gif" border=0>新增班級</a>
</blockquote>
