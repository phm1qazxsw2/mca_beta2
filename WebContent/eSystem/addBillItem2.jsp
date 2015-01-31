<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        int billId = Integer.parseInt(request.getParameter("billId"));
        String name = request.getParameter("name");
        if (name==null)
            throw new Exception("name is null");
        int smallitem = Integer.parseInt(request.getParameter("smallitem"));
        int defaultAmount = Integer.parseInt(request.getParameter("defaultAmount"));
        String desc = request.getParameter("description");
        EzCountingService ezsvc = EzCountingService.getInstance();	
        Bill b = new BillMgr(tran_id).find("id="+billId);
        if (new BillItemMgr(tran_id).numOfRows("billId=" + b.getId() + " and name='" + name + "' and status=1")>0)
            throw new Exception("["+name+"] already exists!");
        BillItem bitem = ezsvc.createBillItem(tran_id, b, name, smallitem, desc, defaultAmount);

        int copyStatus = Integer.parseInt(request.getParameter("copyStatus"));
        bitem.setCopyStatus(copyStatus);
        int alias = 0;
        try { alias = Integer.parseInt(request.getParameter("alias")); } catch (Exception e) {}
        bitem.setAliasId(alias);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        String acctcode = request.getParameter("acctcode"); 
        Acode a = McaService.getMcaAcode(tran_id, _ws2.getSessionBunitId(), acctcode);
        if (a==null)
            throw new Exception("會計科目["+acctcode+"]不存在");
        // 要 replace 貸方,
        vsvc.setBillItemTemplate(bitem, a, ud2.getId(), VchrItem.FLAG_CREDIT, VchrHolder.BILLITEM_DEFAULT);         

        try {
            int pitemId = Integer.parseInt(request.getParameter("pitemId"));
            PItem pi = new PItemMgr(tran_id).find("id=" + pitemId);
            if (pi!=null) {
                bitem.setPitemId(pi.getId());
            }
        } catch (Exception e) {}

        BillItemMgr bimgr = new BillItemMgr(tran_id);
        bimgr.save(bitem);

        dbo.Manager.commit(tran_id);
        commit = true;

        String backurl = request.getParameter("backurl");
        if (backurl!=null && !backurl.equals("null")) {
            response.sendRedirect(backurl);
            return;
        }    
    }
    catch (Exception e) {
        if (e.getMessage()!=null) {
          e.printStackTrace();
      %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
        } else {
          e.printStackTrace();
      %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
        }
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }
%>
<body>
<blockquote>
產生成功！
</blockquote>
</body>
