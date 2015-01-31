<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<% 
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();


    String name = request.getParameter("name");
    int status = Integer.parseInt(request.getParameter("status"));
    int id = Integer.parseInt(request.getParameter("id"));

    AliasMgr amgr = AliasMgr.getInstance();
    Alias a = amgr.find("id=" + id); 
    a.setName(name);
    a.setStatus(status);
    amgr.save(a);
    BillItem.invalidateAlias();
    response.sendRedirect("list_item_alias.jsp");
%>
