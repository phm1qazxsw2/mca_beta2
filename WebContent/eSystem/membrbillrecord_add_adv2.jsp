<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    int brid = Integer.parseInt(request.getParameter("brid"));
    int mid = Integer.parseInt(request.getParameter("mid"));
    String backurl = request.getParameter("backurl");
    String[] bitemIds = request.getParameterValues("bitemId");
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        BillRecord br = new BillRecordMgr(tran_id).find("id=" + brid);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        for (int i=0; bitemIds!=null && i<bitemIds.length; i++) {
            ChargeItem ci = null;
            if (cimgr.numOfRows("billItemId=" + bitemIds[i] + " and billRecordId=" + brid)==0)
                ci = ezsvc.makeChargeItem(tran_id, brid, Integer.parseInt(bitemIds[i]));
            else
                ci = cimgr.find("billItemId=" + bitemIds[i] + " and billRecordId=" + brid);

            int unit = Integer.parseInt(request.getParameter("unit_" + bitemIds[i]));
            int quan = Integer.parseInt(request.getParameter("quant_" + bitemIds[i]));
            Date d = sdf.parse(request.getParameter("date_" + bitemIds[i]));

            FeeDetail fd = new FeeDetail();
            fd.setChargeItemId(ci.getId());
            fd.setMembrId(mid);
            fd.setUnitPrice(unit);
            fd.setNum(quan);
            fd.setFeeTime(d);
            fd.setUserId(ud2.getId());
            fdmgr.create(fd);

            Charge c = ezsvc.addChargeMembr(tran_id, ci, mid, br, ud2.getId(), nextFreezeDay);

            //#### caculate pitemNum ####
            if (bimgr.numOfRows("id=" + ci.getBillItemId() + " and pitemId>0")>0) { // 有連結 pitemId
                int tmp = 0;
                Iterator<FeeDetail> iter = fdmgr.retrieveList("chargeItemId=" + ci.getId() + " and membrId=" + mid, "").iterator();
                while (iter.hasNext()) {
                    tmp += iter.next().getNum();
                }
                c.setPitemNum(tmp);
                cmgr.save(c);
            }
            //###########################
            
            int amt = unit*quan;
            if (amt!=ci.getChargeAmount() && amt!=0) {
                int diff = amt - ci.getChargeAmount();
                c.setAmount(amt);
                cmgr.save(c);
                ezsvc.updateCharge(tran_id, ci.getId(), mid, diff, nextFreezeDay);
            }
        }
        
        // 2008/12/30 by peter, decide only track modification if bill already has voucher
        // voucher is created upon 發布
        /*
        VoucherService vsvc = new VoucherService(tran_id, _ws.getSessionBunitId());
        MembrInfoBillRecord bill = new MembrInfoBillRecordMgr(tran_id).find("membrId=" + mid + " and billRecordId=" + brid);
        vsvc.genVoucherForBill(bill, ud2.getId(), null);
        */
        Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("bill_detail.jsp?rid=" + brid + "&sid=" + mid + "&backurl=" + java.net.URLEncoder.encode(backurl));
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else {
            if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
    }    
%>
