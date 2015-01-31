<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}

    String reason = request.getParameter("reason");
    User user = WebSecurity.getInstance(pageContext).getCurrentUser();
    EzCountingService ezsvc = EzCountingService.getInstance();

    int tran_id = 0;
    boolean commit = false;
    try { 
        int amount = Integer.parseInt(request.getParameter("amount"));
        tran_id = Manager.startTransaction();
        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).
            find("chargeItemId=" + cid + " and membr.id=" + sid);
        if (cs.getSmallItemId()==BillItem.SALARY_DEDUCT1 || cs.getSmallItemId()==BillItem.SALARY_DEDUCT2)
            amount = 0 - amount;

        ChargeMgr cmgr = new ChargeMgr(tran_id);
        Charge c = cmgr.find("chargeItemId=" + cid + " and membrId=" + sid);

        int oldamount = cs.getMyAmount();
        int diff = amount - oldamount;
        c.setAmount((amount==cs.getChargeAmount())?0:amount);
        c.setNote((reason!=null && reason.length()>0)?reason:"");
        c.setUserId(user.getId());
        cmgr.save(c);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateCharge(tran_id, c.getChargeItemId(), c.getMembrId(), diff, nextFreezeDay);
        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateSalaryCharge(c, ud2.getId(), cs.getChargeName()+"(修)");

        Manager.commit(tran_id);
        commit = true;
        out.println("<blockquote>設定成功</blockquote>");
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("薪資金額小於0");history.go(-1);</script><%
        } else {
            if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
        }
    }    
%>

