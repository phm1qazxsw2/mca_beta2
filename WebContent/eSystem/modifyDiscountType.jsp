<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
try {           
	String typeName=request.getParameter("typeName");
	String typePs=request.getParameter("typePs");
	String typeid=request.getParameter("typeid");
	String typeActive=request.getParameter("typeActive");
	int typeId=Integer.parseInt(typeid);
	int typeActive2=Integer.parseInt(typeActive);
    String acctcode = request.getParameter("acctcode");
	
	DiscountTypeMgr dtm=DiscountTypeMgr.getInstance();
	DiscountType dt=(DiscountType)dtm.find(typeId);
    String oldname = dt.getDiscountTypeName();
	dt.setDiscountTypeName   	(typeName);
	dt.setDiscountTypeActive   	(typeActive2);
	dt.setDiscountTypePs   	(typePs);
    dt.setAcctcode(acctcode); // ## 2009/2/8

    if (acctcode!=null && acctcode.trim().length()>0) {
        VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
        Acode a = vsvc.getAcodeFromAcctcode(acctcode.trim());
        if (a==null)
            throw new Exception("會計科目["+acctcode.trim()+"]不存在");
    }

	dtm.save(dt);

    // ## 2009/2/8 - by peter, 科目用設定的(看上面)，不用程式產生的
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    Acode oa = vsvc.getDiscountAcode(dt.getId());
    if (!oldname.equals(typeName)) {
        Acode a = vsvc.modifyAcode(oa.getId(), typeName);
	}

	response.sendRedirect("listDiscountType.jsp?m=1");	
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