<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SchEvent e = SchEventMgr.getInstance().find("id=" + request.getParameter("id"));
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    Date d1 = e.getStartTime();
    Date d2 = e.getEndTime();
    if (d2==null) {
        d2 = new Date();
        d2.setTime(d1.getTime() + 8*60*60*1000);
    }

    String note = e.getNote();
    int type = e.getType();
    int hours = e.getLastingHours();
    int mins = e.getLastingMins();

    Membr m = MembrMgr.getInstance().find("id=" + e.getMembrId());
%>

<form name="f1" action="schedule_leave_detail2.jsp" method="post" onsubmit="return doCheck(this);">
<input type=hidden name="id" value="<%=e.getId()%>">
<%@ include file="schedule_leave_inner.jsp"%>
</form>

<script>
   document.f1.submit.value = "修改";
   setTarget_target(<%=m.getId()%>, '<%=phm.util.TextUtil.escapeJSString(m.getName())%>');
   checkReason(document.f1.type);
   checkAffected();
</script>
