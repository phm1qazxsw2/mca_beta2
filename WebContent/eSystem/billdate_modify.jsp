<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file='/WEB-INF/jsp/security.jsp'%>
<%
    //##v2
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    User ud2 = WebSecurity.getInstance(pageContext).getCurrentUser();
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?info=1&page=1");
    }
%>
<script>
function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;

}

function checkDate(d) {
    var tokens = d.split("-");
    if (tokens.length!=3)
        return false;
    for (var i=0; i<tokens.length; i++) {
        if (!IsNumeric(tokens[i])) {
            return false;
        }
    }    
    var year = eval(tokens[0]);
    if (year<2000) {
        return false;
    }
    
    if (tokens[0].length!=4 || tokens[1].length!=2 || tokens[2].length!=2) {
        return false;
    }
    
    return true;
}

function check_submit(f)
{
    if (!checkDate(f.billDate.value)) {
        alert("請輸入正確的日期格式, 設定請打西元年.\n如 <%=sdf.format(new Date())%>");
        f.billDate.focus();
        return false;
    }
    return true;
}

</script>

<html>

<head>
<title>修改繳費截止日期和備註</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<meta http-equiv="imagetoolbar" content="no">
<link href=ft02.css rel=stylesheet type=text/css>
 
<link rel="stylesheet" href="style.css" type="text/css">
</head>
<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="alert(testValue);">

<table bgcolor=#ff0000 background=pic/bg01.gif width="100%" height="9" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td class=es02><img src=pic/bg01.gif border=0></td>
</tr>
</table>


<!--- start 水平列書籤式按鈕 01 --->
<table bgcolor=#696A6E width="100%" height="24" border="0" cellpadding="4" cellspacing="0">
<tr align=left valign=middle>
<td class=es02r align=right></td>
</tr>
</table>
 
<br>  
<br>

<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>修改繳費截止日期和備註 </b> 
<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<form action="billdate_modify2.jsp" method="post" onsubmit="return check_submit(this);"> 
<input type=hidden name=rid value="">
<input type=hidden name=sid value="">
<center>
	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>繳款截止日 </td>
			<td bgcolor="#ffffff">
			<input type=text name="billDate" size=10 value="">
            (設定一律請打西元年，印帳單時會轉成民國年)
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 class=es02>
			<td>備註攔:</td>
			<td bgcolor="#ffffff">
				<textarea name="comment" cols=40 rows=2></textarea>
				<br>ex:*逾時費收費日期: 4/9, 4/7
			</td>
		</tr>
		
		<tr class=es02> 
			<td colspan=2 align=center>
				<input type=submit value="修改">
			</td>
		</tr>
		</table>
	
		</td>
		</tR>
		</table>

</form>
</center>