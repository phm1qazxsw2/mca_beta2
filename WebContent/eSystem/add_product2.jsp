<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<%

    String name = request.getParameter("name");
    int safetyLevel = -1;
    try { safetyLevel = Integer.parseInt(request.getParameter("safetyLevel")); } catch (Exception e) {}
    int salePrice = 0;
    try { salePrice = Integer.parseInt(request.getParameter("salePrice")); } catch (Exception e) {}
    PItem pi = new PItem();
    pi.setName(name);
    pi.setSafetyLevel(safetyLevel);
    pi.setStatus(PItem.STATUS_ACTIVE);
    pi.setSalePrice(salePrice);
    pi.setBunitId(_ws2.getSessionBunitId());
    PItemMgr.getInstance().create(pi);
%>
<blockquote>
新增成功!
</blockquote>

<script>
    parent.setPitem(<%=pi.getId()%>, '<%=phm.util.TextUtil.escapeJSString(name)%>');
    parent.pitemwin.hide();
</script>
