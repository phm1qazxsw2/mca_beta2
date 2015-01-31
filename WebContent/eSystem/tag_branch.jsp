<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    request.setCharacterEncoding("UTF-8");
    int tagId = Integer.parseInt(request.getParameter("tid"));
    Tag tag = TagMgr.getInstance().findX("id=" + tagId, , 0, _ws.getStudentBunitSpace("bunitId"));
    if (tag.getBranchTag()>0) {
        %>已經產生過新一期的標籤，不能再次產生<%
        return;
    }
    TagHelper th = TagHelper.getInstance(pd2, 0, _ws2.getSessionStudentBunitId());
    th.setup(tag);
%>
<blockquote>
<b><%=tag.getName()%></b>
<br>
<% if (th.getBillChargeItem(tag).size()>0) { %>
<br>
新一期標籤 "<%=tag.getName()%>" 會套用至下一期 <%=th.getBillChargeItemString(tag, false)%> 帳單
<br>
<% } %>
<br>
本期的標籤會設成停用(勾選"顯示所有"還是可以看到)
<br>
<form action="tag_branch2.jsp" method=post>
<br>確定進行?
    <input type=hidden name="tid" value="<%=tagId%>">
    <input type=hidden name="backurl" value="<%=request.getParameter("backurl")%>">
　　<input type=submit value="繼續">
　　<input type=button value="取消" onclick="parent.location.reload();">
</form>
</blockquote>

<script>
    parent.do_reload = true;
</script>