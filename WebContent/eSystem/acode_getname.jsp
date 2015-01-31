<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%><%@ include file="justHeader.jsp"%><%
    String code = request.getParameter("code");
    if (code.length()<4) {
        out.println("(空白)");
        return;
    }
    String main = code.substring(0,4);
    String sub = null;
    code = code.replace("-","#"); // 對應 ajax_get_name 的 replace
    if (code.length()>4) 
        sub = code.substring(4);
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    Acode a = vsvc._get_acode(main, sub);
    if (a==null) {
        out.println("(空白)");
        return;
    }
    AcodeInfo ainfo = AcodeInfo.getInstance(a);
    out.println(ainfo.getName(a));
%>
