<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,301))
    {
        response.sendRedirect("authIndex.jsp?code=301");
    }
%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2

    int salarytype = Integer.parseInt(request.getParameter("salarytype"));
    String param = request.getParameter("param");
    String[] tokens = param.split("#");
    int recordId = Integer.parseInt(tokens[0]);
    int bitemId = Integer.parseInt(tokens[1]);
    int citemId = Integer.parseInt(tokens[2]);
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillRecord billrecord = BillRecordMgr.getInstance().find("id="+recordId);

    boolean commit = false;
    int tran_id = 0;
    ChargeItem citem = null;
    try {
        tran_id = dbo.Manager.startTransaction();
        ChargeItemMgr cimgr = new ChargeItemMgr(tran_id);
        ChargeMgr cmgr = new ChargeMgr(tran_id);
        citem = cimgr.find("id=" + citemId);    

        if (citem==null)
            citem = ezsvc.makeChargeItem(tran_id, recordId, bitemId);

        int org_salarytype = citem.getSmallItemId();
        citem.setSmallItemId(salarytype);
        cimgr.save(citem);

        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws.getBunitSpace("bunitId"));
        // if + turns - or - turns +, need to update each charge
        Iterator<Charge> citer = cmgr.retrieveList("chargeItemId=" + citem.getId(), "").iterator();
        while (citer.hasNext()) {
            Charge c = citer.next(); 
            int num = Math.abs(c.getAmount());
            int diff = BillItem.calc_salary_diff(num, num, org_salarytype, salarytype);
            if (diff!=0) {
                c.setAmount(c.getAmount()+diff);
                cmgr.save(c);
                ezsvc.updateCharge(tran_id, citem.getId(), c.getMembrId(), diff, nextFreezeDay);
            }
        } 
        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        if (e.getMessage()!=null&&e.getMessage().equals("x")) {
      %><script>alert("收費金額小於0");history.go(-1);</script><%
        } else {
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }    
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }

    response.sendRedirect("salarychargeitem_edit.jsp?rid="+recordId+"&bid="+bitemId+"&cid="+citem.getId());
%>
