<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    BillItemMgr bimgr = BillItemMgr.getInstance();
    BillItem bi = bimgr.find("id=" + request.getParameter("bid"));
    int pos = Integer.parseInt(request.getParameter("pos"));
    bi.setPos(pos*10-1); // 設小一點
    String color = request.getParameter("color");
    bi.setColor(color);
    bimgr.save(bi);
%>
<script>
    parent.do_reload = true;
</script>
<blockquote>
 設定成功!
</blockquote>