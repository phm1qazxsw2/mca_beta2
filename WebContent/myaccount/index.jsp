<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="../eSystem/style.css" type="text/css">

<table height=600 width=100% align=middle valign=middle>
<tr>
    <td width=100%>
        <center>
        <form action="bill_detail.jsp" method="post">
            <table cellpadding=0 cellspacing=0 border=0>
                <tr>    
                   <td>學童身份證:</td><td><input type=text name="idNumber" size="10"></td><td></td>
                </tr>
                <tr>
                   <td>生日:</td><td><input type=text name="phoneNumber" size="10"></td><td>ex: 721020</td>
                </tr>
                <tr>
                   <td colspan=3><input type="checkbox" name="setcookie"> 記住我的帳號</td>
                </tr>
                <tr>
                   <td colspan=3><center><input type=submit value="登入"></center></td>
                </tr>
            </table>
        </form>
        </center>
    </td>
</tr>
</table>
<br>
<br>

<br>

<%@ include file="bottom.jsp"%>
