<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    Date from = sdf.parse(request.getParameter("from"));
    
    String[] urls = {
        "http://218.32.77.178/starlight/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/jsdaycare/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/jsftn/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/hoho/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/daniel/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/karen/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/neil/eSystem/test/usage.jsp?from=" + sdf.format(from),
        "http://218.32.77.178/ccg1168/eSystem/test/usage.jsp?from=" + sdf.format(from)
        "http://218.32.77.178/leader/eSystem/test/usage.jsp?from=" + sdf.format(from)
    };

    for (int i=0; i<urls.length; i++) {
        out.println(phm.util.URLConnector.getContent(urls[i], 2000, "UTF-8") + "<br>");
    }
%>
