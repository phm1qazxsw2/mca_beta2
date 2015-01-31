<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*,mca.*,dbo.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
boolean commit = false;
int tran_id = 0;
try { 
    tran_id = Manager.startTransaction();  
    McaFee fee = new McaFeeMgr(tran_id).find("id=" + request.getParameter("feeId"));
System.out.println("## fee=" + fee + " id=" + request.getParameter("feeId"));
    McaService svc = new McaService(tran_id);
    svc.upgradeMCA(fee);

    commit = true;
    Manager.commit(tran_id);
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
    %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    }
    else {
    %><script>alert("錯誤發生，設定沒有寫入");history.go(-1);</script><%
    }
    return;
}
finally {
    if (!commit) {
        try { Manager.rollback(tran_id); } catch (Exception e) {}
    }
}
%>
<blockquote>
done!
</blockquote>
<script>
    parent.do_reload = true;
</script>