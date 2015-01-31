<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*,mca.*,java.lang.reflect.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    //##v2

    boolean commit = false;
    int tran_id = 0;
    try { 
        tran_id = Manager.startTransaction();

        String chargeKey = request.getParameter("key");
        int c = chargeKey.indexOf("_");
        int membrId = Integer.parseInt(chargeKey.substring(0, c));
        int chargeItemId = Integer.parseInt(chargeKey.substring(c+1));
        int amount = Integer.parseInt(request.getParameter("amt"));
        
        EzCountingService ezsvc = EzCountingService.getInstance();
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws2.getBunitSpace("bunitId"));
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ChargeItemMembr ci = new ChargeItemMembrMgr(tran_id).find("charge.membrId=" + membrId + 
            " and charge.chargeItemId=" + chargeItemId);
        ezsvc.setChargeItemMembrAmount(tran_id, ci, amount, 0, nextFreezeDay); 
        vsvc.updateChargeItemMembr(ci, 0, "");
            
        commit = true;
        Manager.commit(tran_id);
    }
    catch (NumberFormatException e) {
      %>@@number format error, nothing saved<%
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
      %>@@<%=e.getMessage()%><%
        } else {
            e.printStackTrace();
      %>@@unknow error, nothing saved!<%
        }
    }    
    finally {
        if (!commit)
            try { Manager.rollback(tran_id); } catch (Exception e2) {}  
    }
%>