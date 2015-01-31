<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="java.io.*" %>
<%@ include file="jumpTop.jsp"%>
<br>

學生資料上傳 
<blockquote>
<form name="form1" enctype="multipart/form-data" method="post" action="uploadStudent2.jsp">

	<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02> 
		<td>
		上傳檔案:
		</td>		
		<td bgcolor=ffffff> 
	      <input type="file" name="File1" size="20" maxlength="20">
	     </td>
     </tr>
     <tr>
	     <td colspan=2> 
	            <center><input type="submit" value="上傳"></center>   
	     </td>
	</tr>
	</table>
	
	</tD>
	</tr>
	</table>

</form>
</blockquote>