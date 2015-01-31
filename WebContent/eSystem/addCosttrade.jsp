<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="jumpTop.jsp"%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0 width=15>&nbsp;新增交易廠商</b> 
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>


<blockquote>
<form action="addTradeName2.jsp" method="post">
<table> 

    <tr>
		<td>廠商名稱</td>
		<td>
			<input type=text name="tradeName" size=20>
		</td> 
    </tr>
    <tr>	
    	<td align=middle colspan=2> 
			<input type=hidden name="p" value="1">
			
            <input type=submit value="新增">
		</td>
	
    </tr>
	
</table>

</form>
</blockquote>

