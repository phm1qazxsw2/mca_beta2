<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<script>
//##v2
var user_change_name = false;
var autoName;
function makeName()
{
    if (user_change_name==true)
        return;
    var f = document.f1;
    f.t.value = f.n.value + "繳費單";
    autoName = f.t.value;
}


function checkUserChangeName()
{
    var f = document.f1;
    if (f.t.value!=autoName)
        user_change_name = true;
}

function doCheck(f)
{
    if (f.n.value.length==0) {
        alert("帳單類型代號不可空白");
        f.n.focus();
        return false;
    }
    if (f.t.value.length==0) {
        alert("單據名稱不可空白");
        f.t.focus();
        return false;
    }
    if (!f.w[0].checked && !f.w[1].checked) {
        alert("請選擇一種銷帳方式");
        return false;
    }

    if (!designated_ok && f.w[1].checked) {
        alert("銀行轉帳的設定現在不能使用獨立銷帳的帳單");
        return false;
    }

    if (confirm("確定新增: " + f.n.value))
        return true;
    return false;
}
<%PaySystem pSystem = (PaySystem) ObjectService.find("jsf.PaySystem", "id=1");%>
var designated_ok = <%=((pSystem.getPaySystemATMActive()==1) || (pSystem.getPaySystemATMActive()==0))?"true":"false"%>;
</script>
<body>

<div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="pic/add.gif" border=0>&nbsp;<font color=blue>設定新的帳單類型</font></div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<br>


<table width="100%" border=0 cellpadding=0 cellspacing=0>
	<tr bgcolor=#ffffff align=left valign=middle> 
        <td valign=top width=30 align=middle>
        </td>            
        <td valign=top width=120 align=middle>
            <img src="pic/bill7.gif" border=0>
        </td>
        <td>

            <form name="f1" action="addBill2.jsp" method="post" onsubmit="return doCheck(this);">            
            <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td bgcolor=f0f0f0>
                    內部作業帳單名稱 
                    </td>
                    <td>
                        <input type=text name="n" size=15 onblur="makeName();">
                        <BR>
                        *此名稱<b>不會</b>出現在帳單上*
                    </td>
                </tr>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td bgcolor=f0f0f0>
                      實際帳單抬頭  
                    </td>
                    <td>
                        <input type=text name="t" size=20 onblur="checkUserChangeName();">
                        <br>
                        *此名稱和開單月份<font color=red>會印成帳單標題</font>
                    </td>
                </tr>
                <tr bgcolor=#ffffff align=left valign=middle class=es02>
                    <td bgcolor=f0f0f0>
                        逾期未繳金額是否倂入新帳單
                    </td>
                    <td>
                        <input type=radio name="w" value="1" checked> 是 &nbsp;<br> 
                        <input type=radio name="w" value="0"> 否
                    </td>
                </tr>
                <tr>
                    <td colspan=2 bgcolor=ffffff class=es02>
                        <center>     
                        <input type=submit value="新增"> &nbsp; <input type=button value="回上一頁" onclick="history.go(-1)"> 
                        </center>
                    </td>
                </tr>
                </table>
                </td>
                </tr>
                </table>
                </form>

        </td>
    </tr>
</table>
</body>
