<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='jumpTop.jsp'%>
<%
	String m=request.getParameter("m");
	
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);
	
	if(e.getPaySystemMessageActive()==1)
		e.setPaySystemMessageActive(0);
	else
		e.setPaySystemMessageActive(1);

	em.save(e);
%>
<script type="text/javascript">
<!--

	alert('訊息發送狀態已修改!');
 
	window.close();
//-->
</script>

<BR>
<BR>
    <CENTER>
        <div class=es02>修改完成.</div>
    </center>
