<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    int billId = Integer.parseInt(request.getParameter("billId"));
    EzCountingService ezsvc = EzCountingService.getInstance();	
    Bill b = BillMgr.getInstance().find("id="+billId);
%>
<script>
function doSubmit(f)
{
    if (f.name.value.length==0) {
        alert("薪資名稱不可空白");
        f.name.focus();
        return false;
    }
    if (trim(f.acctcode.value).length==0) {
        alert("請選擇一列帳科目");
        f.acctcode.focus();
        return false;
    }
    if (f.salarytype.options[f.salarytype.selectedIndex].value<=0) {
        alert('種類尚未指定');
        f.salarytype.focus();
        return false;
    }
    if (confirm("確定產生？"))
        return true;
    return false;
}

</script>
<body onload="doinit()">

<table border=0 width=100%>
<tr>
    <td align=middle valign=top width=150 class=es02>
                <img src="pic/sbill3.gif" border=0>
    </td>
    <td>
      <table width="350" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
<form name="f1" action="salarybillitem_add2.jsp" method="post" onsubmit="return doSubmit(this);">
<input type=hidden name="billId" value="<%=billId%>">
<input type=hidden name="backurl" value="<%=request.getParameter("backurl")%>">        
            薪資項目:
                </td>
                <td>
                    <input type=text name="name">
                    <br>(此項目會印在薪資條上)
                </td>
            </tr>
<%
    // ####### 會計科目東東 #######
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    String cond = "t=6&t=5&t=1";
%>
<link rel="stylesheet" href="css/auto_complete.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/auto_complete.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<script src="acode_data.jsp?<%=cond%>"></script>
<script src="js/billitem_acctcode.js?tuv"></script>
<script>
function doinit()
{
    new AutoComplete(aNames, 
        document.getElementById('acctcode'), 
        document.getElementById('codetip'), 
        -1,
        ajax_get_name
    );	    

    document.f1.acctcode.value = '<%=VoucherService.SALARY_EXPENSE%>';
    document.f1.acctcode.onblur();
}
</script>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    列帳科目(借方)
                </td>
                <td bgcolor=#ffffff colspan=2>
                    <div style="position:relative;overflow:visible;">
                        <input type=text id="acctcode" name="acctcode" size=7 autocomplete=off>
                        <div id="codetip" style="position:absolute;left:0px;top:21px;visibility:hidden;border:solid green 2px;background-color:white;z-index:1"></div>
                        <span onclick="find_acctcode('<%=cond%>')"><img src="pic/mirror.png" width=10></span>
                        <span id="acodename"></span>
                    </div>
                </td>
            </tr>
<%  // ####### end of 會計科目東東 ####### %>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    種類
                </td>
                <td>
                    <select name=salarytype>
                        <option value="0">---請選擇種類----
                        <option value="1">應付(+)
                        <option value="2">代扣(-)
                        <option value="3">應扣(-)
                    </select>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    延續(新增複製)
                </td>
                <td>
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_YES%>" checked> 是
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_NO%>"> 否
                </td>
            </tr>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="產生薪資項目">
                </form>
                </td>
            </tr>
        </table>
</td>
</tr>
</table>
</form>
</body>
