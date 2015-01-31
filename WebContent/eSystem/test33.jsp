<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    BillSource bs = BillSourceMgr.getInstance().find("id=6332");
	out.println("line=" + bs.getLine());
%>