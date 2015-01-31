<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*,mca.*" contentType="text/javascript;charset=UTF-8"%><%
    StringBuffer sb = new StringBuffer();
/*
    McaAuthorizerMgr aumgr = McaAuthorizerMgr.getInstance();
    aumgr.setDataSourceName("mssql");
    WebSecurity _ws2 = WebSecurity.getInstance(pageContext);
    String q = McaService.getAcodeSubQueryString(_ws2.getSessionBunit());
    ArrayList<McaAuthorizer> authrs = aumgr.retrieveList(q, "");
    for (int i=0; i<authrs.size(); i++) {
        McaAuthorizer a = authrs.get(i);
        if (sb.length()>0)
            sb.append(",\n");
        sb.append('"');
        sb.append(a.getAccount_Number()+"-"+a.getSub_Account());
        sb.append('"');
        sb.append(',');
        sb.append('"');
        sb.append(McaService.getAcodeDescription(a));
        sb.append('"');
    }
*/
%>
var aNames = [
<%=sb.toString()%>
];
