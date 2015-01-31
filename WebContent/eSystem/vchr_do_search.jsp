<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>

<%@ include file="vchr_search_handler.jsp"%>
<%    
    ArrayList<VchrItemSum> sums =VchrItemSumMgr.getInstance().retrieveListX(q, spec, 
        _ws2.getBunitSpace("vchr_holder.buId"));
%>

<link href="../ft02.css" rel=stylesheet type=text/css>
<%@ include file="vchr/get_topic_inner.jsp"%>