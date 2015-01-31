<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    Calendar c = Calendar.getInstance();
    c.add(Calendar.DATE, -1);
    Date yesterday = c.getTime();

    SchEventAuto se = new SchEventAuto(yesterday, 0);
%>