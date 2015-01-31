<%@ page language="java" import="java.net.*,java.io.*" contentType="text/html;charset=UTF-8"%><%
try {
    String relay = "http://218.32.77.180:8080/cardreader/requestCard.jsp";

    // local use String relay = "http://localhost:8081/cardreader/requestCard.jsp";
    String queryString = request.getQueryString();
    String url = relay + "?" + queryString;
    // String resp = phm.util.URLConnector.getContent(url , 10000, "UTF-8");
    URL u = new URL(url);
    URLConnection uc = u.openConnection();
    BufferedReader theHTML = new BufferedReader(new InputStreamReader(uc.getInputStream()));
    String resp = "", line = "";
    while ((line=theHTML.readLine())!=null)
        resp += line + "\n";
    out.print(resp);
}
catch (Exception e) {
    e.printStackTrace();
}
%>