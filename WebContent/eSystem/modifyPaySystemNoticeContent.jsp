<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
	String m=request.getParameter("m");
    int frompage=0;

    String pageX=request.getParameter("pagex");
    
    try{
        frompage=Integer.parseInt(pageX);
    }catch(Exception ex){}

	
    PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);
%>

<br>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/email.png" border=0>&nbsp;Email 帳單設定</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form action="modifyPaySystemNotice2.jsp" method="post">


<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>Email發送對象</td>
<td class=es02>
	<input type=radio name="paySystemNoticeEmailTo" value="0" <%=(e.getPaySystemNoticeEmailTo()==0)?"checked":""%>>預設聯絡人
	<input type=radio name="paySystemNoticeEmailTo" value="1" <%=(e.getPaySystemNoticeEmailTo()==1)?"checked":""%>><%=(e.getCustomerType()==0)?"父母皆發送":"負責人及聯絡人"%>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>Email形式</td>
	<td  class=es02>
		<input type=radio name="paySystemNoticeEmailType" value="0" <%=(e.getPaySystemNoticeEmailType()==0)?"checked":""%>>純文字
		<input type=radio name="paySystemNoticeEmailType" value="1" <%=(e.getPaySystemNoticeEmailType()==1)?"checked":""%>>HTML格式
	</td>
</tr>
 
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>Email預設標題</td>
<td class=es02>
	<input type=text name="paySystemNoticeEmailTitle" size=50 value="<%=(e.getPaySystemNoticeEmailTitle()!=null)?e.getPaySystemNoticeEmailTitle():""%>">
	<br>
</td>
</tr>
 


<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>Email預設內容</td>
<td class=es02>
	<textarea name="paySystemNoticeEmailText" cols=60 rows=15><%=(e.getPaySystemNoticeEmailText()!=null)?e.getPaySystemNoticeEmailText():""%></textarea>
		<br><br>
		說明:<br>
		1 代號規則:  以 <font color=blue>XXX</font> 表示<%=(e.getCustomerType()==0)?"學生姓名":"客戶名稱"%>   <font color=blue>YYY</font> 表示帳單編號<br>
		2 Email標題及內容皆適用
		
		</td>
</tr>
 


<tr bgcolor=#ffffff align=left valign=middle>
<td colspan=2 class=es02><center><input type=submit value="修改"></center></td>
</tr>
    <input type="hidden" name="paySystemNoticeMessageTo" value="<%=e.getPaySystemNoticeMessageTo()%>">
    <input type="hidden" name="paySystemNoticeMessageTest" value="<%=e.getPaySystemNoticeMessageTest()%>">
    <input type="hidden" name="frompage" value="<%=frompage%>">
</form>
</table>

</td></tr></table>
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