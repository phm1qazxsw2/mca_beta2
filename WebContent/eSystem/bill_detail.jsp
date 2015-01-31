<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=1;
    int leftMenu=1;
%>

<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%@ include file="bill_detail_content.jsp"%>

<%
    _ws.setBookmark(ud2, title);
%>
<%@ include file="bottom.jsp"%>