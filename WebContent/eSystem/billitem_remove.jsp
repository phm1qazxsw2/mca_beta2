<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/jsp/security.jsp"%>
<%
    //##v2
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    int bid = Integer.parseInt(request.getParameter("bid"));
    BillItemMgr bimgr = BillItemMgr.getInstance();
    BillItem bi = bimgr.find("id=" + bid);
    bi.setStatus(BillItem.STATUS_NOTACTIVE);
    bimgr.save(bi);
    response.sendRedirect(request.getParameter("backurl"));
%>