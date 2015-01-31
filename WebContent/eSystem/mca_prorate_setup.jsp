<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String ticketId = request.getParameter("tid");
    MembrInfoBillRecord sinfo = MembrInfoBillRecordMgr.getInstance().find("ticketId='" + ticketId + "'");
    McaRecord mfr = McaRecordInfoMgr.getInstance().find("billRecordId=" + sinfo.getBillRecordId() + 
        " and mca_fee.status!=-1");
    McaProrate mp = McaProrateMgr.getInstance().find("mcaFeeId=" + mfr.getMcaFeeId() + 
        " and membrId=" + sinfo.getMembrId());
    String cur = (mp==null)?"":new SimpleDateFormat("yyyy-MM-dd").format(mp.getProrateDate());
%>
<script src="js/string.js"></script>
<script src="js/dateformat.js"></script>
<script>
    function check_submit(f)
    {
        f.prorateDate.value = trim(f.prorateDate.value);
        if (!isDate(f.prorateDate.value, "yyyy-MM-dd")) {
            alert("請輸入正確的日期");
            f.prorateDate.focus();
            return false;
        }

        return true;
    }
</script>
<blockquote>
Please specify the starting day for <br><b><%=sinfo.getMembrName()%></b><br><br>
<form action="mca_prorate_setup2.jsp" onsubmit="return check_submit(this);">
<input type=hidden name="tid" value="<%=ticketId%>">
<input name="prorateDate" value="<%=cur%>" size=8> ex: 2009-08-15
<br>
<input type=submit value="設定">
</form>

<% if (mp!=null) { %>
<br>
<br>
<br>
<hr>
<form action="mca_prorate_delete.jsp">
<input type=hidden name="feeId" value="<%=mp.getMcaFeeId()%>">
<input type=hidden name="membrId" value="<%=mp.getMembrId()%>">
<input type=submit value="刪除現有設定">
</form>
<% } %>
</blockquote>
