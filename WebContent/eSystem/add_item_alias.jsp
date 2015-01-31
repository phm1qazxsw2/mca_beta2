<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<% 
    if(!checkAuth(ud2,authHa,105))
    {
        response.sendRedirect("authIndex.jsp?code=105");
    }
    String name = request.getParameter("name");
    Alias a = new Alias();
    a.setName(name);
    a.setStatus(Alias.STATUS_ACTIVE);
    a.setBunitId(_ws2.getSessionBunitId());
    AliasMgr.getInstance().create(a);
    BillItem.invalidateAlias();
    response.sendRedirect("list_item_alias.jsp");
%>
