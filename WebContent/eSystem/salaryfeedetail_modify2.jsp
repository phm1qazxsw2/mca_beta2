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
    EzCountingService ezsvc = EzCountingService.getInstance();
    int tran_id = 0;
    boolean commit = false;
    try { 
        tran_id = Manager.startTransaction();
        FeeDetailMgr fdmgr = new FeeDetailMgr(tran_id);
        FeeDetail fd = fdmgr.find("id=" + fid);
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ChargeItem ci = cimgr.find("id=" + fd.getChargeItemId());

        if (ci.getSmallItemId()==BillItem.SALARY_DEDUCT1 || ci.getSmallItemId()==BillItem.SALARY_DEDUCT2)
            unitPrice = 0 - unitPrice;

        fd.setUnitPrice(unitPrice);
        fd.setNum(quant);
        fd.setNote(note);
        fdmgr.save(fd);

        boolean do_remove = false;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ezsvc.updateFeeDetail(tran_id, fd, do_remove, ud2, nextFreezeDay);

        // ##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ChargeItemMembr cs = new ChargeItemMembrMgr(tran_id).find("charge.chargeItemId=" + 
            fd.getChargeItemId() + " and charge.membrId=" + fd.getMembrId());
        vsvc.updateSalaryChargeItemMembr(cs, ud2.getId(), cs.getChargeName()+"(修)");

        Manager.commit(tran_id);
        commit = true;
        response.sendRedirect("salaryfeedetail_list.jsp?cid=" + fd.getChargeItemId() + "&sid=" + fd.getMembrId());
    }
    catch (Exception e) {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception ee) {}
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("薪資金額小於0");history.go(-1);</script><%
        } else {
            e.printStackTrace();
            if (e.getMessage()!=null) {
          %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
            }
            else {
          %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
            }
        }
    }    
%>
