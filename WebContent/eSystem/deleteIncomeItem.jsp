<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%


int sid=Integer.parseInt(request.getParameter("sid"));



IncomeSmallItemMgr cdm=IncomeSmallItemMgr.getInstance();
//IncomeSmallItem is=(IncomeSmallItem)cdm.find(sid);

cdm.remove(sid);

out.println("刪除成功");

%>