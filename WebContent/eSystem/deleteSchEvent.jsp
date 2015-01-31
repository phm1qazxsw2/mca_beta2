<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,cardreader.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    int seId=Integer.parseInt(request.getParameter("seId"));

    SchEventMgr sem=SchEventMgr.getInstance();
    SchEvent se=sem.find("id="+seId);
    SchEvent[] targets = { se };
    sem.remove(targets);

%>
<blockquote>
    <div class=es02>刪除成功.</div>
</blockquote>