<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    if(!checkAuth(ud2,authHa,403))
    {
        response.sendRedirect("authIndex.jsp?code=403");
    }
%>
<br>
<div class=es02>
<b>&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;新增銀行帳戶</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<br>
<center>
    <table width="" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
    <form action=addBankAccount2.jsp method=post>


    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>內部作業帳戶名稱</td>
        <td><input type=text size=10 name=accountName></td>
    </tr>
    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>銀行資訊</td>
        <td class=es02>
        銀行名稱:<input type=text size=10 name="bankAccountRealName">
        銀行代號:<input type=text size=5 name="accountId"><br>
        分行:<input type=text size=5 name="bankAccountBranchName">
        </td>
    </tr>


    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>帳號</td>
        <td><input type=text size=20 name=accountNumber></td>
    </tr>
    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>戶名</td>
        <td><input type=text size=15 name=accountNumberName></td>
    </tr>
     
    <input type=hidden name="bankAccountATMActive" value="0">

    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>薪轉企業代碼</td>
        <td><input type=text size=6 name=bankAccount2client> 4碼</td>
    </tr>
    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>薪轉每月匯款日期</td>
        <td><input type=text size=4 name=bankAccountPayDate></td>
    </tr>



    <tr bgcolor=#ffffff align=left valign=middle>
        <td bgcolor=#f0f0f0 class=es02>備註</td>
        <td><textarea rows=5 cols=20 name=ps></textarea></td>
    </tr>

    <tr bgcolor=#ffffff align=left valign=middle><td colspan=2><center><input type=submit value="新增"></center></td></tr>
    </table>
    </td></tr></table>
</form>
</center>