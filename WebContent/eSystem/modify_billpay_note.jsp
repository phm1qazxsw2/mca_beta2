<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<%
    BillPay bp = BillPayMgr.getInstance().find("id=" + request.getParameter("pid"));
%>
<B>&nbsp;&nbsp;編輯註記</B>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<%
    if(bp ==null)
    {
%>
        <br>
        <br>
        <blockquote>
        <div class=es02>
        沒有此交易記錄!
        </div>
        </blockquote>
<%
        return;
    }
%>
<center>
    <form action="modify_billpay_note2.jsp">

    <textarea name="note" rows=3 cols=30><%=(bp.getNote()!=null)?bp.getNote():""%></textarea>

    <input type=hidden name="pid" value="<%=bp.getId()%>">
    <br><br>
    <input type=submit value="確認修改">

    </form>

</center>

