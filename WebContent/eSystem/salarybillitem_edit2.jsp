<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();

        //##v2
        int bid = Integer.parseInt(request.getParameter("bid"));
        String name = request.getParameter("name");
        if (name==null)
            throw new Exception("name is null");
        int copyStatus = Integer.parseInt(request.getParameter("copyStatus"));
        String desc = request.getParameter("description");
        BillItemMgr bimgr = new BillItemMgr(tran_id);
        BillItem bitem = bimgr.find("id=" + bid);
        bitem.setName(name);
        bitem.setCopyStatus(copyStatus);
        bimgr.save(bitem);

        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        String acctcode = request.getParameter("acctcode"); 
        Acode a = vsvc.getAcodeFromAcctcode(acctcode);
        if (a==null)
            throw new Exception("會計科目["+acctcode+"]不存在");
        // 要 replace 借方
        vsvc.setBillItemTemplate(bitem, a, ud2.getId(),  VchrItem.FLAG_DEBIT, VchrHolder.SALARY_BILLITEM_DEFAULT);         

        dbo.Manager.commit(tran_id);
        commit = true;
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
設定成功
</blockquote>
</body>
