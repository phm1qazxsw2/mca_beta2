<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=6&info=1");
    }
    int invId = Integer.parseInt(request.getParameter("id"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date orderDate = sdf.parse(request.getParameter("orderDate"));
    int pitemId = Integer.parseInt(request.getParameter("pitemId"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    int total = Integer.parseInt(request.getParameter("total"));
    int traderId = -1;
    try { traderId = Integer.parseInt(request.getParameter("costTradeId")); } catch (Exception e) {}

    boolean commit = false;
    int tran_id = 0;
    Inventory inv = null;
    try {
        tran_id = dbo.Manager.startTransaction();
        InventoryMgr invmgr = new InventoryMgr(tran_id);
        VitemMgr vimgr = new VitemMgr(tran_id);

        inv = invmgr.find("id=" + invId);
        inv.setOrderDate(orderDate);
        int oldPid = inv.getPitemId();
        inv.setPitemId(pitemId);
        int oldQuantity = inv.getQuantity();
        inv.setQuantity(quantity);
        int oldTotal = inv.getTotalPrice();
        inv.setTotalPrice(total);
        int oldTraderId = inv.getTraderId();
        inv.setTraderId(traderId);
        invmgr.save(inv);        

        Vitem vi = vimgr.find("orgtype=" + Vitem.ORG_TYPE_INVENTORY + " and orgId=" + inv.getId());

        if (vi.getVerifystatus()==Vitem.VERIFY_YES) {
            throw new Exception("此筆進貨的雜費支出已確認，不可修改");
        }
        
        if (total<vi.getRealized()) {
            throw new Exception("修改金額["+total+"]不可小於已付款的金額["+vi.getRealized()+"]");
        }
        else if (total==vi.getRealized()) {
            vi.setPaidstatus(Vitem.STATUS_FULLY_PAID);
        }

        if (oldPid!=pitemId || oldQuantity!=quantity || oldTraderId!=traderId) {
            PItem pi = new PItemMgr(tran_id).find("id=" + pitemId);
            String title = "進貨 " + pi.getName();
            if (title.length()>30)
                title = title.substring(0,29);
            title += "*" + quantity;
            vi.setTitle(title);
            vi.setCostTradeId(traderId);
        }

        vi.setRecordTime(orderDate);
        vi.setTotal(total);
        vimgr.save(vi);

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1)</script><%
        }
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }

%>
<br>
<br>
<blockquote>
修改成功！
<br>
<br>
<a href="inventory_history.jsp?id=<%=inv.getPitemId()%>">回進貨歷史</a>
