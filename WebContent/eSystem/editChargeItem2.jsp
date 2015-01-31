<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    String amountStr = request.getParameter("amount");
    int smallItemId = Integer.parseInt(request.getParameter("smallitem"));

System.out.println("# amountStr=" + amountStr + " #smallItemId=" + smallItemId);

    int amount = Integer.parseInt(amountStr);
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
        ChargeItemMgr cmgr = new ChargeItemMgr(tran_id);
        citem = cmgr.find("id=" + citemId);    

        if (citem==null)
            citem = ezsvc.makeChargeItem(tran_id, recordId, bitemId);

        int oldamount = citem.getChargeAmount();
        int diffAmount = amount - oldamount;
        Date nextFreezeDay = ezsvc.getFreezeNextDay(_ws.getBunitSpace("bunitId"));
        ezsvc.updateChargeAmountForAllMembrs(tran_id, citem, diffAmount, 
            nextFreezeDay);//修干 studentbillrecord 的 receivable
        citem.setSmallItemId(smallItemId);

        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bi = bimgr.find("id=" + bitemId);
        bi.setDefaultAmount(amount);
        bi.setSmallItemId(smallItemId);
        bimgr.save(bi);

        cmgr.save(citem);
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

    response.sendRedirect("editChargeItem.jsp?rid="+recordId+"&bid="+bitemId+"&cid="+citem.getId());
%>
