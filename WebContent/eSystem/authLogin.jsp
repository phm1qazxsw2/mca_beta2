<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%@ include file="jumpTopNotLogin.jsp"%>

<blockquote>
<form action="authLogin2.jsp" method="post">
<b><<<必亨得意算財務系統-授權中心>>></b>
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>  
	
		<tr bgcolor=#ffffff align=left valign=middle>
 		<td bgcolor=#f0f0f0 class=es02>授權形式</td> <td class=es02> 
		<input name="codeType" value="1" type="radio" checked>Type 1
		<input name="codeType" value="2" type="radio">Type 2
		<input name="codeType" value="3" type="radio">Type 3
	</td>

	</tr>
 
	<tr bgcolor=#ffffff align=left valign=middle> 
	<td bgcolor=#f0f0f0 class=es02>授權碼</td> 
	<td class=es02> 
		<input type="text" name="code" size="40"> 
		
	<br> <font color=red>*</font>必須區分大小寫.	
		</td>
	</tr>



	<tr bgcolor=#ffffff align=left valign=middle> 
	<td bgcolor=#f0f0f0 class=es02><b>注意事項</b></td> 
	<td class=es02> 
			<font color=red>
			新的授權碼將覆蓋舊的授權碼,請依照必亨商業軟體股份有限公司的授權內容,
			將資料填入,以免造成系統無法運作.
			</font>
		</td>
	</tr>
	
	
	<tr bgcolor=#ffffff align=left valign=middle><td colspan="4"><center>
		<input type=submit onClick="return(confirm('確認新增此授權?'))" value="新增授權">
	</center></td>
	</tr>
	</table>
</td></tr></table>	
	</form>
	