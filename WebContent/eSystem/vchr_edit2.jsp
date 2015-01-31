<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%    
    String serial = request.getParameter("serial");
    int id = Integer.parseInt(request.getParameter("id"));

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date registerDate = sdf.parse(request.getParameter("registerDate"));
    String stuff = request.getParameter("stuff");
    String[] lines = stuff.split("\n");
    // String note = request.getParameter("note");

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ArrayList<VchrItem> new_vitems = vsvc.parse(lines);

        VchrHolder v = new VchrHolderMgr(tran_id).findX("id=" + id, _ws2.getBunitSpace("buId"));
        vsvc.modifyManualVoucher(v, registerDate, new_vitems, ud2.getId());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (Exception e) {
        e.printStackTrace();
        if (e.getMessage()!=null) {
          %>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
        } else {
          %>@@發生錯誤<%
        }
        return;
    }
    finally {
        if (!commit)
            dbo.Manager.rollback(tran_id);
    }    
%>