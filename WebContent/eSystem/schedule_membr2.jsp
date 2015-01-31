<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    int mid = Integer.parseInt(request.getParameter("mid"));
    int schId = Integer.parseInt(request.getParameter("schId"));
    SchMembrMgr smmgr = SchMembrMgr.getInstance();
    SchMembr sm = smmgr.find("membrId=" + mid + " and schdefId=" + schId);
    SchDefMembr s = SchDefMembrMgr.getInstance().find("membrId=" + mid + " and schdefId=" + schId);

    String[] days = request.getParameterValues("day");
    String note = request.getParameter("note");

    StringBuffer sb = new StringBuffer();
    for (int i=0; days!=null&&i<days.length; i++) {
        String[] tokens = days[i].split("@");
        int dayofMonth = Integer.parseInt(tokens[0]);
        if (sb.length()>0) sb.append(",");
        sb.append(dayofMonth);
    }

    if (!sb.toString().equals(s.getDays())) {
        sm.setDays(sb.toString());
    }
    else {
        sm.setDays(""); // use parent's
    }

    if (!note.equals(s.getNote())) {
        sm.setNote(note);
    }
    else
        sm.setNote(""); // use parent's

    smmgr.save(sm);

%>
<blockquote>
產生成功!
</blockquote>

<script>
    parent.do_reload = true;
</script>


