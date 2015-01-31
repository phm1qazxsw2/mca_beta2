<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int billId = Integer.parseInt(request.getParameter("billId"));
    String name = request.getParameter("record");
    String month = request.getParameter("month");
    Date mm = new java.text.SimpleDateFormat("yyyy-MM").parse(month);
    if (name==null)
        throw new Exception("name is null");
    int copyfrom = -1;
    try { copyfrom = Integer.parseInt(request.getParameter("copyfrom")); } catch (Exception e) {}
    EzCountingService ezsvc = EzCountingService.getInstance();	

    boolean commit = false;
    int tran_id = 0;
    BillRecord br = null;
    try { 
        tran_id = Manager.startTransaction();  
    
        Bill b = new BillMgr(tran_id).find("id="+billId);
        BillRecord copybr = new BillRecordMgr(tran_id).find("id="+copyfrom);
        br = ezsvc.createBillRecord(tran_id, b, name, mm, mm, copybr, ud2.getId());
        //##
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        vsvc.updateBillRecord(br, ud2.getId());

        commit = true;
        Manager.commit(tran_id);
    }
    finally {
        if (!commit) {
            try { Manager.rollback(tran_id); } catch (Exception e) {}
        }
    }

%>
<body>
<blockquote>
<div class=es02>
    產生成功！
    <br><br>

    <a target=_top href="salaryrecord_edit.jsp?recordId=<%=br.getId()%>">編輯<%=br.getName()%>薪資</a> |
    <a href="list_salary_bills.jsp">回薪資列表</a>
</div>

</blockquote>
</body>
