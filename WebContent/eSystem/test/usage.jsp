<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date from = sdf.parse(request.getParameter("from"));
    BillPayMgr bpmgr = BillPayMgr.getInstance();
    int n = bpmgr.numOfRows("via in (1,2) and createTime>'" + sdf.format(from) + "'");
%>
<%=n%> <%=ps.getPaySystemCompanyStoreNickName()%> <%=ps.getPaySystemFirst5()%> <%=ps.getPaySystemCompanyName()%>