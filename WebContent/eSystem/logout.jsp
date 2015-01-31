 <%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
 <link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>

</td>
<td height=430>
 <%
 
 session.invalidate();
   
%>


<table>
<tr>
<td height=350 width="80%">

<center>
    <div class=es02>謝謝你的使用,本系統已為你<font color=blue>登出</font>!</div>

<br>
<br>
<a href="index.jsp">回首頁</a>
</center>

</td>
</tr> 

</table> 

<%@ include file="bottom.jsp"%>
 

