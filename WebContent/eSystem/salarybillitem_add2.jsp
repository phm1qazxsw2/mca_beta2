<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
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
        int salarytype = Integer.parseInt(request.getParameter("salarytype"));
        EzCountingService ezsvc = EzCountingService.getInstance();	
        Bill b = new BillMgr(tran_id).find("id="+billId);
        BillItem bitem = ezsvc.createBillItem(tran_id, b, name, salarytype, null, 0);

        int copyStatus = Integer.parseInt(request.getParameter("copyStatus"));
        bitem.setCopyStatus(copyStatus);
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        bimgr.save(bitem);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        String acctcode = request.getParameter("acctcode"); 
        Acode a = vsvc.getAcodeFromAcctcode(acctcode);
        if (a==null)
            throw new Exception("會計科目["+acctcode+"]不存在");
        // 要 replace 貸方
        vsvc.setBillItemTemplate(bitem, a, ud2.getId(), VchrItem.FLAG_DEBIT, VchrHolder.SALARY_BILLITEM_DEFAULT);         

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
        if (!commit) {
            dbo.Manager.rollback(tran_id);
        }
    }
%>
<body>
<blockquote>
產生成功！
</blockquote>
</body>
