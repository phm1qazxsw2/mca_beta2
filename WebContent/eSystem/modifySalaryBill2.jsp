<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<div class=es02>

&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>薪資類型修改</b>
&nbsp;&nbsp;&nbsp;


</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<%
    String name=request.getParameter("name").trim();
    String prettyName=request.getParameter("prettyName").trim();
    int priv=Integer.parseInt(request.getParameter("priv"));
    int status=Integer.parseInt(request.getParameter("status"));

    BillMgr bm=BillMgr.getInstance();
    int billId=Integer.parseInt(request.getParameter("bid"));
    Bill b = BillMgr.getInstance().find("id="+billId +" and billType=" + Bill.TYPE_SALARY);
    b.setName   	(name);
    b.setPrettyName   	(prettyName);
    b.setStatus   	(status);
    b.setPrivLevel(priv);

    bm.save(b);
%>

    <br>
    <br>
    <blockquote>    
        <div class=es02>
            修改完成. <br><br>

            <a href="list_salary_bills.jsp">回薪資類型</a>
        </div>
    </blockquote>