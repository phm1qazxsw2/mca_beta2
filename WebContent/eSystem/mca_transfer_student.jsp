<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,mca.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<blockquote>
轉校至:
<form action="mca_transfer_student2.jsp" action=POST>
<%
    String id = request.getParameter("id");
    McaStudent s = McaStudentMgr.getInstance().find("id=" + id);
    ArrayList<Bunit> bunits = BunitMgr.getInstance().retrieveList("flag=" + Bunit.FLAG_BIZ, "");
    int bid = _ws2.getSessionBunitId();
    for (int i=0; i<bunits.size(); i++) {
        Bunit b = bunits.get(i);
        %><input type=radio name="campus" value="<%=b.getId()%>" <%=(bid==b.getId())?"checked":""%>><%=b.getLabel()%><br><%
    }
%>    
<input type=hidden name="id" value="<%=id%>">
<br>
<input type=submit value="Submit">
</form>
</blockquote>