<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    BillItemMgr bimgr = BillItemMgr.getInstance();
    BillItem bi = bimgr.find("id=" + request.getParameter("bid"));
    bi.setPitemId(0);
    bimgr.save(bi);
%>
<br>
<blockquote>
    解除成功!
</blockquote>
