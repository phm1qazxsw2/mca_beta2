<%@ page language="java"  
    import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,mca.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }

    DLetterHelper dh = new DLetterHelper(_ws2.getSessionBunitId(), request.getRealPath("/"));
    dh.printLetters();   
    out.println(dh.getFileName());
%>