<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    int brid = Integer.parseInt(request.getParameter("brid"));
    int mid = Integer.parseInt(request.getParameter("mid"));
    String backurl = request.getParameter("backurl");
    String[] bitemIds = request.getParameterValues("bitemId");
    
    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        BillRecord br = new BillRecordMgr(tran_id).find("id=" + brid);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        for (int i=0; bitemIds!=null && i<bitemIds.length; i++) {
            ChargeItem ci = null;
            if (cimgr.numOfRows("billItemId=" + bitemIds[i] + " and billRecordId=" + brid)==0)
                ci = ezsvc.makeChargeItem(tran_id, brid, Integer.parseInt(bitemIds[i]));
            else
                ci = cimgr.find("billItemId=" + bitemIds[i] + " and billRecordId=" + brid);
            Charge c = ezsvc.addChargeMembr(tran_id, ci, mid, br, ud2.getId(), nextFreezeDay);
            int amt = Integer.parseInt(request.getParameter("amount_" + bitemIds[i]));

            if (ci.getSmallItemId()==BillItem.SALARY_DEDUCT1 || ci.getSmallItemId()==BillItem.SALARY_DEDUCT2)
                amt = 0 - amt; // it's negative

            if (amt!=ci.getChargeAmount() && amt!=0) {
                int diff = amt - ci.getChargeAmount();
                c.setAmount(amt);
                ChargeMgr cmgr = new ChargeMgr(tran_id);
                cmgr.save(c);
                ezsvc.updateCharge(tran_id, ci.getId(), mid, diff, nextFreezeDay);
            }
        }

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        MembrInfoBillRecord salary = new MembrInfoBillRecordMgr(tran_id).find("membrId=" + mid + " and billRecordId=" + brid);
        vsvc.genVoucherForSalary(salary, ud2.getId(), null);

        Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("salary_detail.jsp?rid=" + brid + "&sid=" + mid + "&backurl=" + java.net.URLEncoder.encode(backurl));
    }
    catch (Exception e) {
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
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }    
%>
