<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    int cid = -1, sid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    try { sid = Integer.parseInt(request.getParameter("sid")); } catch (Exception e) {}
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date feeTime = sdf.parse(request.getParameter("feeTime"));
    int unitPrice = Integer.parseInt(request.getParameter("unitPrice"));
    int num = Integer.parseInt(request.getParameter("num"));
    String note = request.getParameter("note");
    boolean outsourcing = (pd2.getWorkflow()==2);

    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);

System.out.println("## 1");

        FeeDetail fd = new FeeDetail();
        fd.setChargeItemId(cid);
        fd.setMembrId(sid);
        fd.setUnitPrice(unitPrice);
        fd.setNum(num);
        fd.setFeeTime(feeTime);
        fd.setUserId(ud2.getId());
        fd.setNote(note);
        fdmgr.create(fd);

        boolean do_remove = false;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ChargeItem ci = new ChargeItemMgr(tran_id).find("id=" + fd.getChargeItemId());
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, ci.getBillRecordId(), sid); 

        int mid = 0;
        try { mid=Integer.parseInt(request.getParameter("executeMembrId")); } catch (Exception e) {}
        if (outsourcing && mid>0) {
            fd.setPayrollMembrId(mid);            
            BillItem bi = new BillItemMgr(tran_id).find("id=" + ci.getBillItemId());
            if (bi.getMainBillItemId()==0) { // 附屬的就不理
                // update Salary counter part
                FeeDetailHandler fdh = new FeeDetailHandler();
                FeeDetail payrollfd = fdh.addPayrollEntry(tran_id, fd, ud2, nextFreezeDay);
                fd.setPayrollFdId(payrollfd.getId());
            }
            fdmgr.save(fd);
        }

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + 
            fd.getChargeItemId() + " and charge.membrId=" + fd.getMembrId());
        vsvc.updateChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"(修)");

        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), cs.getChargeName()+"(修)");

        Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("feedetail_list.jsp?cid=" + fd.getChargeItemId() + "&sid=" + fd.getMembrId());
    }
    catch (Exception e) {
        e.printStackTrace();
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else if (e.getMessage()!=null && !e.getMessage().equals("null")) {
            String msg = e.getMessage();
            if (outsourcing) {
                msg += " (包括派員薪資的部分)";
            }
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(msg)%>');history.go(-1);</script><%
        } else {
            e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }    
%>
