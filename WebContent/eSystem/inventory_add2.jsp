<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu9.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=6&info=1");
    }
    String backurl = request.getParameter("backurl");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date orderDate = sdf.parse(request.getParameter("orderDate"));
    int pitemId = Integer.parseInt(request.getParameter("pitemId"));
    int quantity = Integer.parseInt(request.getParameter("quantity"));
    int total = Integer.parseInt(request.getParameter("total"));
    int traderId = -1;
    try { traderId = Integer.parseInt(request.getParameter("costTradeId")); } catch (Exception e) {}

    boolean commit = false;
    int tran_id = 0;
    Vitem vi = null;
    try {
        tran_id = dbo.Manager.startTransaction();
        Inventory inv = new Inventory(); 
        inv.setOrderDate(orderDate);
        inv.setPitemId(pitemId);
        inv.setQuantity(quantity);
        inv.setTotalPrice(total);
        inv.setTraderId(traderId);
        inv.setBunitId(_ws.getSessionBunitId());
        new InventoryMgr(tran_id).create(inv);

        PItem pi = new PItemMgr(tran_id).find("id=" + pitemId);

        vi = new Vitem();
        vi.setRecordTime(orderDate);
        String title = "進貨 " + pi.getName();
        if (title.length()>30)
            title = title.substring(0,29);
        title += "*" + quantity;
        vi.setTitle(title);
        vi.setTotal(total);

        vi.setCostTradeId(traderId);
        vi.setType(Vitem.TYPE_COST_OF_GOODS);
        vi.setUserId(ud2.getId());
        vi.setOrgtype(Vitem.ORG_TYPE_INVENTORY);
        vi.setOrgId(inv.getId());

        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());
        Acode a = vsvc.getCostOfGoodAcode(pitemId);
        vi.setAcctcode(a.getAcctcode());
        vi.setBunitId(_ws.getSessionBunitId());

        new VitemMgr(tran_id).create(vi);

        vsvc.genVoucherForVitem(vi, ud2.getId(), "");

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        }
        else {
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
        return;
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }

%>
<br>
<br>
<blockquote>
新增成功！
<br>
<br>
<a href="spending_voucher.jsp?id=I<%=vi.getId()%>&backurl=inventory_list.jsp">進行付款</a>
</blockquote>

<script src="js/cookie.js"></script>

<%@ include file="bottom.jsp"%>