<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="/WEB-INF/jsp/security.jsp"%>
<%
    //##v2
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
    int brid = Integer.parseInt(request.getParameter("brid"));
    if (MembrBillRecordMgr.getInstance().numOfRows("billRecordId=" + brid)>0) { 
      %><script>alert("不能刪除有內容的記錄！");history.go(-1);</script><%
       return;
    }

    String p=request.getParameter("p");

    BillRecordMgr brmgr = BillRecordMgr.getInstance();
    BillRecord br = brmgr.find("id=" + brid);
    Object[] to_remove = { br };
    brmgr.remove( to_remove );
    
    if(p==null)
        response.sendRedirect("billoverview.jsp");
    else
        response.sendRedirect("salaryoverview.jsp");        
%>