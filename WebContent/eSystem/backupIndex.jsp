<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,java.util.*,java.util.zip.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=9;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu9.jsp"%>
<%

	EsystemMgr em2=EsystemMgr.getInstance();
	Esystem e2=(Esystem)em2.find(1);
	
	String fPath=e2.getEsystemDBfile();
	String mysqlPath=e2.getEsystemMySqlfile().trim();
	String mysqlName=e2.getEsystemMysqlName().trim();
	String mysqlBFName=e2.getEsystemMysqlBinary().trim();
	
	JsfTool jt=JsfTool.getInstance();
	JsfAdmin ja=JsfAdmin.getInstance();
	User[] u2=ja.getLogUsers();
%>
<br>
<blockquote>


<b><<新增備份>></b>
<BR>


<form action="dbBackup.jsp" method="post">

<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>日期</td>
	<td>
	<%=jt.ChangeDateToString(new Date())%>
	</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>註記</td>
	<td><textarea cols=20 rows=3 name="dbPs"></textarea></td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>備份人</td>
	<td>
	
		<%=ud2.getUserFullname()%>
		<input type=hidden name="backupPeople" value="<%=ud2.getId()%>"> 
	</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>遠端路徑</td>
	<td>
	<%=fPath%>
	</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
	<td colspan=2><center><input type=submit value="備份資料庫" onClick="return(confirm('確認備份資料庫?'))"></center></td>
	<tr bgcolor=#ffffff align=left valign=middle>
		

</table>
</td></tr></table>
</form>

</blockquote>



<%@ include file="bottom.jsp"%>
