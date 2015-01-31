<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>

<%@ include file="jumpTop.jsp"%>

<%
    request.setCharacterEncoding("UTF-8");
	String mNumber=request.getParameter("mNumber");
 	String content=request.getParameter("content");

    PaySystem2 ps = PaySystem2Mgr.getInstance().find("id=1");
    EzCountingService svc = EzCountingService.getInstance();
    try {
        svc.sendSms(ps, mNumber, content);
%>
<blockquote>
<div class=es02 align=left>
    <br>
    <br>
	<blockquote>
    <font color=blue>發送成功!</font>
    <br>
    <br>
	簡訊號碼: <%=mNumber%><br> 
	簡訊內容:<%=content%><br>
	</blockquote>
</div>
</blockquote>		
<%	
	}
    catch (Exception e) {
%>
<blockquote>
<div class=es02 align=left>
    <br>
    <br>
	<blockquote>
    	<font color=red>Error:</font>發送失敗!</font>
	<br>
    <br>
	簡訊號碼:
 <%=mNumber%><br> 
	簡訊內容:<%=content%><br>
	</blockquote>
</div>

<%
	}
%>