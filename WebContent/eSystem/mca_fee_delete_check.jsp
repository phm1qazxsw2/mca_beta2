<%@ page language="java" buffer="32kb"  import="web.*,jsf.*,phm.ezcounting.*,mca.*,java.lang.reflect.*,java.util.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="justHeader.jsp"%>	
<%
boolean commit = false;
int tran_id = 0;
try {           
    tran_id = dbo.Manager.startTransaction();

    McaFeeMgr feemgr = new McaFeeMgr(tran_id);
    McaFee fee = feemgr.find("id=" + request.getParameter("id"));
    ArrayList<McaRecord> mrs = new McaRecordMgr(tran_id).retrieveList("mcaFeeId=" + fee.getId(), "");

    if (mrs.size()>0) {
        ChargeItemMembrMgr cimgr = new ChargeItemMembrMgr(tran_id);
        String brIds = new RangeMaker().makeRange(mrs, "getBillRecordId");
        if (cimgr.numOfRows("chargeitem.billRecordId in (" + brIds + ") and userId>0")>0)
            out.println("yes");
    }
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
  %>@@<%=phm.util.TextUtil.escapeJSString(e.getMessage())%><%
    } else {
  %>@@Unknown error<%
    }
}
finally {
    if (!commit)
        dbo.Manager.rollback(tran_id);
}
%>