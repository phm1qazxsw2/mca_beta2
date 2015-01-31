<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,mca.*" contentType="text/html;charset=UTF-8"%><%@ include file="justHeader.jsp"%><%!
    String getDescription(McaAuthorizer a) 
    {
        StringBuffer sb = new StringBuffer();
        sb.append(a.getAccount_Name());
        if (a.getDescription1().length()>0) {
            sb.append(",");
            sb.append(a.getDescription1());
        }
        if (a.getDescription2().length()>0) {
            sb.append(",");
            sb.append(a.getDescription2());
        }
        return phm.util.TextUtil.escapeJSString(sb.toString());
    }
%><%
try {
    String code = request.getParameter("code");
    String[] tokens = code.split("-");
    McaAuthorizerMgr aumgr = McaAuthorizerMgr.getInstance();
    aumgr.setDataSourceName("mssql");
    String q = "Account_Number='" + tokens[0] + "' and Sub_Account='" + tokens[1] + "'";
    McaAuthorizer a = aumgr.find(q);
    out.println(McaService.getAcodeDescription(a));
}
catch (Exception e) {
    out.println("(空白)");
}
%>
