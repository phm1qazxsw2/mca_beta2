<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpFinance.jsp"%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<script type="text/javascript" src="openWindow.js"></script>

<%

int pageXX=1;

String pageS=request.getParameter("page");

if(pageS !=null)
	 pageXX=Integer.parseInt(pageS);

%>
<script>
	
	function changepage(page) 
	{ 
		
		if(page==1)
			defFRM_Main.location.href="showFtype1.jsp?year=<%=syear%>&month=<%=smonth%>";
		else if(page==2)
			defFRM_Main.location.href="showFtype2.jsp?year=<%=syear%>&month=<%=smonth%>";
		else if(page==3)
			defFRM_Main.location.href="showFtype2Detail.jsp?year=<%=syear%>&month=<%=smonth%>";
		else if(page==4)
			defFRM_Main.location.href="showFtype3.jsp?year=<%=syear%>&month=<%=smonth%>";
		else if(page==5)
			defFRM_Main.location.href="showFtype4.jsp";
		else if(page==7)
			defFRM_Main.location.href="showFtype5.jsp";
		else if(page==6)
			defFRM_Main.location.href="showFtype6.jsp?month=<%=syear%>/<%=smonth%>";
		else if(page==8)
			defFRM_Main.location.href="showFtype8.jsp?rundate=<%=syear%>/<%=smonth%>"; 
		else if(page==9)
			defFRM_Main.location.href="showFtype9.jsp?year=<%=syear%>&month=<%=smonth%>";
 	

	} 
</script>

<table border=0 width=100% height=100%>
<tr>
	<tD width=131 class=es02 valign=top>

<table bgcolor=#8CAAED width="131" border="0" cellpadding="0" cellspacing="0">

<tr align=left valign=middle>
<td bgcolor=#696a6e width="131" background=pic/left01.gif class=es02r>
<img src=pic/arrow02.gif border=0 align=absmiddle>
<font color=white>財務報表</font></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(1)"  class=an01>損益表</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(9)"  class=an01>股東權益變更表</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(2)" class=an01>資產負債表</a></td>
</tr>



<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(3)"  class=an01>資產負債表(含明細)</a></td>
</tr>


<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(4)"  class=an01>現金調節</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(5)"  class=an01>現金帳戶分佈</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(6)"  class=an01>日記帳</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(7)"  class=an01>學費累計明細</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>

<tr align=left valign=middle>
<td width="131" class=es02r>
<img src=pic/arrow01.gif border=0 align=absmiddle>
<a href="#" onclick="javascript:changepage(8)"  class=an01>輸出電子報表</a></td>
</tr>

<tr align=left valign=top><td colspan=3><table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h02.gif><img src="pic/h02.gif" height=1 border=0 alt=""></td></tr></table></td></tr>


<tr align=left valign=middle>
<td bgcolor=#919193 width="131" height="18" background=pic/left02.gif><img src=pic/dot01.gif border=0 align=absmiddle></td>
</tr>

</table> 
<img src="pic/confidential.gif" border=0 width=131>
<br> 
<center>
本頁為極機密資訊
</centeR>	
	</td>
	<tD valign=top width=100%>

	<iframe id="defFRM_Main" src="showFtype1.jsp?year=<%=syear%>&month=<%=smonth%>" width="100%" height="100%" frameborder="0">
	
	</iframe>

	</tD>
</tr>
</table>	

