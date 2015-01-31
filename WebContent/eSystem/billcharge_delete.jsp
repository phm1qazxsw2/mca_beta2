<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    //##v2
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}

    EzCountingService ezsvc = EzCountingService.getInstance();
    ChargeItemMembrMgr csmgr = ChargeItemMembrMgr.getInstance();
    ChargeItemMembr cs = csmgr.find("chargeItemId=" + cid + " and membr.id=" + sid);

    boolean commit = false;
    int tran_id = 0;
    try { 
        tran_id = Manager.startTransaction();
        User user = _ws2.getCurrentUser();
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.deleteCharge(tran_id, cs, user, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, cs.getBillRecordId(), sid); 

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        if (cs.getBillType()==Bill.TYPE_BILLING) {
            vsvc.updateChargeItemMembr(cs, user.getId(), cs.getChargeName()+"(刪)");
            if (affected_pays.size()>0)
                vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), cs.getChargeName()+"(刪)");
        }
        else if (cs.getBillType()==Bill.TYPE_SALARY) {
            vsvc.updateSalaryChargeItemMembr(cs, user.getId(), cs.getChargeName()+"(刪)");
            if (affected_pays.size()>0)
                vsvc.genVoucherForSalaryPays(affected_pays, ud2.getId(), cs.getChargeName()+"(刪)");
        }

        commit = true;
        Manager.commit(tran_id);
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("z")) {
      %>@@刪除項目為最後一筆，欲刪除整張單據請用"刪除單據"，刪除沒有成功<%
        } else if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@錯誤發生，刪除沒有成功<%
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>