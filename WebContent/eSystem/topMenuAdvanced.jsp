<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="authCheck.jsp"%>
<% 
    request.setCharacterEncoding("UTF-8");  
    WebSecurity _ws = WebSecurity.getInstance(pageContext);
    WebSecurity _wsc = _ws;
    User ud2 = _ws.getCurrentUser();
    PaySystemMgr pmzx=PaySystemMgr.getInstance();
    PaySystem pZ2=(PaySystem)pmzx.find(1);
    PaySystem pd2 = pZ2;

    if(ud2==null)
    {
 %>
  	<%@ include file="noUser.jsp"%>
 <% 
        return;
    }	

    Hashtable authHa=(Hashtable)session.getAttribute("auth");
    if(authHa==null)
    {
        JsfAdmin ja22=JsfAdmin.getInstance();
        WebSecurity _ws2 = WebSecurity.getInstance(pageContext);
        User authud2 = _ws2.getCurrentUser();
        authHa=ja22.getHaAuthuser(authud2.getId());    
        session.setAttribute("auth",authHa);
    }

    int pageType=0;
    
 %>
<html>
<head>
<title><%=new BunitHelper().getCompanyNameTitle(_ws.getSessionBunitId())%></title>
<link rel="shortcut icon" href="favicon.ico" />
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">

<link href=ft02.css rel=stylesheet type=text/css>
<link rel="stylesheet" href="menu.css" type="text/css">
<link rel="stylesheet" href="style.css" type="text/css">
<link href=ft02.css rel=stylesheet type=text/css>
<link rel="stylesheet" href="css/dhtmlwindow.css" type="text/css" />

<script language="JavaScript" src="ad01.js"></script>
<script type="text/javascript" src="openWindow.js"></script>
<script src="js/menubarAPI4.js" type="text/javascript"></script>

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

function offLay() { 
    elem = document.getElementById("overlay"); 
    elem.style.visibility="hidden";
}

function onLay() { 
    elem = document.getElementById("overlay"); 
    elem.style.height="200%"
    elem.style.visibility="visible";
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

function init(){

if(!window.standards) return;

if(window.inited) return;
//////////////////////////////////  GLOBAL OFFSET VARIABLES //////////////////////////////	
	if(bw.wIE || bw.ns){
		menuOffsetTop = 3; // first level menu. smaller number is more up
		menuOffsetLeft = 2; // first level menu. smaller number is more right.
	}
	else if(bw.mIE){
		menuOffsetTop = -1; // first level menu. smaller number is more right
		menuOffsetLeft = -6; // first level menu. smaller number is more right
	}
	submenuOffsetTop = -14 ;// smaller number is closer to top

	if(bw.wIE) submenuOffsetLeft = -12; // left-side menu. smaller number is closer to menu
	else if(bw.mIE) submenuOffsetLeft = -4; // left-side menu. smaller number is closer to menu

	submenuOffsetRight = 0;// right-side menu.  smaller number is closer to menu.
    //////////////////////////////////  GLOBAL OFFSET VARIABLES //////////////////////////////	

	var uiMenubar = new Menubar();
<%
    ArrayList<Bookmark> historys = BookmarkMgr.getInstance().retrieveList("userId="+ud2.getId(), "order by id desc limit 20");
    Map<String, Vector<Bookmark>> historyMap = new SortingMap(historys).doSort("getName");
    Iterator<String> name_iter = historyMap.keySet().iterator();
    if (ud2.getUserRole()<6 && historys.size()>0) {  %>
	wqpMenu = new Menu('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;瀏覽歷史&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
<%
        while (name_iter.hasNext()) {
            String nname = name_iter.next();
            Bookmark bm = historyMap.get(nname).get(0); %>
    	wqpMenu.add(new MenuItem('<%=phm.util.TextUtil.escapeJSString(nname)%>','<%=phm.util.TextUtil.escapeJSString(bm.getUrl())%>'));
<%      } %>
	uiMenubar.add(wqpMenu);
	uiMenubar.useMouseOver();
	document.body.appendChild(uiMenubar);
<%  } %>
	
	// setWidth method added april 2, 2002.
	uiMenubar.setWidth("auto",0);
	window.inited = true;
}
//-->
</script>

<body onload="init();monitor=document.getElementById('mon')" bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<!--- start flash logo 01 --->


<div id="overlay" style="-moz-opacity:.30;filter=Alpha(Opacity=30);visibility:hidden;width:100%; height:100%; position: absolute; background-color:#000000;"> 
</div> 


<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=middle>
<td width="10%">
<%=pZ2.getTopLogoHtml()%>
</td>
</td>
<td width="80%" class=es02 align=left nowrap>
<form>
	<%=JsfTool.getUserIcon(ud2, _ws.getBunitSpace("bunitId"))%>
        &nbsp;<a href="logoutRedirect.jsp">(登出)</a>
    <%
        String _selector = _ws.getBunitSelector();
        if (_selector.length()>0)
            out.println("　　　 目前單位：" + _selector);
    %>
</form>
</td>
<td width="10%" valign=bottom align=right class=es02 nowrap>
    <img src="images/spacer.gif" height=30>
	<br>
	<b><%=new BunitHelper().getCompanyNameTitle(_ws.getSessionBunitId())%></b>&nbsp;&nbsp;&nbsp;&nbsp;
</td>
</tr>
</table>
<!--- end flash logo 01 --->

<%@ include file="topContent.jsp"%>

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