<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    String o=request.getParameter("o");    
    String t=request.getParameter("t");
%>
<div class=es02>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><img src="images/excel2.gif" border=0>&nbsp;匯出Excel報表</b>
</a>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02 valign=top>
        <td align=middle width=20%>類型</tD><td width=60% align=middle>說明</td><td width=20% align=middle></td>
    </tr>
    
	<tr bgcolor=#ffffff class=es02 valign=middle>
        <td><b>樣式一</b></tD><td>
            帳單:依帳單條列   <br>
            收款:顯示收款狀態 <br>

        </tD><td align=middle><a href="export_bill.jsp?o=<%=o%>&t=<%=t%>&type=0">產生excel</a></td>
    </tr>
	<tr bgcolor=#ffffff class=es02 valign=middle>
        <td><b>樣式二</b></tD><td>
            帳單:依會計科目分類<br>
            收款:顯示收款狀態

        </tD><td align=middle><a href="export_bill.jsp?o=<%=o%>&t=<%=t%>&type=1">產生excel</a></td>
    </tr>
	<tr bgcolor=#ffffff class=es02 valign=middle>
        <td><b>樣式三</b></tD><td>
            帳單:依收費項目分類<br> 
            收款:依收款方式分類 <br><br>
            <font color=blue>*</font>推薦使用的樣式
        </tD><td align=middle><a href="export_bill.jsp?o=<%=o%>&t=<%=t%>&type=2">產生excel</a></td>
    </tr>
</TABLE>
</td>
</tr>
</table>
</center>