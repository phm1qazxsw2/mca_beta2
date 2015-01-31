<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu5.jsp"%>

<%@ include file="salary_detail_content.jsp"%>
<%
    _ws.setBookmark(ud2, title);
%>

<%@ include file="bottom.jsp"%>

