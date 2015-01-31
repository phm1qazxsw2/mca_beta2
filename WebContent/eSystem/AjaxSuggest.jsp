<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu1.jsp"%>

<link rel="stylesheet" href="style.css" type="text/css">
<%
if(!AuthAdmin.authPage(ud2,4))
{
    response.sendRedirect("authIndex.jsp?info=1&page=7");
}
%> 

<script language="JavaScript">

var objNav=window.navigator;

var ran=0;
</script>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>



<style type="text/css">
body {
   font: 11px;
}
.Link {
   background-color: #FFFFFF;   
   padding: 2px 6px 2px 6px;
}
.LinkOver {
   background-color: #3366CC;
   padding: 2px 6px 2px 6px;
}
	
}		
</style>
 

  
  
</head>
<body>
  <%
		String m=request.getParameter("m"); 
		
    	String xAccount=request.getParameter("account");

	if(m !=null)	
	{
    %>
  	<script> 
  	  	alert("登入完成!"); 
  	  	 
		window.location='AjaxSuggest.jsp';
  	</script>
<%
	}
%>			

<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/feeIn.png" border=0> 學費銷帳-指定匯款帳號</b>
	<blockquote>
	<form id="xForm" action="listStudentFeeticket.jsp" action="get"> 
		<table border=0>
		<tr>
			<tD>
				轉入帳號:
			</tD>
			<td>
				<input type=hidden name="studentId" value="">
				<input type="text" name="txtSearch" value="<%=(xAccount!=null)?xAccount:""%>" onkeyup="getSuggest(this.value)" onchange="getSuggest(this.value)" autocomplete="off">
				<input type=hidden name="webType" value="1">
		
			</tD>
			<td>		
				(說明: 不需輸入銀行代號) 
				
			</td>
		</tr>
		</table> 
		</form>

	</blockquote>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
 
	<table border=0 width=100%>
	<tr>
		<td valign=top width=50%>
			<div id="result"></div>
		</td>
		<td valign=top width=50%>
			<div id="realtime"></div>
		</td>
	</tr> 
	<tr>
		<tD colspan=2> 
			<br>
			<br>
			
			&nbsp&nbsp&nbsp&nbsp<a href="listStudentType2.jsp"><img src="pic/fix.gif" border=0>編輯學生ATM帳號</a>
			|
			<a href="salaryBankAccount.jsp"><img src="pic/fix.gif" border=0>編輯銀行ATM匯入帳戶</a>
			
		</tD>
	</tr>
	</table>


<script type="text/javascript">
<!--
  
  document.getElementById('txtSearch').focus(); 	
//-->


</script>



</body>
</html> 

<%
	if(xAccount !=null)
 
	{ 
%> 
		<script>
			getSuggest('<%=xAccount.trim()%>'); 
		</script>
<%
	}
%>


<%@ include file="bottom.jsp"%>
