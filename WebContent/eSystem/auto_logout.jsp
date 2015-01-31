<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu8.jsp"%>

<script>

    var secX=60;

    var nTimer=setInterval("chgTimer()",1000);

    function chgTimer(){
        
        secX--;

        if(secX <0)
            secX=0;

        document.getElementById("mins").innerHTML=secX;
        if(secX<=0)
        {
            window.location="logoutRedirect.jsp";
        }
        
    }
</script>
<%
    EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
%>

<br>

&nbsp;&nbsp;&nbsp;<b>系統自動登出頁</b>

<br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<div class=es02>
    <blockquote>
        <table border=0>
            <tr>
                <td colspan=3 class=es02 width=300>    
                    由於你在上一頁停留的時間超過系統所設定的<b><%=e.getEsystemLogMins()%></b>分鐘,
                </td>
            </tr>
            <Tr class=es02>
                <td>系統將於</td>
                <td class=es02 width=5 id=mins>
                </td>
                <td class=es02>
                秒後自動為你登出.....  (<A href="modifySystem.jsp"><img src="pic/fix.gif" border=0 width=10>設定</a>)
                </td>
            </tr>
        </table>
        <br>
        <br>
        或 <input type=button value="繼續使用" onClick="history.go(-1)">
    </blockquote>

</div>





</td>
</tr>
</table>

<!--- start 水平列書籤式按鈕 02 --->
<table bgcolor=#5a4343 width="100%" height="24" border="0" cellpadding="0" cellspacing="0">
<tr align=center valign=middle>
<td><img src=pic/dot01.gif width=80 height=24 border=0></td>
<td width="100%">
	<center>
		<table>
			<tr>
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle><a href="" class=an03>標準流程</a></td>
				
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle><a href="" class=an03>使用手冊</a></td>
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle><a href="" class=an03>技術支援</a></td>
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle>
				<a href="authInfo.jsp" class=an03>版本資訊</a></td>
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle><a href="" class=an03>常見問題集</a></td>
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
			</tr>
		</table>
	</center>
</td>
<td width="100%"><img src=pic/dot01.gif width=80 height=24 border=0></td>
</tr>
</table>
<!--- end 水平列書籤式按鈕 02 --->

<!--- start 版權聲明 01 --->
<table bgcolor=#ffffff width="100%" height="24" border="0" cellpadding="8" cellspacing="0">
<tr align=right valign=middle>
<td width=300></td>
<td class=es02 nowrap align=right>
<img src="img/bottom.png" border=0>

</td>
<td align=left class=es02>
Copyright © 2008 必亨商業軟體股份有限公司 All rights reserved.
</td>
</tr>
</table>

</body>
</html>
