<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<script src="js/formcheck.js"></script>
<script>
function check(f)
{
    if (f.name.value.length==0) {
        alert("名稱不可空白");
        f.name.focus();
        return false;
    }
    else if (f.safetyLevel.value.length>0 && !IsNumeric(f.safetyLevel.value)) {
        alert("請輸入正確的安全存量數字");
        f.safetyLevel.focus();
        return false;
    }
    else if (f.salePrice.value.length>0 && !IsNumeric(f.salePrice.value)) {
        alert("售價請輸入正確的數字");
        f.salePrice.focus();
        return false;
    }
    return true;
}
</script>
<%
    PItem pi = PItemMgr.getInstance().find("id=" + request.getParameter("id"));
%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>&nbsp;修改產品</b> 
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<center>
<form action="modify_product2.jsp" method="post" onsubmit="return check(this);">
<input type=hidden name="id" value="<%=pi.getId()%>">

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
    <tr bgcolor=#f0f0f0 class=es02>
		<td nowrap><font color=red>*</font>產品名稱</td>
		<td bgcolor="#ffffff">
			<input type=text name="name" value="<%=phm.util.TextUtil.encodeHtml(pi.getName())%>" size=20>
		</td> 
    </tr>
    <tr bgcolor=#f0f0f0 class=es02>
		<td nowrap>安全庫存量</td>
		<td bgcolor="#ffffff">
			<input type=text name="safetyLevel" value="<%=pi.getSafetyLevel()%>" size=5>
		</td>
 
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>售價</td>
		<td bgcolor="#ffffff">
			<input type=text name="salePrice" size=5 value="<%=pi.getSalePrice()%>"><br>
            收費時自動帶出的單價,參考用,到時可另改。
		</td>
 
    </tr>
    <tr>	
    	<td align=middle colspan=2> 
            <input type=submit value="儲存">
		</td>
	
    </tr>
    </table>
    </td>
</tr>
</table>

</form>
</center>

