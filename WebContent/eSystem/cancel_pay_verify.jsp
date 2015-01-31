<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    String backurl = request.getParameter("backurl");
    int id = Integer.parseInt(request.getParameter("id"));
    BillPayMgr bpmgr = BillPayMgr.getInstance();
    BillPay bpay = bpmgr.find("id=" + id);
    bpay.setVerifyStatus(BillPay.STATUS_NOT_VERIFIED);
    bpmgr.save(bpay);

    String q = "update costpay set costpayVerifyStatus="+Costpay2.VERIFIED_NO+" where costpayFeePayFeeID="+Costpay2.COSPAY_TYPE_TUITION+" and costpayStudentAccountId=" + id;

    Costpay2Mgr.getInstance().executeSQL(q);
    response.sendRedirect(backurl);
%>