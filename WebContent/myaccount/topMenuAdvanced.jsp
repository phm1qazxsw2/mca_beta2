 <%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
 <% 
 request.setCharacterEncoding("UTF-8");  

 PaySystemMgr pmzx=PaySystemMgr.getInstance();
 PaySystem pZ2=(PaySystem)pmzx.find(1);
 %>


 <html>
<head>
<title><%=pZ2.getPaySystemCompanyName()%></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css>
<script language="JavaScript" src="ad01.js"></script>
<script type="text/javascript" src="openWindow.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
</head>
<script language="Javascript">
<!--
// please keep these lines on when you copy the source
// made by: Nicolas - http://www.javascript-page.com

//var your_message = "前往資料備份頁?";
//var times = 0;
//onunload="onul()" 
//function onul() {
 
		
//	if (times == 0) {
 
		
// 		  var leave = confirm(your_message);
//		  if (leave) 
//		  	location = "logoutRedirect.jsp";

		  //times++;
	//}
//}

//-->
</script>
<link rel="stylesheet" href="style.css" type="text/css">
 
<link href=ft02.css rel=stylesheet type=text/css>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--- start flash logo 01 --->
<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=middle>
<td width="75" height=50>
<%=pZ2.getTopLogoHtml()%>
</td>
</td>
<td width="600" class=es02 align=left>
    User 歡迎你
</td>
<td width="300" valign=bottom align=right  class=es02>
	<br>
	<b><%=pZ2.getPaySystemCompanyName()%> 帳務管理系統</b>
</td>
</tr>
</table>
<!--- end flash logo 01 --->

<%@ include file="topContent.jsp"%>
