<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date d = sdf.parse(request.getParameter("d"));
    ArrayList<McaExRate> rates = McaExRateMgr.getInstance().retrieveList(
        "start<='" + sdf.format(d) + "'", "order by id desc limit 1");
    if (rates.size()>0) {
        out.println(rates.get(0).getRate());
    }
%>