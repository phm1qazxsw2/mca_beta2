<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,602))
    {
        response.sendRedirect("authIndex.jsp?code=602");
    }
    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    String backurl = request.getParameter("backurl");
    TagTypeMgr ttmgr = TagTypeMgr.getInstance();
    TagType tt = new TagType();
    tt.setName(name);
    ttmgr.create(tt);
    tt.setNum(tt.getId());
    tt.setBunitId(_ws2.getSessionBunitId());
    ttmgr.save(tt);
    backurl += (backurl.indexOf("?")<0)?"?":"&";
    response.sendRedirect(backurl + "t=" + tt.getId());
%>
