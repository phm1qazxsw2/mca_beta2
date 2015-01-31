<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    int id = Integer.parseInt(request.getParameter("id"));
    SchDefMgr sdmgr = SchDefMgr.getInstance();
    SchDef sd = sdmgr.find("id=" + id);
    String name = request.getParameter("name");
    Date startDate = sdf.parse(request.getParameter("startDate"));
    Date endDate = sdf.parse(request.getParameter("endDate"));
    int type = Integer.parseInt(request.getParameter("type"));
    String content = request.getParameter("content");
    String color = request.getParameter("color");
    sd.setName(name);
    sd.setStartDate(startDate);
    sd.setEndDate(endDate);
    sd.setType(type);
    sd.setContent(content.trim());
    sd.setColor(color);
    sdmgr.save(sd);
%>
<blockquote>
   設定成功！
</blockquote>
<script>
   parent.do_reload = true;
</script>

