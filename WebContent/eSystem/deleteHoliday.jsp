<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int id = Integer.parseInt(request.getParameter("id"));

    HolidayMgr hm=HolidayMgr.getInstance();
    Holiday h=hm.find(" id ='"+id+"'");

    Object[] o={h};

    hm.remove(o);

%>

    <blockquote>
        <div class=es02>
            此假期已刪除.
        </div>
    </blockquote>