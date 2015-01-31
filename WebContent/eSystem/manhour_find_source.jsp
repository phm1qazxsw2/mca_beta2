<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String field = request.getParameter("field");
%>
<script>
function doSelect(id, name) {
    parent.setSource_<%=field%>(id, name);
    parent.setsource<%=field%>.hide();
}
 
function doCancel() {
    parent.setsource<%=field%>.hide();
}
</script>
<%!
    public String getLink(MembrTeacher t) {
        if (t==null)
            return "";
        String ret = "<a href=\"javascript:doSelect("+t.getMembrId()+",'"+phm.util.TextUtil.escapeJSString(t.getName())+"')\">" + t.getName() + "</a><br>";
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
    Iterator<MembrTeacher> iter = MembrTeacherMgr.getInstance().retrieveList("teacherStatus in (1,2,3)", "").iterator();
    while (iter.hasNext()) {
        MembrTeacher t = iter.next();
      %><%=getLink(t)%><%
    }
%>
<br>
</form>
<br>

<br>
</blockquote>

