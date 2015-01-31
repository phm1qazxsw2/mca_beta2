<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?cpde=102");
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    int bid = Integer.parseInt(request.getParameter("bid"));
    int brid = Integer.parseInt(request.getParameter("brid"));
    int sid = Integer.parseInt(request.getParameter("sid"));
    Date feeTime = sdf.parse(request.getParameter("feeTime"));
    int unit = Integer.parseInt(request.getParameter("unit"));
    int quant = Integer.parseInt(request.getParameter("quant"));

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

        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        FeeDetail fd = new FeeDetail();
        fd.setChargeItemId(ci.getId());
        fd.setMembrId(sid);
        fd.setUnitPrice(unit);
        fd.setNum(quant);
        fd.setFeeTime(feeTime);
        fd.setUserId(user.getId());
        fdmgr.create(fd);

        boolean do_remove = false;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2, nextFreezeDay);
        // ## 改了Receivable有可能和Received不同調
        ArrayList<BillPay> affected_pays = ezsvc.fixupReceivableReceived(tran_id, ci.getBillRecordId(), sid); 

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        Charge c = new ChargeMgr(tran_id).find("chargeItemId=" + fd.getChargeItemId() + " and membrId=" + fd.getMembrId());
        vsvc.updateCharge(c, ud2.getId(), bi.getName()+"(加)");

        if (affected_pays.size()>0)
            vsvc.genVoucherForBillPays(affected_pays, ud2.getId(), bi.getName()+"(加)");

        boolean outsourcing = (pd2.getWorkflow()==2);
        int mid = 0;
        try { mid=Integer.parseInt(request.getParameter("payrollMembrId")); } catch (Exception e) {}
        if (outsourcing && mid>0) {
            fd.setPayrollMembrId(mid);
            ChargeItem ci2 = new ChargeItemMgr(tran_id).find("id=" + fd.getChargeItemId());
            BillItem bi2 = new BillItemMgr(tran_id).find("id=" + ci2.getBillItemId());
            if (bi2.getMainBillItemId()==0) { // 附屬的就不理
                // update Salary counter part
                FeeDetailHandler fdh = new FeeDetailHandler();
                FeeDetail payrollfd = fdh.addPayrollEntry(tran_id, fd, ud2, nextFreezeDay);
                fd.setPayrollFdId(payrollfd.getId());
            }
            fdmgr.save(fd);
        }

        Manager.commit(tran_id);
        commit = true;
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
        return;
    }    
%>
<blockquote>
設定成功
<br>
<br>
<a href="billcharge_add_adv.jsp?brid=<%=brid%>&sid=<%=sid%>">繼續加下一筆</a>
</blockquote>
