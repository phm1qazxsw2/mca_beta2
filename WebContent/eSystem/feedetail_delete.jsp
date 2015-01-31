<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int fid = Integer.parseInt(request.getParameter("fid")); 
    boolean outsourcing = (pd2.getWorkflow()==2);

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();

        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        FeeDetail fd = fdmgr.find("id=" + fid);

        /*
        // 2009/1/18 by peter, obsolete manhour
        // check if this remove affects manhour which affects other things like salary
        ManHourMgr mhmgr = new ManHourMgr(tran_id);
        ManHour mh = mhmgr.find("billfdId=" + fd.getId() + " or salaryfdId=" + fd.getId());
        if (mh!=null)
            throw new Exception("刪除此項目請至派遣記錄");
        */
        Object[] targets = { fd };
        fdmgr.remove(targets);

        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + 
            fd.getChargeItemId() + " and charge.membrId=" + fd.getMembrId());

        boolean do_remove = true;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2, nextFreezeDay); 
        // ## 改了Receivable有可能和Received不同調
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, cs.getBillRecordId(), fd.getMembrId()); 

        if (outsourcing) {
            if (fd.getPayrollFdId()>0) { // 附屬的就不理
                // update Salary counter part
                FeeDetailHandler fdh = new FeeDetailHandler();
                fdh.deletePayrollEntry(tran_id, fd, ud2, nextFreezeDay);
            }            
        }

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName() + "(刪明細)");
        
        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), cs.getChargeName()+"(修)");

        Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %>@@金額不可小於0<%
        } else if (e.getMessage()!=null&&e.getMessage().equals("z")) {
      %>@@刪除最後一筆項目請用"刪除單據"，刪除沒有成功<%
        } else if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@錯誤發生，設定沒有寫入<%
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }    
%>
