<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
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

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/addbag.png" border=0>&nbsp;新增學用品</b> 
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>


<center>
<form action="add_product2.jsp" method="post" onsubmit="return check(this);">

<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
    <table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td><font color=red>*</font>學用品名稱</td>
		<td bgcolor="#ffffff">
			<input type=text name="name" size=20>
		</td> 
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>安全庫存量</td>
		<td bgcolor="#ffffff">
			<input type=text name="safetyLevel" size=5 value=0><br>
            如設為0將<font color=blue>取消庫存不足</font>的預警機制.
		</td>
 
    </tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>售價</td>
		<td bgcolor="#ffffff">
			<input type=text name="salePrice" size=5 value=0><br>
            收費時自動帶出的單價,參考用,到時可另改。
		</td>
 
    </tr>
    <tr>	
    	<td align=middle colspan=2> 
			<input type=hidden name="p" value="1">
			
            <input type=submit value="新增">
		</td>
	
    </tr>
    </table>
    </td>
</tr>
</table>
</form>
</center>

