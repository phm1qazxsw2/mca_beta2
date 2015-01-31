<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    StringBuffer sb = new StringBuffer();
    ArrayList<MembrMembr> targets = MembrMembrMgr.getInstance().retrieveList("m1Id=" + request.getParameter("id"), "");
    for (int i=0; i<targets.size(); i++) {
        MembrMembr mm = targets.get(i);
        if (sb.length()>0) sb.append(",");
        sb.append(mm.getM2Id());
    }
%><%=sb.toString()%>