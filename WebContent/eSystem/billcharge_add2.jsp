<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int bid = Integer.parseInt(request.getParameter("bid"));
    int brid = Integer.parseInt(request.getParameter("brid"));
    int sid = Integer.parseInt(request.getParameter("sid"));
    int amount = Integer.parseInt(request.getParameter("amount"));
    int num = 0;
    try { num = Integer.parseInt(request.getParameter("num")); } catch (Exception e) {}
    User user = WebSecurity.getInstance(pageContext).getCurrentUser();
    
    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        BillItem bi = BillItemMgr.getInstance().find("id=" + bid);
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ChargeItem ci = cimgr.find("billItemId=" + bid + " and billRecordId=" + brid);
        if (ci==null) {
            ci = new ChargeItem();
            ci.setBillItemId(bid);
            ci.setBillRecordId(brid);
            ci.setSmallItemId(bi.getSmallItemId());
            ci.setChargeAmount(amount);
            cimgr.create(ci);
        }

        ChargeMgr cmgr = new ChargeMgr(tran_id);
        Charge c = new Charge();
        c.setMembrId(sid);
        c.setChargeItemId(ci.getId());
        c.setUserId(user.getId());
        if (amount==0) {
            c.setAmount(ChargeItemMembr.ZERO);
        }
        else if (amount!=ci.getChargeAmount())
            c.setAmount(amount);
        if (num>0)
            c.setPitemNum(num);
        cmgr.create(c);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateCharge(tran_id, ci.getId(), sid, amount, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, ci.getBillRecordId(), sid); 
        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateCharge(c, ud2.getId(), bi.getName());

        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), bi.getName()+"(加)");

        Manager.commit(tran_id);
        commit = true;
        out.println("<blockquote>設定成功</blockquote>");
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
        }
    }    
%>
