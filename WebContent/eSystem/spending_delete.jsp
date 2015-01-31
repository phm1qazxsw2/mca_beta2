<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {
        tran_id = dbo.Manager.startTransaction();
        int id = Integer.parseInt(request.getParameter("id"));
        VitemMgr vimgr = new VitemMgr(tran_id);
        Vitem vi = vimgr.find("id=" + id);
        if (vi.getVerifystatus()!=Vitem.VERIFY_NO)
            throw new Exception("已覆核不可刪除");
        if (vi.getPaidstatus()!=Vitem.STATUS_NOT_PAID)
            throw new Exception("已付款不可刪除");
        vi.setTotal(0);
        vimgr.save(vi);

        if (vi.getOrgtype()==Vitem.ORG_TYPE_INVENTORY) {
            InventoryMgr invmgr = new InventoryMgr(tran_id);
            Inventory inv = invmgr.find("id=" + vi.getOrgId());
            Object[] objs = { inv };
            invmgr.remove(objs);
        }

        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());
        vsvc.genVoucherForVitem(vi, ud2.getId(), "(刪)");

        Object[] objs = { vi };
        vimgr.remove(objs);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %><script>alert(e.getMessage());history.go(-1);</script><%
        } else {
            e.printStackTrace();
      %><script>alert("錯誤發生，刪除沒有寫入");history.go(-1);</script><%
        }
        return;
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
    response.sendRedirect(request.getParameter("backurl"));
%>
