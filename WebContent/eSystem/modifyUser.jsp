<%@ page import="jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
    if(!AuthAdmin.authPage(ud2,2))
    {
        response.sendRedirect("authIndex.jsp?page=9&info=1");
    }

    JsfAdmin ja=JsfAdmin.getInstance();		
    int userId=Integer.parseInt(request.getParameter("userId"));
    UserMgr um=UserMgr.getInstance();
    User u2 = (User) um.findX(userId, _ws.getBunitSpace("userBunitAccounting"));
    if (u2==null) {
        %><script>alert("找不到資料");history.go(-1);</script><%
        return;
    }
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
<br>
&nbsp;&nbsp;&nbsp;<img src="pic/user.gif" border=0> <b>修改使用者資訊</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
	<br>
	<blockquote>	

<form action="modifyUser2.jsp" method=post onsubmit="return doCheck(this);">
		
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1 class=es02>
        <tr bgcolor=4A7DBD class=es02>
			<td colspan=2 align=middle> 
                <font color=white><b>基本資料設定</b></font>
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>帳號 </td>
			<td bgcolor=#ffffff class=es02>
			<input type="text" name="userLoginId" value="<%=u2.getUserLoginId()%>"><br>
            帳號僅可使用英文字母及數字, 不分大小寫
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>密碼</td>
			<td bgcolor=#ffffff class=es02>
			<input type="password" name="userPassword" value="--password--"><br>密碼可用字母和符號,有區分大小寫
			</td>
		</tr> 
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>密碼確認</td>
			<td bgcolor=#ffffff class=es02>
			<input type="password" name="passwordConfirm" value="--password--"><br>密碼可用字母和符號,有區分大小寫
			</td>
		</tr>


		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>姓名</td>
			<td bgcolor=#ffffff class=es02>
			<input type="text" name="userFullname" value="<%=u2.getUserFullname()%>" size=15>
			</td>
		</tr>  
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>Email</td>
			<td bgcolor=#ffffff class=es02>
			<input type="text" name="userEmail" value="<%=u2.getUserEmail()%>" size=30>
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>電話 </td>
			<td bgcolor=#ffffff class=es02>
			<input type="text" name="userPhone" value="<%=u2.getUserPhone()%>">
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>協同作業-確認更新</td>
			<td bgcolor=#ffffff class=es02>
                <input type=radio name="userConfirmUpdate" value="1" <%=(u2.getUserConfirmUpdate()==1)?"checked":""%>>開啟
                <input type=radio name="userConfirmUpdate" value="0" <%=(u2.getUserConfirmUpdate()==0)?"checked":""%>>關閉
			</td>
		</tr>
        <tr bgcolor=4A7DBD class=es02>
			<td colspan=2 align=middle>
                <font color=white><b>
					使用權限設定</b></font>
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>使用狀態</td>
			<td bgcolor=#ffffff class=es02>
				<input type=radio name="userActive" value="1" <%=(u2.getUserActive()==1)?"checked":""%>>使用中
				<input type=radio name="userActive" value="0" <%=(u2.getUserActive()==0)?"checked":""%>>停用
			</td>
		</tr>

		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>登入身份</td>
			<td bgcolor=#ffffff class=es02>
				<input type=radio name="userRole" value="2" <%=(u2.getUserRole()==2)?"checked":""%>>經營者
				<input type=radio name="userRole" value="3" <%=(u2.getUserRole()==3)?"checked":""%>>會計人員
				<input type=radio name="userRole" value="4" <%=(u2.getUserRole()==4)?"checked":""%>>部門主管/行政
				<input type=radio name="userRole" value="5" <%=(u2.getUserRole()==5)?"checked":""%>>其他
			</td>
		</tr>
        <% 
            BunitHelper bh = new BunitHelper();
            if (bh.hasBunits()) {
        %>
        <tr bgcolor=#ffffff>
            <td bgcolor=#f0f0f0 class=es02>單 位</td>
            <td class=es02>
            <%
                out.println(bh.getBunitName(u2.getUserBunitAccounting()));
            %>
            </td>
        </tr>
        <%
            }

            BunitMgr bm=BunitMgr.getInstance();
            ArrayList<Bunit> ba = bm.retrieveList("flag=" + Bunit.FLAG_SCH,"");            
            
            if(ba ==null || ba.size()<=0){
        %>
                <input type=hidden name="userBunitCard" value="0">

        <%  }else{  

                if(ba.size()==0){
        %>
                    <input type=hidden name="userBunitCard" value="0">
        <%
                }else{ 

                    int bCard=u2.getUserBunitCard();
        %>
            <tr bgcolor=#f0f0f0 align=left valign=middle>
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


<!--
        <tr bgcolor=4A7DBD class=es02>
			<td colspan=2 align=middle>
                <font color=white><b>
					Email 報表設定</b></font>
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>email報表狀態</td>
			<td bgcolor=#ffffff class=es02>
				<input type=radio name="userEmailReport" value="1" <%=(u2.getUserEmailReport()==1)?"checked":""%>>使用中 
				<input type=radio name="userEmailReport" value="0" <%=(u2.getUserEmailReport()==0)?"checked":""%>>停用 
			</td>
		</tr>
		<tr bgcolor=#f0f0f0 align=left valign=middle>
			<td>email報表內容</td>
			<td bgcolor=#ffffff class=es02>
				<input type=checkbox name="emailContent" value="1" <%=(u2.getUserContentType1()==1)?"checked":""%>>損益試算 
				<input type=checkbox name="emailContent" value="2" <%=(u2.getUserContentType2()==1)?"checked":""%>>現金帳戶
				<input type=checkbox name="emailContent" value="3" <%=(u2.getUserContentType3()==1)?"checked":""%>>個人零用金帳戶 
				<input type=checkbox name="emailContent" value="4" <%=(u2.getUserContentType4()==1)?"checked":""%>>學費更動明細 <br>
				<input type=checkbox name="emailContent" value="5" <%=(u2.getUserContentType5()==1)?"checked":""%>>學生入學更動
				<input type=checkbox name="emailContent" value="6" <%=(u2.getUserContentType6()==1)?"checked":""%>>才藝班名單更動 
				<input type=checkbox name="emailContent" value="7" <%=(u2.getUserContentType7()==1)?"checked":""%>>薪資支出更動 <br>
				<input type=checkbox name="emailContent" value="8" <%=(u2.getUserContentType8()==1)?"checked":""%>>雜費收入更動 				
				<input type=checkbox name="emailContent" value="9" <%=(u2.getUserContentType9()==1)?"checked":""%>>雜費支出更動
				<input type=checkbox name="emailContent" value="10" <%=(u2.getUserContentType10()==1)?"checked":""%>>內部轉帳更動
				<input type=checkbox name="emailContent" value="11" <%=(u2.getUserContentType11()==1)?"checked":""%>>交易更動總表
				
			</td>
		</tr>
-->


		<tr bgcolor=#ffffff align=left valign=middle>
			<td colspan=2 class=es02> 
				<center>
					<input type="hidden" name="userId" value=<%=userId%>>
					<input type=submit value="修改">
				</center>
			</td>
		</tr>
		</table>
		</td>
		</tR>
		</table>
	</blockquote>

<%@ include file="bottom.jsp"%>