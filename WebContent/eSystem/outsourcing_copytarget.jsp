<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
function doSelect(id) {
    parent.selectCopyFrom(id);
    parent.copylistwin.hide();
}

function doCancel() {
    parent.copylistwin.hide();
}
</script>
<%!
    public String getLink(MembrTeacher t) {
        if (t==null)
            return "";
        String ret = "<a href=\"javascript:doSelect("+t.getMembrId()+")\">" + t.getName() + "</a><br>";
        return ret;
    }
%>
<%
    ArrayList<MembrTeacher> teachers = MembrTeacherMgr.getInstance().retrieveList("teacherStatus!=0", "");
%>
<div class=es02>
&nbsp;&nbsp;<b>選擇複製的對象:</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>

<form name="f1">
<%
    for (int i=0; i<teachers.size(); i++) {
        MembrTeacher t = teachers.get(i);
        out.println("<div class=es02>"+getLink(t)+"</div>");
    }
%>


</form>
</blockquote>

