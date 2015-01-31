<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    AdmStudentMgr amgr = AdmStudentMgr.getInstance();
    amgr.setDataSourceName("billing");
    ArrayList<AdmStudent> students = amgr.retrieveList("", "");
    for (int i=0; i<students.size();i++) {
        AdmStudent a = students.get(i);
        out.println(a.getStudentFirstName() + " " + a.getStudentSurname() + "<br>");
    }

    int imported = McaImEx.importNewStudent();
    int exported = McaImEx.exportModifiedStudent();

    out.println("##############################################<br>");
    out.println("Imported:" + imported + "<br>");
    out.println("Exported:" + exported + "<br>");

    out.println("##############################################<br>");
    McaAccountMgr mamgr = McaAccountMgr.getInstance();
    mamgr.setDataSourceName("mssql");
    ArrayList<McaAccount> accounts = mamgr.retrieveList("", "");
    out.println("<table border=1>");
    for (int i=0; i<accounts.size(); i++) {
        McaAccount a = accounts.get(i);
        out.println("<tr><td>");
        out.println(a.getAccount());
        out.println("</td><td>"); 
        out.println(a.getLocation());
        out.println("</td><td>"); 
        out.println(a.getCurrency());
        out.println("</td><td>"); 
        out.println(a.getPayment_Type());
        out.println("</td></tr>"); 
    }
    out.println("</table>");

    out.println("##############################################<br>");
    McaAuthorizerMgr aumgr = McaAuthorizerMgr.getInstance();
    aumgr.setDataSourceName("mssql");
    ArrayList<McaAuthorizer> authrs = aumgr.retrieveList("", "");
    out.println("<table border=1>");
    for (int i=0; i<authrs.size(); i++) {
        McaAuthorizer a = authrs.get(i);
        out.println("<tr><td>");
        out.println(a.getAccount_Number());
        out.println("</td><td>"); 
        out.println(a.getSub_Account());
        out.println("</td><td>"); 
        out.println(a.getAccount_Name());
        out.println("</td><td>"); 
        out.println(a.getDescription1());
        out.println("</td><td>"); 
        out.println(a.getDescription2());
        out.println("</td><td>"); 
        out.println(a.getPrimary_Authorizer());
        out.println("</td><td>"); 
        out.println(a.getSecondary_Authorizer());
        out.println("</td><td>"); 
        out.println(a.getBudget());
        out.println("</td></tr>"); 
    }
    out.println("</table>");

%>

