<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='justHeader.jsp'%>
<%
    String serial = request.getParameter("serial");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Date registerDate = sdf.parse(request.getParameter("registerDate"));
    String stuff = request.getParameter("stuff");
    String[] lines = stuff.split("\n");

    boolean commit = false;
    int tran_id = 0;
    try {           
        tran_id = dbo.Manager.startTransaction();
        VoucherService vsvc = new VoucherService(tran_id, _ws2.getSessionBunitId());
        ArrayList<VchrItem> vitems = vsvc.parse(lines);

        VchrHolder v = vsvc.createVoucher(serial, registerDate, vitems, ud2.getId(), _ws2.getSessionBunitId());

        dbo.Manager.commit(tran_id);
        commit = true;
    }
    catch (AlreadyExists a) {
        out.println("@@傳票編號["+serial+"]已存在!");
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