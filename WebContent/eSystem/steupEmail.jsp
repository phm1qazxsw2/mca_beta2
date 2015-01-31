<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=4;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu7.jsp"%>
<%
	String m=request.getParameter("m");
	
	PaySystemMgr em=PaySystemMgr.getInstance();
	PaySystem e=(PaySystem)em.find(1);
	
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<img src="pic/fix.gif" border=0>Email基本設定</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<br>

<form action="setupEmail2.jsp" method="post">


<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>
    <font color=red>*</font>        
    STMP server</td>
<td width=300>
    <%
        if(ud2.getUserRole()==1)
        {
    %>    
    <input type=text name="paySystemEmailServer" value="<%=(e.getPaySystemEmailServer()==null)?"":e.getPaySystemEmailServer()%>" size=25></td>

    <%
        }else{
    %>
        <%=(e.getPaySystemEmailServer()==null)?"系統尚未設定":"<font color=blue>"+e.getPaySystemEmailServer()%></font>
        <input type=hidden name="paySystemEmailServer" value="<%=e.getPaySystemEmailServer()%>">   
    <%
        }
    %>
    </tD>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
	<td bgcolor=#f0f0f0 class=es02>編碼方式</td>
	<td>
    <%
        if(ud2.getUserRole()==1)
        {
    %>    
        <select name="paySystemEmailCode" size=1>
            <option value="UTF-8" <%=(e.getPaySystemEmailCode()!=null&&e.getPaySystemEmailCode().equals("UTF-8"))?"selected":""%>>UTF-8</option>
            <option value="big5" <%=(e.getPaySystemEmailCode()!=null&&e.getPaySystemEmailCode().equals("big5"))?"selected":""%>>big5</option>
        </select>        
    <%
        }else{
    %>
        <%=(e.getPaySystemEmailCode().length()<=0)?"系統尚未設定":"<font color=blue>"+e.getPaySystemEmailCode()+"</font>"%>

        
    <%
        }
    %>        
    </td>
</tr>

<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>寄件人</td>
<td>
	<input type=text name="paySystemEmailSender" value="<%=(e.getPaySystemEmailSender()==null)?"":e.getPaySystemEmailSender()%>" size=15>
	<br>ex: <%=e.getPaySystemCompanyName()%>
</td>
</tr>
<tr bgcolor=#ffffff align=left valign=middle>
<td bgcolor=#f0f0f0 class=es02>寄件人email</td>
<td>
	<input type=text name="paySystemEmailSenderAddress" value="<%=(e.getPaySystemEmailSenderAddress()==null)?"":e.getPaySystemEmailSenderAddress()%>" size=25>
	<br><div class=es02>說明:客戶回信的email</div>
</td>
</tr>

<tr align=left valign=middle>
<td colspan=2 class=es02><center><input type=submit value="修改" onClick="return (confirm('確認修改?'))"></center></td>
</tr>
 

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

<%@ include file="bottom.jsp"%>