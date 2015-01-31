 <%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
 <% 


 request.setCharacterEncoding("UTF-8");  
 User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
 PaySystemMgr pmzx=PaySystemMgr.getInstance();
 PaySystem pZ2=(PaySystem)pmzx.find(1);

  if(ud2==null)
  {
  %>
  	<%@ include file="noUser.jsp"%>
<% 
  	return;
  }			
  
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
<link rel="stylesheet" href="style.css" type="text/css">
 
<link rel="stylesheet" href="ft02.css" type="text/css">

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--- start flash logo 01 --->
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=middle>
<td width="75">
<object codebase="flash/swflash.cab#version=6,0,0,0" width="75" height="75" id="logo01" align=""><param name=movie value="logo01.swf"><param name=quality value=high><param name="wmode" value="transparent"><embed src="flash/logo01.swf" quality=high width="75" height="75" name="logo01" wmode="transparent" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed></object></td></td>
</td>
<td width="500" class=es02 align=left> 
 
	<a href="userIndex.jsp"><b><img src="pic/user.gif" border=0><font class=es02 color=blue><%=ud2.getUserFullname()%></font></b></a> 你好

</td>
<td width="400" valign=bottom align=right  class=es02>
    <a href="myShowCostPay.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image2','','img/m1a.gif',1)"><img src="img/m1.gif" name="Image2" border="0"></a>     
 
	<a href="addCostbook.jsp?type=1" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','img/m2a.gif',1)"><img src="img/m2.gif" name="Image4" border="0"></a>         
	<a href="addInsideTrade.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image5','','img/m3a.gif',1)"><img src="img/m3.gif" name="Image5" border="0"></a>         
    <a href="listMessage.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image1','','img/m4a.gif',1)"><img src="img/m4.gif" name="Image1" border="0"></a>     
    <a href="functionIndex.jsp" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image6','','img/m5a.gif',1)"><img src="img/m5.gif" name="Image6" border="0"></a>     
	<br>
	<b><%=pZ2.getPaySystemCompanyName()%></b>
</td>
</tr>
</table>
<!--- end flash logo 01 --->

<%@ include file="newtopContent.jsp"%>