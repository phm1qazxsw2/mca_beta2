<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=6&info=1");
    }

    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();

        PItemMgr pimgr = new PItemMgr(tran_id);
        PItem pi =  pimgr.find("id=" + request.getParameter("id"));

        String name = request.getParameter("name");
        pi.setName(name);    
        try { 
            pi.setSafetyLevel(Integer.parseInt(request.getParameter("safetyLevel"))); 
        } catch (Exception e) {}

        try { 
            int p = Integer.parseInt(request.getParameter("salePrice"));
            pi.setSalePrice(p);
            // 看看有沒有連結
            BillItemMgr bimgr = new BillItemMgr(tran_id);
            BillItem bi = bimgr.find("pitemId=" + pi.getId());
            if (bi!=null) {
                bi.setDefaultAmount(p);
                bimgr.save(bi);
            }
        } catch (Exception e) {}
        
        pimgr.save(pi);
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
修改成功！