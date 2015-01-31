<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
 
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;Upload Co-operation Bank Data</b>
</div> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<b>New format (from excel)</b><br>
<form action="mca_coop3.jsp" method=post>
<textarea name="data" cols=70 rows=15></textarea>
<br>
<input type=submit value="Submit">
</form>
</blockquote>
<hr>
<blockquote>
<b>Old format (from txt)</b><br>
<form action="mca_coop2.jsp" method=post>
<textarea name="data" cols=70 rows=15></textarea>
<br>
<input type=submit value="Submit">
</form>
</blockquote>

<%@ include file="bottom.jsp"%>	
