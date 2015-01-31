<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2

    request.setCharacterEncoding("UTF-8");
    String name = request.getParameter("name");
    int tagId = Integer.parseInt(request.getParameter("tid"));
    int typeId = Integer.parseInt(request.getParameter("tagtype"));
    int bunitId = 0;
    try { bunitId = Integer.parseInt(request.getParameter("bunit")); } catch (Exception e) {}
    Tag t = TagMgr.getInstance().find("id=" + tagId);
    t.setName(name);
    t.setTypeId(typeId);
    t.setBunitId(bunitId);
    TagMgr.getInstance().save(t);
%>
<blockquote>
修改成功！
<script>
  top.do_reload = true;
</script>
</blockquote>
