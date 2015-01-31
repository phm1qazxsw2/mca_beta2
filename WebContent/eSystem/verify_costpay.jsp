<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    try { 
        int id = Integer.parseInt(request.getParameter("id"));
        int status = Integer.parseInt(request.getParameter("status"));
        String backurl = request.getParameter("backurl");
        Costpay2Mgr cpmgr = Costpay2Mgr.getInstance();
        Costpay2 cp = cpmgr.find("id=" + id);
        cp.setCostpayVerifyStatus(status);
        WebSecurity ws_ = WebSecurity.getInstance(pageContext);
        cp.setCostpayVerifyId(ws_.getCurrentUser().getId());
        cp.setCostpayVerifyDate(new Date());
        cpmgr.save(cp);
        response.sendRedirect(backurl);
    } 
    catch (Exception e) 
    {%><script>alert("參數不正確,找不到id");history.go(-1);</script><%}
%>