<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int fid = Integer.parseInt(request.getParameter("fid")); 

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date newTime = sdf.parse(request.getParameter("feeTime"));
    int unitPrice = Integer.parseInt(request.getParameter("unitPrice"));
    int quant = Integer.parseInt(request.getParameter("quant"));
    String note = request.getParameter("note");
    boolean outsourcing = (pd2.getWorkflow()==2);
    
    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        FeeDetail fd = fdmgr.find("id=" + fid);

        fd.setFeeTime(newTime);
        fd.setUnitPrice(unitPrice);
        fd.setNum(quant);
        fd.setNote(note);
        fdmgr.save(fd);
        
        boolean do_remove = false;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2, nextFreezeDay);

        if (outsourcing) {
            ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + fd.getChargeItemId());
            BillItem bi = new BillItemMgr(tran_id).find("id=" + ci.getBillItemId());
            if (fd.getPayrollFdId()>0) { // 附屬的就不理
                // update Salary counter part
                FeeDetailHandler fdh = new FeeDetailHandler();
                fdh.updatePayrollEntry(tran_id, fd, ud2, nextFreezeDay);
            }
            fdmgr.save(fd);
        }

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + 
            fd.getChargeItemId() + " and charge.membrId=" + fd.getMembrId());
        vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"(修)");

        Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("feedetail_list.jsp?cid=" + fd.getChargeItemId() + "&sid=" + fd.getMembrId());
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        } else {
          e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }    
%>
