<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    EzCountingService ezsvc = EzCountingService.getInstance();	
    int tagId = Integer.parseInt(request.getParameter("tag"));
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int recordId = Integer.parseInt(tokens[0]);
    int bitemId = Integer.parseInt(tokens[1]);
    int citemId = Integer.parseInt(tokens[2]);
    BillRecord billrecord = BillRecordMgr.getInstance().find("id="+recordId);

    String backurl = request.getParameter("backurl");
    String[] values = request.getParameterValues("target");
    if (values==null) {
        response.sendRedirect("chooser_detail.jsp?tag=" + tagId + "&param=" + java.net.URLEncoder.encode(param));
        return;
    }

    ChargeItem citem = null;
    int tran_id = 0;
    boolean commit = false;
    try {
        tran_id = dbo.Manager.startTransaction();
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        TagMembrStudentMgr tsmgr = new TagMembrStudentMgr(tran_id);
        int added = 0;
        int locked = 0;

        if (citemId<=0) {
            citem = new BillChargeItemMgr(tran_id).find("billrecord.id=" + recordId + " and billitem.id=" + bitemId);
            if (citem.getId()==0) // 一定會 return a citem, 但 id=0 就代表還沒有 chargeItem
                citem = ezsvc.makeChargeItem(tran_id, recordId, bitemId);
        }
        else {
            citem = new ChargeItemMgr(tran_id).find("id=" + citemId);
        }
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bi = bimgr.find("id=" + citem.getBillItemId());
        boolean connecting_product = (bi.getPitemId()>0);
       
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        ArrayList<Charge> modified_charges = new ArrayList<Charge>();
        for (int i=0; i<values.length; i++) {
            int membrId = Integer.parseInt(values[i]);
            if (tagId>0 && tsmgr.numOfRows("tagId=" + tagId + " and membrId=" + membrId)==0)
                continue;
            try {
                Charge c = ezsvc.addChargeMembr(tran_id, citem, membrId, billrecord, ud2.getId(), nextFreezeDay);
                modified_charges.add(c);
                added ++;
                if (connecting_product) {
                    c.setPitemNum(1);
                    cmgr.save(c);
                }
            }
            catch (AlreadyExists a) {}
            catch (Locked l) {
                locked ++;
            }
            catch (Exception e) 
            {
                if (e.getMessage()!=null&&e.getMessage().equals("x")) {
                   %><script>alert("收費金額小於0");history.go(-1)</script><%
                } else { 
                    throw e;
                }
            }
        }

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateCharges(modified_charges, ud2.getId(), bi.getName());
        
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        }
        else {
            e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
        return;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
    if (backurl==null) {
        backurl = "chooser_detail.jsp?tag=" + tagId + "&param=" + java.net.URLEncoder.encode(recordId+"#"+bitemId+"#"+citem.getId());
    }
    response.sendRedirect(backurl);
%>
