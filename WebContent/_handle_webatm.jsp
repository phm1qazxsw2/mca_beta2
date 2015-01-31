<H2>PHM WEBADM HANDLER</H2>
<%
    System.out.println("#### handler webadm");
    java.util.Enumeration names = request.getParameterNames();
    while (names.hasMoreElements()) {
        String name = (String) names.nextElement();
        System.out.println(name + ":" + request.getParameter(name));
    }
%>
