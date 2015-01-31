<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM");
    int id = Integer.parseInt(request.getParameter("id"));
    SchDefMgr smgr = SchDefMgr.getInstance();
    SchDef sdef = smgr.find("id=" + id);
    Date month = sdf.parse(request.getParameter("month"));
    String name = request.getParameter("name");
    String startHr = request.getParameter("startHr");
    String endHr = request.getParameter("endHr");
    int offMin = 0;
    try { offMin=Integer.parseInt(request.getParameter("offMin")); } catch (Exception e) {}
    String[] days = request.getParameterValues("day");
    String note = request.getParameter("note");

    sdef.setMonth(month);
    sdef.setName(name);
    sdef.setStartHr(startHr);
    sdef.setEndHr(endHr);
    sdef.setOffMin(offMin);
    sdef.setNote(note);

    StringBuffer sb = new StringBuffer();
    for (int i=0; days!=null&&i<days.length; i++) {
        String[] tokens = days[i].split("@");
        int dayofMonth = Integer.parseInt(tokens[0]);
        if (sb.length()>0) sb.append(",");
        sb.append(dayofMonth);
    }

    sdef.setDays(sb.toString());
    smgr.save(sdef);
%>
<blockquote>
儲存成功!
</blockquote>
<script>
    parent.do_reload = true;
</script>


