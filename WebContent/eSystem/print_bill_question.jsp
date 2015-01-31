<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    int q = -1;
    try { q = Integer.parseInt(request.getParameter("q")); } catch (Exception e) {}
%>
<body>
<blockquote>
<%
if (q==2) { 
%>
    如單張帳單超過便利商店繳款限制，還是可以利用銀行轉帳繳費。如果不嫌麻煩，可另設一新帳單類型，將有些項目拆到另一張帳單上也是一種做法。
<%
}
else if (q==3) { %>
    如果該收費為 0 的帳單確實是要印出給付費者看的，您可以繼續印出。如果該帳單非您願意產生的，可以回上頁繼續修改。
<%
}
else { %>
<!--便利商店沒有開通-->
便利商店與銀行轉帳的功能需要完成合作銀行的帳號申請及與必亨的合約流程，詳細請參考得意算網站的申請流程。
<p>
有問題請洽 必亨客服中心 02-23693566
<%
}
%>
</blockquote>
</body>
