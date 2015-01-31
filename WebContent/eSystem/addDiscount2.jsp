<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    User u = _ws2.getCurrentUser();
    if (u==null) //## need to figure out how to use auth here
        throw new Exception("User not login!");

    int cid = Integer.parseInt(request.getParameter("cid"));
    String[] values = request.getParameterValues("membr");
    int type = Integer.parseInt(request.getParameter("type"));
    int amount = 0-Integer.parseInt(request.getParameter("amount"));
    String note = request.getParameter("note");
    int copystatus = Discount.COPY_YES;
    try { copystatus = Integer.parseInt(request.getParameter("copystatus")); } catch (Exception e) {}

    EzCountingService ezsvc = EzCountingService.getInstance();
    BillChargeItem bcitem = BillChargeItemMgr.getInstance().find("chargeitem.id=" + cid);
    int[] membr_ids = new int[values.length];
    StringBuffer sb = new StringBuffer();
    for (int i=0; values!=null&&i<values.length; i++) {
        membr_ids[i] = Integer.parseInt(values[i]);
        if (sb.length()>0) sb.append(',');
        sb.append(membr_ids[i]);
    }

    boolean commit = false;
    int tran_id = dbo.Manager.startTransaction();
    try {     
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.setupDiscount(tran_id, bcitem, type, amount, note, copystatus, membr_ids, u, nextFreezeDay);

        ArrayList<ChargeItemMembr> charges = new ChargeItemMembrMgr(tran_id).retrieveList("chargeitem.id=" + cid
            + " and charge.membrId in (" + sb.toString() + ")", "");
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        jsf.DiscountType dtype = (jsf.DiscountType) ObjectService.find("jsf.DiscountType", "id=" + type);
        vsvc.updateChargeItemMembrs(charges, ud2.getId(), "調整(修)-" + dtype.getDiscountTypeName());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
       if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
       } else {
          %><script>alert("發生錯誤");history.go(-1);</script><%
       }
       e.printStackTrace();
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
<div class=es02>
        登入完成!   
        <br><br>
        <a href="addDiscount.jsp?cid=<%=cid%>">繼續整批編輯調整</a>
</div>
</blockquote>