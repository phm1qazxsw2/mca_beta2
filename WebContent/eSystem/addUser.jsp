<%@ page import="jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
if(!AuthAdmin.authPage(ud2,2))
{
    response.sendRedirect("authIndex.jsp");
}
%>
<%@ include file="leftMenu8.jsp"%>
<br>
<%
JsfAdmin ja=JsfAdmin.getInstance();		


%>
<script>
function checkValidId(id)
{
    if (id.length==0)
        return false;
    for (var i=0; i<id.length; i++) {
        var c = id.charAt(i);
            
        if(c>='0' && c<='9')
            continue;
        
        if ((c>'z') || (c<'A')) {
            return false;    
        }
    }
    return true;
}

function checkPasswordConfirm(p, c)
{
    if (p.length==0)
        return false;
    if (p!=c)
        return false;
    return true;
}

function doCheck(f)
{
    if (!checkValidId(f.userLoginId.value)) {
        alert("帳號僅可使用英文字母及數字, 不分大小寫");
        f.userLoginId.focus();
        return false;
    }

    if (!checkPasswordConfirm(f.userPassword.value,f.passwordConfirm.value)) {
        alert("密碼確認和密碼不相同或長度為零");
        f.userPassword.focus();
        return false;
    }

    return true;
}
</script> 
&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>新增使用者</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>

<BR>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

<form action="addUser2.jsp" method=post onsubmit="return doCheck(this);">
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>帳號<font color=red>*</font></td>
	<td class=es02>
	<input type="text" name="userLoginId"><br>帳號僅可使用英文字母及數字, 不分大小寫
	</td>
</tr>

<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>密碼<font color=red>*</font></td>
	<td class=es02>
	<input type="password" name="userPassword"><br>密碼可用字母和符號,有區分大小寫
	</td>
</tr>
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>密碼確認<font color=red>*</font></td>
	<td class=es02>
	<input type="password" name="passwordConfirm">
	</td>
</tr>
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>登入身份<font color=red>*</font></td>
	<td class=es02>
        <input type=radio name="userRole" value="2">經營者
        <input type=radio name="userRole" value="3">會計人員
        <input type=radio name="userRole" value="4" checked>部門主管/行政
        <input type=radio name="userRole" value="5">老師
	</td>
</tr>
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>姓名</td>
	<td class=es02>
	<input type="text" name="userFullname">
	</td>
</tr>
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>Email</td>
	<td class=es02>
	<input type="text" name="userEmail" size=20>
	</td>
</tr>
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>手機</td>
	<td class=es02>
	<input type="text" name="userPhone" size=15>
	</td>
</tr>
<% 
    BunitHelper bh = new BunitHelper();
    if (bh.hasBunits()) {
%>
<tr bgcolor=#ffffff>
	<td bgcolor=#f0f0f0 class=es02>單位</td>
	<td class=es02>
    <%
        out.println(bh.getBunitName(_ws.getSessionBunitId()));
    %>
	</td>
</tr>
<%
    }
            BunitMgr bm=BunitMgr.getInstance();
            ArrayList<Bunit> ba=bm.retrieveList("flag=" + Bunit.FLAG_SCH,"");
            
            if(ba ==null || ba.size()<=0){
        %>
                <input type=hidden name="userBunitCard" value="0">

        <%  }else{  

                if(ba.size()==0){
        %>
                    <input type=hidden name="userBunitCard" value="0">
        <%
                }else{ 

                    int bCard=ud2.getUserBunitCard();
        %>
            <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                <td>考勤部門</td>
                <td bgcolor=#ffffff class=es02>
                    <select name="userBunitCard">
                        <option value="0" <%=(bCard==0)?"selected":""%>>跨部門</option>
                        <%
                            for(int j=0;j<ba.size();j++){
                                Bunit b=(Bunit)ba.get(j);
                        %>
                                <option value="<%=b.getId()%>" <%=((b.getId()==bCard)?"selected":"")%>><%=b.getLabel()%></option>
                        <%  }   %>
                    </select>
                </td>
            </tr>
        <%  
                }
            }   
        %>

	
<tr bgcolor=#ffffff>
	<td colspan=2>
	<center>
	<input type=submit value="新增">
	</center>
	</td>
</tr>

</table>
</td></tr></table>
</blockquote>

<%@ include file="bottom.jsp"%>
