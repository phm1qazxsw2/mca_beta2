<%@ page language="java" contentType="text/html;charset=UTF-8"%>
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


            <% if(ud2.getUserRole()<=2){ %>

				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>
				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle><a href="steupIndex.jsp" class=an03>系統設定</a></td>

            <%  }   %>
				<td><img src=pic/vline01.gif vspace=0 hspace=8 border=0></td>				

				<td class=es02 nowrap><img src=pic/arrow01.gif border=0 align=absmiddle><a href="" class=an03>使用手冊</a></td>
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
Copyright © 2009 必亨商業軟體股份有限公司  All rights reserved.
</td>
</tr>
</table>
<!--- end 版權聲明 01 --->
<script>
    <%
    EsystemMgr emXXX=EsystemMgr.getInstance();
	Esystem eXX=(Esystem)emXXX.find(1);

    int xgoRun=5;

    if(eXX.getEsystemLogMins()>0)
            xgoRun=eXX.getEsystemLogMins();
    %>

    var mins=<%=xgoRun%>;

    var xt=setTimeout("autoLogout()", 1000*60*mins);
    function autoLogout(){
            
            window.location="auto_logout.jsp";
    }
</script>
</body>
</html>