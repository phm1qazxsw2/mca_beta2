<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
int mid = Integer.parseInt(request.getParameter("mid"));
McaStudentMgr msmgr = McaStudentMgr.getInstance();
McaStudent ms = msmgr.find("id=" + mid);
boolean isHomeAddr = request.getParameter("type").equals("1");

String CountryID = request.getParameter("CountryID");
String CountyID = request.getParameter("CountyID");
String CityID = request.getParameter("CityID");
String DistrictID = request.getParameter("DistrictID");
String PostalCode = request.getParameter("PostalCode");
String CStreet = request.getParameter("CStreet");
String EStreet = request.getParameter("EStreet");

try {
    if (isHomeAddr) {
        ms.setCountryID(CountryID);
        ms.setCountyID(CountyID);
        ms.setCityID(CityID);
        ms.setDistrictID(DistrictID);
        ms.setPostalCode(PostalCode);
        ms.setChineseStreetAddress(CStreet);
        ms.setEnglishStreetAddress(EStreet);
    }
    else {
        ms.setBillCountryID(CountryID);
        ms.setBillCountyID(CountyID);
        ms.setBillCityID(CityID);
        ms.setBillDistrictID(DistrictID);
        ms.setBillPostalCode(PostalCode);
        ms.setBillChineseStreetAddress(CStreet);
        ms.setBillEnglishStreetAddress(EStreet);
    }
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
%><%=McaService.formatAddr(CountryID, CountyID, CityID, DistrictID, CStreet, PostalCode)%>