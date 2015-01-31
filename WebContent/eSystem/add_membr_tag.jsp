<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    //##v2
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();

    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=602");
    }

    String name = request.getParameter("n");
    Tag tag = new Tag();
    tag.setName(name);
    TagMgr.getInstance().create(tag);
    response.sendRedirect("studentoverview.jsp");
%>
