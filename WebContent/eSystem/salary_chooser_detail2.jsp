<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    EzCountingService ezsvc = EzCountingService.getInstance();	
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int recordId = Integer.parseInt(tokens[0]);
    int bitemId = Integer.parseInt(tokens[1]);
    int citemId = Integer.parseInt(tokens[2]);
    BillRecord billrecord = BillRecordMgr.getInstance().find("id="+recordId);

    String[] values = request.getParameterValues("target");
    if (values==null) {
        response.sendRedirect("salary_chooser_detail.jsp?param=" + java.net.URLEncoder.encode(param));
        return;
    }

    boolean commit = false;
    int added = 0;
    int locked = 0;  
    int tran_id = 0;
    WebSecurity ws2 = WebSecurity.getInstance(pageContext);
    try {
        tran_id = dbo.Manager.startTransaction();
        ChargeItem citem = ChargeItemMgr.getInstance().find("id=" + citemId);
        ArrayList<Charge> modified_charges = new ArrayList<Charge>();

        if (citem==null) {
            citem = ezsvc.makeChargeItem(tran_id, recordId, bitemId);
            param = tokens[0] + "#" + tokens[1] + "#" + citem.getId();
        }

        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bi = bimgr.find("id=" + bitemId);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        for (int i=0; i<values.length; i++) {
            int membrId = Integer.parseInt(values[i]);
            try {
                Charge c = ezsvc.addChargeMembr(tran_id, citem, membrId, billrecord, ud2, nextFreezeDay);
                modified_charges.add(c);
                added ++;
            }
            catch (AlreadyExists a) {}
            catch (Locked l) {
                locked ++;
            }
        }

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateSalaryCharges(modified_charges, ud2.getId(), bi.getName());
        
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
    response.sendRedirect("salary_chooser_detail.jsp?param=" + java.net.URLEncoder.encode(param));
%>
