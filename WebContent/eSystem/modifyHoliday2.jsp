<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    int type = Integer.parseInt(request.getParameter("type"));
    String namex=request.getParameter("namex");

    Holiday h=HolidayMgr.getInstance().find(" id='"+id+"'");
    h.setType(type);
    h.setName(namex);
    
    HolidayMgr.getInstance().save(h);
%>

    <blockquote>
        <div class=es02>修改完成.
        <br>
        <br>
        <a href="modifyHoliday.jsp?id=<%=id%>">回上一頁</a>
        </div>
    </blockquote>