<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%

    EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1); 
	
	String m=request.getParameter("m");
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>資料顯示設定</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 

<blockquote>
<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action="modifySystem2.jsp" method="post">

<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b><center><b>版面設定</b></center></font></td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle class=es02>
	<td bgcolor=#f0f0f0 class=es02 width=150>學生管理資料顯示筆數</td>
		<td><input type=text name=stuPage value="<%=e.getEsystemStupage()%>" size=5></td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle class=es02>
		<td bgcolor=#f0f0f0 class=es02>教師管理資料顯示筆數</td>
		<td><input type=text name=teaPage value="<%=e.getEsystemTeapage()%>" size=5></td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle class=es02>
		<td bgcolor=#f0f0f0 class=es02>日期顯示方式</td>
		<td>
            <input type=radio name="dateType" value="0" <%=(e.getEsystemDateType()==0)?"checked":""%>>以民國為主
            <input type=radio name="dateType" value="1" <%=(e.getEsystemDateType()==1)?"checked":""%>>以西元為主
        </td>
	</tr>
<tr bgcolor=4A7DBD class=es02>
<td colspan=2 align=middle class=es02><font color=ffffff><b>相關設定</b></font></td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle class=es02>
	<td bgcolor=#f0f0f0 class=es02>現金帳戶圓餅圖</td>
		<td class=es02>
			<input type=radio name="esystemShowCash" value="1" <%=(e.getEsystemShowCash()==1)?"checked":""%>>使用中
			<input type=radio name="esystemShowCash" value="0" <%=(e.getEsystemShowCash()==0)?"checked":""%>> 停用
		</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle class=es02>
	<td bgcolor=#f0f0f0 class=es02>系統自動登出時間</td>
		<td class=es02>
            <input type=text name="esystemLogMins" value="<%=e.getEsystemLogMins()%>" size="5">&nbsp;分鐘
		</td>
	</tr>
	<input type=hidden name="incomeLimit" value="1000">
	<input type=hidden name="costLimit" value="1000"> 	
	<input type=hidden name="stuPage" value="10">  
	<input type=hidden name="costLimit" value="1000"> 
	


    <input type=hidden name="mysqlFile" value=""> 
    <input type=hidden name="dbName" value=""> 
    <input type=hidden name="dbBirany" value=""> 
    <input type=hidden name="dbFile" value=""> 

<%
/*
%>
	<tr align=left valign=middle>
	<td colspan=2 class=es02><center>資料庫備份設定</center></td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>
	MySql資料路徑	
	</td>	
	<td>
	<input type=text name="mysqlFile" value="<%=e.getEsystemMySqlfile()%>" size=50><br>ex- <font size=2>C:\Program Files\MySQL\MySQL Server 5.0\data\</font>
	</td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>
	資料庫名稱
	</td>
	<td>
	<input type=text name="dbName" value="<%=e.getEsystemMysqlName()%>" size=20>
	</td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>mysql data原始檔名稱</td>
	<td>
	<input type=text name="dbBirany" value="<%=e.getEsystemMysqlBinary()%>" size=20>
	</td></tr>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>
	遠端資料備份資料夾	
	</td>	
	<td>
	<input type=text name="dbFile" value="<%=e.getEsystemDBfile()%>" size=40>
	</td>
	</tr>
<%
*/
%>

	<tr bgcolor=#ffffff>
	<td colspan=2><center><input type=submit value="修改"></center></td>
	</tr>
</table>
</td></tr></table> 
</form>

</blockquote>
<%
	if(m !=null)
	{
%>
	<script>
		alert('修改完成!');
	</script>		
<%	
	}
%>

<%@ include file="bottom.jsp"%>