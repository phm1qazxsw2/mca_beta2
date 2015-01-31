<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%> 
<br>
<br> 
<%
	String m=request.getParameter("m");
	if(m!=null)
	{
%>
		<script>
			alert('訊息已發送!');
		</script>		
<%
	}	
	String meIdString=request.getParameter("meId");
	
	Message me=null;
	
	if(meIdString !=null) 
	{
		MessageMgr mm2=MessageMgr.getInstance(); 
		int meIdOriginal=Integer.parseInt(meIdString);	
		
		me=(Message)mm2.find(meIdOriginal);
	}
%>
<script> 
	var ran=1;
</script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>


&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 alt="新增訊息">&nbsp;<b>新增訊息</b> 
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

<form action="addMessage2.jsp" method="post">
<%@ include file="messageContent.jsp"%>

</form>


</blockquote>

<%@ include file="bottom.jsp"%>