<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%@ include file="authCheck.jsp"%>
<%
int pageType=1;
%>
<html>
<%
    HttpSession session2=request.getSession(true);
    Hashtable authHa=(Hashtable)session2.getAttribute("auth");
    WebSecurity _ws2 = WebSecurity.getInstance(pageContext);
    if(authHa ==null){
        JsfAdmin ja22=JsfAdmin.getInstance();        
        User authud2 = _ws2.getCurrentUser();
        authHa=ja22.getHaAuthuser(authud2.getId());    
        session2.setAttribute("auth",authHa);
    }

     User ud2 = _ws2.getCurrentUser();
     PaySystemMgr pmx2=PaySystemMgr.getInstance();
     PaySystem pd2=(PaySystem)pmx2.find(1);
     if(ud2==null)
      {
      %>
        <%@ include file="noUser.jsp"%>
    <% 
        return;
      }
    %>
<head>
<title><%=new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId())%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />

<script type="text/javascript" src="openWindow.js"></script> 
<script>
function offLay() { 
    elem = document.getElementById("overlay"); 
    elem.style.visibility="hidden";
}

function onLay() { 
    elem = document.getElementById("overlay"); 
    elem.style.height="200%"
    elem.style.visibility="visible";
}


</script>
</head>

<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
<script type="text/javascript">
	_uacct="UA-30013845-2";
	<% 
		String who = (ud2==null)?"(unknown)":("(" + ud2.getUserLoginId() + ")");
		int c1 = request.getRequestURI().indexOf("/eSystem/");
		int c2 = request.getRequestURI().indexOf(".jsp");
		String resource = (c1>0&&c2>0)?request.getRequestURI().substring(c1+9,c2):request.getRequestURI();
	%>
	urchinTracker('<%= resource + who%>');
</script>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div id="overlay" style="-moz-opacity:.30;filter=Alpha(Opacity=30);visibility:hidden;width:100%; height:100%; position: absolute; background-color:#000000;"> 
</div> 

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right><%=new BunitHelper().getCompanyNameTitle(_ws2.getSessionBunitId())%></td>
</tr>
</table> 
<br> 


<!--- end 水平列書籤式按鈕 01 --->

<!--
<script>
function debug(msg)
{
    var d = document.getElementById("debug");
	d.innerHTML = msg + "<br>\n" + d.innerHTML;
}
</script>
<div id=debug style="position:absolute;top:100px;left:700px;width:500px;border:solid grey 1px"></div>
-->