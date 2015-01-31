<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
int mid = Integer.parseInt(request.getParameter("mid"));
McaStudentMgr msmgr = McaStudentMgr.getInstance();
McaStudent ms = msmgr.find("id=" + mid);

try {
    ms.setBillCountryID("");
    ms.setBillCountyID("");
    ms.setBillCityID("");
    ms.setBillDistrictID("");
    ms.setBillPostalCode("");
    ms.setBillChineseStreetAddress("");
    ms.setBillEnglishStreetAddress("");
    msmgr.save(ms);
}
catch (Exception e) {
    if (e.getMessage()!=null) {
  %>@@<%=e.getMessage()%><%
    } else {
        e.printStackTrace();
  %>@@錯誤發生，資料沒有寫入<%
    }
}
%>