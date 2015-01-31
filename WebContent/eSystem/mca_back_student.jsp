<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<blockquote>
Back to Grade (<%=_ws2.getSessionBunit().getLabel()%>)
<form action="mca_back_student2.jsp" action=POST>
<%
    String id = request.getParameter("id");
    McaStudent s = McaStudentMgr.getInstance().find("id=" + id);
    ArrayList<Tag> tags = new McaService(0).getCurrentTags(_ws2.getSessionBunitId());
    Map<Integer, Tag> tagprogMap = new SortingMap(tags).doSortSingleton("getProgId");

    for (int i=McaService.PROG_GRADE_K; i<=McaService.PROG_GRADE_12; i++) {
        Tag tag = tagprogMap.get(i);
        %><input type=radio name="grade" value="<%=tag.getId()%>"><%=tag.getName()%><br><%
    }
%>    
<input type=hidden name="id" value="<%=id%>">
<br>
<input type=submit value="Submit">
</form>
</blockquote>