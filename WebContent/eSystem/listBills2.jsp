<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
    String backurl = request.getParameter("backurl");
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("n");
    String prettyName = request.getParameter("pn");
    BillMgr bmgr = BillMgr.getInstance();
    Bill b = bmgr.find("id=" + id);
    if (name!=null)
        b.setName(name);
    if (prettyName!=null)
        b.setPrettyName(prettyName);
    bmgr.save(b);
    response.sendRedirect(backurl);
%>
