<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,402))
    {
        response.sendRedirect("authIndex.jsp?code=402");
    }

    int id = Integer.parseInt(request.getParameter("id"));

    int tran_id = 0;
    int tran_id2 = 0;
    boolean commit = false;
    try { 
        tran_id = com.axiom.mgr.Manager.startTransaction();
        tran_id2 = dbo.Manager.startTransaction();

        CostpayMgr cpmgr = new CostpayMgr(tran_id);
        InsidetradeMgr inmgr = new InsidetradeMgr(tran_id);
        Insidetrade in = (Insidetrade) inmgr.find(id);

        Object[] objs = cpmgr.retrieve("costpaySideID=" + id, "");
        if (objs.length!=2)
            throw new Exception("刪除的記錄不是兩個");

        for (int i=0; i<objs.length; i++)
            cpmgr.remove(((Costpay)objs[i]).getId());
        inmgr.remove(in.getId());

        VoucherService vsvc = new VoucherService(tran_id2, _ws2.getSessionBunitId());
        vsvc.genVoucherForDeleteInsideTrade(in, ud2.getId());

        com.axiom.mgr.Manager.commit(tran_id);
        dbo.Manager.commit(tran_id2);
        commit = true;

        response.sendRedirect(request.getParameter("backurl"));
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
         %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>'); history.go(-1);</script><%
        } else { 
         %><script>alert("錯誤發生，付款沒有寫入");history.go(-1);</script><%
            e.printStackTrace();
            return;
        }
    }
    finally {
        if (!commit) {
            com.axiom.mgr.Manager.rollback(tran_id);
            dbo.Manager.rollback(tran_id2);
        }
    }
%>