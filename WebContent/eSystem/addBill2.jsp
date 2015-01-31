<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("n");
    if (name==null)
        throw new Exception("name is null");
    String prettyName = request.getParameter("t");
    int balanceWay = Integer.parseInt(request.getParameter("w"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    Bill b = ezsvc.createBill(name, prettyName, balanceWay, _ws2.getSessionBunitId());
%>

<br>

<blockquote>
    <div class=es02>
        新增成功！
        <br>
        <br>
        <a href="addBillRecord.jsp?billId=<%=b.getId()%>"> 繼續開單 </a>
    </div>
</blockquote>

