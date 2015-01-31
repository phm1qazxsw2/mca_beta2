<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm");
    SchEventMgr smgr = SchEventMgr.getInstance();
    SchEvent s = smgr.find("id=" + request.getParameter("id"));

    int targetId = Integer.parseInt(request.getParameter("target"));
    Date startTime = sdf.parse(request.getParameter("startTime"));
    Date endTime = null;
    try { endTime = sdf.parse(request.getParameter("endTime")); } catch (Exception e) {}
    int lastingHours = 0;
    try { lastingHours = (int)(Float.parseFloat(request.getParameter("lastingHours"))); } catch (Exception e) {}
    int lastingMins = 0;
    try { lastingMins = (int)(Float.parseFloat(request.getParameter("lastingMins"))); } catch (Exception e) {}
    int type = Integer.parseInt(request.getParameter("type"));
    String note = request.getParameter("note");

    s.setModifyTime(new Date());
    s.setMembrId(targetId);
    s.setStartTime(startTime);
    s.setEndTime(endTime);
    s.setLastingHours(lastingHours);
    s.setLastingMins(lastingMins);    
    s.setUserId(ud2.getId());
    s.setType(type);
    s.setNote(note);
    smgr.save(s);
%>
<blockquote>
  修改成功!
</blockquote>
<script>
  parent.do_reload = true;
</script>