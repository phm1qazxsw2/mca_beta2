<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=4;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu4.jsp"%>
<br>
<br>
<blockquote>
	<b>新增親屬關係</b>
	<br>
	<br>
	<form action="addRelation2.jsp" method=post>
	<input type=text name=rName size=20>
	<input type=submit value="新增">
	</form>
</blockquote>

<%@ include file="bottom.jsp"%>	