<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String field = request.getParameter("field");
%>
<script>
function doSelect(id, name) {
    parent.setTarget_<%=field%>(id, name);
    parent.settarget<%=field%>.hide();
}

function doCancel() {
    parent.settarget<%=field%>.hide();
}
</script>
<%!
    public String getLink(MembrMembrData md) {
        if (md==null)
            return "";
        String ret = "<a href=\"javascript:doSelect("+md.getM2Id()+",'"+phm.util.TextUtil.escapeJSString(md.getName())+"')\">" + md.getName() + "</a><br>";
        return ret;
    }
%>
<div class=es02>
&nbsp;&nbsp;<b>選擇對象:</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

<form name="f1">
<%
    int mid = Integer.parseInt(request.getParameter("mid"));
    Iterator<MembrMembrData> iter = MembrMembrDataMgr.getInstance().retrieveList("m1Id="+mid, "").iterator();
    while (iter.hasNext()) {
        MembrMembrData md = iter.next();
      %><%=getLink(md)%><%
    }
%>
<br>
</form>
<br>

<br>
</blockquote>

