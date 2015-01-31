<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="../eSystem/style.css" type="text/css">
<%@ include file="topMenuAdvanced.jsp"%>
<%
    int sid =12; 
    String sidS=request.getParameter("sid");
    if(sidS!=null)
        sid=Integer.parseInt(sidS);
String backurl2="pay_info.jsp?"+request.getQueryString();
%>
 <BR>
<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;銷帳查詢</b>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<center>


<table cellpadding=0 cellspacing=0 border=0 width=800 height=700>
<tr>
    <td valign=top>

<%@ include file="pay_info_detail.jsp"%>


</td>
</tr>
</table>
<%@ include file="bottom.jsp"%>

