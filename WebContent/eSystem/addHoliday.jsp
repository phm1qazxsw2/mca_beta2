<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
%>



<form name=f1 action="addHoliday2.jsp" method="post" onsubmit="return doSubmit();">
<input type=hidden name="id" value="<%=id%>">
<%@ include file="holiday_add_inner.jsp"%>
</form>