<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int fid = Integer.parseInt(request.getParameter("fid")); 

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();

        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        FeeDetail fd = fdmgr.find("id=" + fid);

        Object[] targets = { fd };
        fdmgr.remove(targets);

        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + 
            fd.getChargeItemId() + " and charge.membrId=" + fd.getMembrId());

        boolean do_remove = true;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2, nextFreezeDay);

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateSalaryChargeItemMembr(cs, ud2.getId(), cs.getChargeName() + "(刪明細)");
        
        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("z")) {
      %>@@至少要有一項收費項目<%
        } else if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %>@@薪資金額小於0<%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
          %>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
            }
            else {
          %>@@錯誤發生，設定沒有寫入<%
            }
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }    
%>
