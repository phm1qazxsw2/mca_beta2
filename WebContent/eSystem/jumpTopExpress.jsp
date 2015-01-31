<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%@ include file="authCheck.jsp"%>
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
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css> 
<link rel="stylesheet" href="style.css" type="text/css">
</head>

<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<table bgcolor=#ff0000 background=pic/bg01.gif width="<%=frameWidth%>" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>

<table bgcolor=#696A6E width="<%=frameWidth%>" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=left><img src="pic/littleE.png" border=0 height=15>&nbsp;快速編輯</td>

</tr>
</table> 
<div class=es02 align=right><a href="#" onClick="window.location.reload();return false"><img src="pic/refresh.gif" border=0 alt="重新整理"></a></div>
<br>