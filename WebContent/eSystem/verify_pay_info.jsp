<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    User user = WebSecurity.getInstance(pageContext).getCurrentUser();
    String backurl = request.getParameter("backurl");
    String[] values = request.getParameterValues("testcheck");
    StringBuffer sb = new StringBuffer();
    for (int i=0; values!=null&&i<values.length; i++) {
        String[] tokens = values[i].split("#");
        String id = tokens[0];
        if (sb.length()>0) sb.append(",");
        sb.append(id);
    }
    if (sb.length()>0) {
        String q = "update billpay set verifyStatus=1,verifyId=" + user.getId() + 
            ",verifyDate='" + sdf.format(new Date()) + "' where id in (" + sb.toString() + ")";
        BillPayMgr.getInstance().executeSQL(q);

        q = "update costpay set costpayVerifyStatus="+Costpay2.VERIFIED_YES+",costpayVerifyId=" + user.getId() + 
            ",costpayVerifyDate='" + sdf.format(new Date()) + "' where costpayFeePayFeeID="+Costpay2.COSPAY_TYPE_TUITION+" and  costpayStudentAccountId in (" + sb.toString() + ")";

        Costpay2Mgr.getInstance().executeSQL(q);
    }
    response.sendRedirect(backurl);
%>