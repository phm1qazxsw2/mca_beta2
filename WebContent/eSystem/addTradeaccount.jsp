<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,403))
    {
        response.sendRedirect("authIndex.jsp?code=403");
    }

    JsfAdmin ja=JsfAdmin.getInstance();

    User[] u=ja.getAccountUsers(_ws2.getBunitSpace("userBunitAccounting"));

    if(u==null)
    {
        out.println("尚未設定使用者,無法連接新帳戶至使用者!!<br><br>");
        out.println("請至<a href=\"addUser.jsp\">新增使用者</a>產生");
        return;
    }

%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增零用金帳號</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<center> 
<form action="addTradeaccount2.jsp" method="post">
<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
		<td> 
			帳號名稱			
		</td>
		<td bgcolor=ffffff>
			<input type=text name="tradeName" size=20>
		</td>
  	</tr>
  	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
		<td> 
			排序
		</td>
		<td bgcolor=ffffff>
			<input type=text name="tradeAccountOrder" size=5 value="0">
		</td>
  	</tr>

  	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
  		<td>授權使用人</td>
		<td bgcolor=ffffff>
		 <select name="userId" size=1>
		    <%
		    	for(int i =0;i<u.length ;i++)
		    	{
		    %>	
		    	<option value="<%=u[i].getId()%>"><%=u[i].getUserFullname()%>(<%=u[i].getUserLoginId()%>)</option>
		   <%
		   	}
		   %>
		    </select>	
		</td>
	</tr>		
		<td colspan=2 align=middle>
			<center><input type=submit value="新增"></center>
		</td>
	</tr>
</table>
 
	 </tD>
	  </tr>
	   </table>

</form>
</center>
