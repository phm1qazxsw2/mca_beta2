<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    CostpayMgr cmm=CostpayMgr.getInstance();

    int cpId=Integer.parseInt(request.getParameter("cpId"));
    Costpay co=(Costpay)cmm.find(cpId);
    String ps=request.getParameter("ps");
    ps=ps.replace("\n","<br>");
    co.setCostpayLogPs(ps);
    cmm.save(co);
%>
<B>&nbsp;&nbsp;編輯註記</B>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

    <br>
        <br>
        <blockquote>
        <div class=es02>
        修改完成,請關閉此視窗.
        </div>
        </blockquote>