<%@ page import="jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<br>
<%
JsfAdmin ja=JsfAdmin.getInstance();		

if(!AuthAdmin.authPage(ud2,2))
{
    response.sendRedirect("authIndex.jsp?page=9&info=1");
}
int uid = Integer.parseInt(request.getParameter("uid"));
User u = (User) phm.ezcounting.ObjectService.find("jsf.User", "id=" + uid);
%>
<script>
function doCheck(f)
{
    if (f.use.checked) {
        if (f.acct!='undefined' && f.acct.value.length==0) {
            alert("請輸入一零用金帳戶的名稱");
            f.acct.focus();
            return false;
        }
    }
    return true;
}
</script>
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>設定<%=u.getUserFullname()%>(<%=u.getUserLoginId()%>) 帳戶資料</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>



<blockquote>
<div class=es02><b>零用金帳戶設定:</b></div>
<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<form name="f1" action="addUser4.jsp" method=post onsubmit="return doCheck(this);">
<input type=hidden name="uid" value="<%=uid%>">
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>是否管理零用金</td>
	<td class=es02 width=250>
	  <input type="checkbox" name="use" value="y" checked>是
	</td>
</tr>

<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02 height=30>請輸入零用金帳號名稱</td>
	<td class=es02>
	  <div id="acct"><input type='text' name='acct' size=20></div>
	</td>
</tr>
</table>
</td></tr></table>
<br>

<%
    SalaryAdmin sa=SalaryAdmin.getInstance();
    BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId"));

    if(ba !=null){
%>

<div class=es02><b>銀行帳戶的權限設定:</b></div>
<table width="50%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<%

    for (int i=0; ba!=null && i<ba.length; i++) {%>

<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02 nowrap><%=ba[i].getBankAccountName()%></td>
	<td class=es02 width=250>
        <input type="checkbox" name="bankid" value="<%=ba[i].getId()%>">是, 權限使用
	</td>
</tr>
<%
        }
%>
        </table>
        </td>
        </tr>
        </table>
<%
    }
%>
<blockquote>
<div align=middle>
<input type="submit" value="確認設定">
</div>
</blockquote>
</form>
<%@ include file="bottom.jsp"%>
