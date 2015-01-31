<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%    
    try {
        int costpayId = Integer.parseInt(request.getParameter("id"));
        ArrayList<VPaid> vpaids = VPaidMgr.getInstance().retrieveList("costpayId=" + costpayId, "");
        String vitemIds = new RangeMaker().makeRange(vpaids, "getVitemId");
        ArrayList<Vitem> vitems = VitemMgr.getInstance().retrieveList("id in (" + vitemIds + ")", "");
        String backurl = request.getParameter("backurl");

        // if vitems.size() > 1 it must be in a voucher
        if (vitems.size()==1) {
            response.sendRedirect("spending_voucher.jsp?id=I" + vitems.get(0).getId() + "&backurl=" + java.net.URLEncoder.encode(backurl));
        }
        else {
            int vchrId = vitems.get(0).getVoucherId();
            if (vchrId>0)
                response.sendRedirect("spending_voucher.jsp?id=V" + vchrId + "&backurl=" + java.net.URLEncoder.encode(backurl));
            else {
                 response.sendRedirect("spending_voucher.jsp?id=I" + vitems.get(0).getId() + "&backurl=" + java.net.URLEncoder.encode(backurl));
            }
        }
        return;
    }
    catch (Exception e) {
        e.printStackTrace();
      %><script>alert("雜費資歷有誤，請通知管理員");history.go(-1);</script><%
    }
%>