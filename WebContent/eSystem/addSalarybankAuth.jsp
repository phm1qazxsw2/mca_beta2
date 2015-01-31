<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,403))
    {
        response.sendRedirect("authIndex.jsp?code=403");   
    }
%>
<%@ include file="leftMenu2-new.jsp"%>
<%


    int baId=Integer.parseInt(request.getParameter("baId"));	
    java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
    JsfAdmin ja=JsfAdmin.getInstance();
    User[] u2=ja.getAccountUsers(_ws.getBunitSpace("userBunitAccounting"));
    BankAccountMgr sbm=BankAccountMgr.getInstance();
    BankAccount sb=(BankAccount)sbm.findX(baId, _ws.getBunitSpace("bunitId"));

    if (sb==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

%> 
  <br>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;<%=sb.getBankAccountName()%> 使用權限列表</b>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<blockquote>



<form action="addSalarybankAuth2.jsp" method="post">
  	<div class=es02>
    <img src="pic/add.gif" border=0 width=12>&nbsp;新增使用權限:
    </div>&nbsp;
    &nbsp;&nbsp;&nbsp;<select size=1 name="userId">
		<%
			for(int i=0;i<u2.length;i++)
			{
		%>
				<option value="<%=u2[i].getId()%>"><%=u2[i].getUserLoginId()%>
                    <%=u2[i].getUserFullname().length()>0?"("+u2[i].getUserFullname()+")":""%>
                </option>
		<%
			}
		%>	
	</select>
	<input type=hidden name="baId" value="<%=baId%>">
	<input type=submit value="新增" onClick="return(confirm('確認新增此使用者的權限?'))">
</form>
</blockquote>

<br>
<%
JsfPay jp=JsfPay.getInstance();
SalarybankAuth[] sa=jp.getSalarybankAuthByBankId(sb);
%> 
<blockquote>
<%
if(sa==null)
{ 	
%>
    <br>
    <blockquote>
        <div class=es02>        
            尚未設定任何授權.
        </div>
    </blockquote>
<%@ include file="bottom.jsp"%>

<%
	return;
}
%>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
	  	<td>使用者名稱</td><td>狀態</td><td>授權人</td><td>授權日期</tD><td></td>
	 </tr>
	 <%
     UserMgr um=UserMgr.getInstance();
	 for(int i=0;i<sa.length;i++)
	 {
	 	 User ux=(User)um.find(sa[i].getSalarybankAuthUserID ());
  	     User ux2=(User)um.find(sa[i].getSalarybankLoginId());		
 	   %>
      	<tr class=es02 bgcolor=#ffffff align=left valign=middle>
		  	<td><img src="pic/user.gif" border=0><%=ux.getUserLoginId()%> <%=ux.getUserFullname().length()>0?"("+ux.getUserFullname()+")":""%></td>
		  	<td>使用中</td>
		  	<td><%=ux2.getUserLoginId()%>  <%=ux2.getUserFullname().length()>0?"("+ux2.getUserFullname()+")":""%></td>
		  	<td><%=df.format(sa[i].getCreated())%></tD>
		  	<td><a href="deleteSalarybankAuth.jsp?baAuth=<%=sa[i].getId()%>&baId=<%=baId%>" onClick="return(confirm('確認刪除此使用者的權限?'))">刪除</a></td>
	 	</tr>
     <%
      }
      %>
     </table>   
 
	</td>
	</tr>
	</table>
</blockquote>	  	

<%@ include file="bottom.jsp"%>