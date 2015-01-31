<%@ page language="java"  import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=14;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu14.jsp"%>	
<%
    JsfAdmin ja=JsfAdmin.getInstance();
    MessageType[] pla=ja.getAllMessageType(_ws.getBunitSpace("bunitId"));
%>

<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增訊息類別</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
    <blockquote>
        <div class=es02>
            <form action="addMessageType.jsp" method="post">
                訊息類別名稱:<input type="text" name="placeName" size=20>
                <input type=submit value="新增">
            </form> 
        </div>
    </blockquote>
              
<br>
<br>              
<%
	if(pla==null)
	{
		out.println("<br><blockquote>目前尚未登入資料!</blockquote><br>");
%>
		<%@ include file="bottom.jsp"%>	
<%		
		return;
	}
%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>&nbsp;訊息類別列表</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>
	<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
		<td>類別名稱</td><td>狀態</td><td></td>
	</tr>	
<%
	for(int i=0;i<pla.length;i++)
	{

%> 
<form action="modifyMessageType2.jsp" method="post">
	<tr bgcolor=ffffff class=es02>
	<td>
		<input type=text name="placeName" size=20 value="<%=pla[i].getMessageTypeName()%>">
	</td>
	<td>
		<input type=radio name="placeActive" value=1 <%=(pla[i].getMessageTypeStatus()==1)?"checked":""%>>使用中
		<input type=radio name="placeActive" value=0 <%=(pla[i].getMessageTypeStatus()==0)?"checked":""%>>停用
	</td>
	<td>
		<input type=hidden name="palceId" value="<%=pla[i].getId()%>">
		<input type=submit onClick="retrun(confirm('確認修改?'))" value="修改">
	</td>
	</tr>	
		</form>
<%
	}
%>
	</table>
	</td></tr></table>

</blockquote>
<!--- end 表單01 --->



<!--- end 主內容 --->


<%@ include file="bottom.jsp"%>		