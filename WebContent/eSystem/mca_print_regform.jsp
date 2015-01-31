<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
McaPrint p = null;
String fname = null;
try {
    int feeId = Integer.parseInt(request.getParameter("id"));
    McaFee fee = McaFeeMgr.getInstance().find("id=" + feeId);
    p = new McaPrint(request.getRealPath("/"));
    p.printRegForm(fee, _ws2.getBunitSpace("bill.bunitId"));
    fname = p.getOutputFileName();
}
catch (Exception e) {
    e.printStackTrace();
    throw e;
}
finally {
    if (p!=null) 
        p.close();
}
%>

<form target="_blank" action="../pdf_output/<%=fname%>">
<input type=submit value="Download PDF">
</form>
