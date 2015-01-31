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

Dbbackup[] dbb=ja.getAllDbbackup();

if(dbb==null)
{ 
		out.println("<br><blockquote>沒有資料!</blockquote><br>");
 
%>
		<%@ include file="bottom.jsp"%>
<%		

	return;
}
else
{
%>
<br>

<b>&nbsp;&nbsp;&nbsp;備份紀錄</b> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<BR>

<blockquote>
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

<tr bgcolor=#f0f0f0 class=es02>
	<td class=es02>備份日期</td>
	<td class=es02>註記</td>
	<td class=es02>備份人</td>
	<td class=es02>路徑</td>
	<td class=es02></td>
	<td class=es02></td>
</tr>

<%
	for(int i=0;i<dbb.length;i++)
	{
%>
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=jt.ChangeDateToString(dbb[i].getCreated())%></td>
		<td class=es02><%=dbb[i].getDbbackupPs()%></td>
		<td class=es02> 
		
		 <%
		 	UserMgr umx=UserMgr.getInstance();
			int il= dbb[i].getDbbackupUserId();
			User ux=(User)umx.find(il);
			out.println(ux.getUserFullname());
		%>	
		</td>
	
		<td  class=es02> 
		<%=dbb[i].getDbbackupFilePath()%>\<%=dbb[i].getDbbackupFileName()%>
		</td>
		<td  class=es02>
		<a href="<%=dbb[i].getDbbackupFilePath()%>\<%=dbb[i].getDbbackupFileName()%>">下載</a>
		</td>
		<td  class=es02> 
		<a href="deleteDbbackup.jsp?backId=<%=dbb[i].getId()%>"  onClick="return(confirm('確認要刪除此備份資料庫?'))">刪除</a>
		</td>
	</tr>
	<%
	}
	%>	
	
</table>
</td></tr></table>
</blockquote>
<%
}
%>
<%@ include file="bottom.jsp"%>
