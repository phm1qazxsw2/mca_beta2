<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<div class=es02>

&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>帳單類型修改</b>
&nbsp;&nbsp;&nbsp;
<a href="listBills.jsp"><img src="pic/last.gif" border=0 width=12> &nbsp;回上一頁</a>

</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
    String name=request.getParameter("name").trim();
    String prettyName=request.getParameter("prettyName").trim();
    int w=Integer.parseInt(request.getParameter("w"));
    int status=Integer.parseInt(request.getParameter("status"));

    BillMgr bm=BillMgr.getInstance();
    int billId=Integer.parseInt(request.getParameter("bid"));
    Bill b = BillMgr.getInstance().find("id="+billId +" and billType=" + Bill.TYPE_BILLING);
    b.setName   	(name);
    b.setPrettyName   	(prettyName);
    b.setStatus   	(status);
    b.setBalanceWay   	(w);

    bm.save(b);
%>

    <br>
    <br>
    <blockquote>    
        <div class=es02>
            修改完成. <br><br>

            <a href="listBills.jsp">回帳單類型</a>
        </div>
    </blockquote>