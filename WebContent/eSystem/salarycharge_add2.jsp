<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
    }
    int bid = Integer.parseInt(request.getParameter("bid"));
    int brid = Integer.parseInt(request.getParameter("brid"));
    int sid = Integer.parseInt(request.getParameter("sid"));
    int amount = Integer.parseInt(request.getParameter("amount"));
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
            cimgr.create(ci);
        }

        ChargeMgr cmgr = new ChargeMgr(tran_id);
        Charge c = new Charge();
        c.setMembrId(sid);
        c.setChargeItemId(ci.getId());
        c.setUserId(user.getId());
        if (ci.getSmallItemId()==BillItem.SALARY_DEDUCT1 || ci.getSmallItemId()==BillItem.SALARY_DEDUCT2)
            amount = 0 - amount;
        c.setAmount(amount);
        cmgr.create(c);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateCharge(tran_id, ci.getId(), sid, amount, nextFreezeDay);
        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateSalaryCharge(c, ud2.getId(), bi.getName());

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
            e.printStackTrace();
            return;
        }
    }    
%>
