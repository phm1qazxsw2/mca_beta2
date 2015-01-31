<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
try {           	
	String typeName=request.getParameter("typeName");
	String typePs=request.getParameter("typePs");
    String acctcode = request.getParameter("acctcode");
	
	DiscountTypeMgr dtm=DiscountTypeMgr.getInstance();
	DiscountType dt=new DiscountType();
	dt.setDiscountTypeName   	(typeName);
	dt.setDiscountTypeActive   	(1);
	dt.setDiscountTypePs   	(typePs);
    dt.setAcctcode(acctcode);  // ## 2009/2/8
    dt.setBunitId(_ws2.getSessionMetaBunitId());

    if (acctcode!=null && acctcode.trim().length()>0) {
        VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
        Acode a = vsvc.getAcodeFromAcctcode(acctcode.trim());
        if (a==null)
            throw new Exception("會計科目["+acctcode.trim()+"]不存在");
    }

	int dtId = dtm.createWithIdReturned(dt);

    // ## 2009/2/8 - by peter, 科目用設定的(看上面)，不用程式產生的
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    vsvc.getDiscountAcode(dtId);

	response.sendRedirect("listDiscountType.jsp?m=2");	
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
%>