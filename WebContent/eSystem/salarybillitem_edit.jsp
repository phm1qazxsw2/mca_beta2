<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    int bid = Integer.parseInt(request.getParameter("bid"));
    BillItem bi = BillItemMgr.getInstance().find("id=" + bid);
    EzCountingService ezsvc = EzCountingService.getInstance();	
    String backurl = "salarybillitem_edit.jsp?" + request.getQueryString();
%>
<script>
function modify_accounting(bid)
{
    // openwindow_phm2('edit_billitem_template.jsp?bid='+bid, '設定會計科目', 500,500, 'vchrtemplate');
    location.href = 'edit_billitem_template.jsp?t=1&bid='+bid + '&backurl=' + encodeURI('<%=phm.util.TextUtil.escapeJSString(backurl)%>');
}

function doSubmit(f)
{
    if (f.name.value.length==0) {
        alert("薪資名稱不可空白");
        f.name.focus();
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
<form name="f1" action="salarybillitem_edit2.jsp" method="post" onsubmit="return doSubmit(this);">
<input type=hidden name="bid" value="<%=bid%>">
<input type=hidden name="backurl" value="<%=request.getParameter("backurl")%>">        
            薪資項目:
                </td>
                <td>
                    <input type=text name="name" value="<%=phm.util.TextUtil.encodeHtml(bi.getName())%>">
                    <br>(此項目會印在薪資條上)
                </td>
            </tr>

<%
    // ####### 會計科目東東 #######
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    VchrItem vi = vsvc.getBillItemInfo(bi, VchrItem.FLAG_DEBIT, VchrHolder.SALARY_BILLITEM_DEFAULT);
    VchrInfo vinfo = VchrInfo.getVchrInfo(vi,0);
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

    document.f1.acctcode.value = '<%=vinfo.getMain(vi)+vinfo.getSub(vi)%>';
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
                    <%
                       switch (bi.getSmallItemId()) {
                          case 1: out.println("應付(+)"); break;
                          case 2: out.println("代扣(-)"); break;
                          case 3: out.println("應扣(-)"); break;
                       }
                    %>
                </td>
            </tr>

<% /* if (new VoucherService(0, _ws2.getSessionBunitId()).initialized==1) { %>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    自動傳票產生範本
                </td>
                <td>
<%
                    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
                    VchrHolder v = vsvc.getBillItemVoucher(bi);
                    out.println("<table width='100%'><tr><td width='90%'>");
                    if (v==null) {
                        v = vsvc.getBillItemVoucher(VchrHolder.SALARY_BILLITEM_DEFAULT);
                        out.println("預設");
                    }
                    else {
                        ArrayList<VchrItem> items = VchrItemMgr.getInstance().retrieveList("vchrId=" + v.getId(), "");
                        VchrInfo vinfo = new VchrInfo(items, 0);
                        for (int i=0; i<items.size(); i++) {
                            VchrItem vi = items.get(i);
                            out.print((vi.getFlag()==VchrItem.FLAG_DEBIT)?"借":"貸");
                            out.print(" ");
                            out.print(vinfo.getAcodeFullName(vi, 36, true, false));
                            out.println("<br>");
                        }
                    }
                    out.println("</td><td valign=bottom width='10%' nowrap>");
                    out.println("<a href=\"javascript:modify_accounting("+bi.getId()+");\">內容</a>");
                    out.println("</td></tr></table>");
%>
                </td>
            </tr>
<% } */ %>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    延續(新增複製)
                </td>
                <td>
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_YES%>" <%=(bi.getCopyStatus()==BillItem.COPY_YES)?"checked":""%>> 是
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_NO%>" <%=(bi.getCopyStatus()==BillItem.COPY_NO)?"checked":""%>> 否
                </td>
            </tr>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="儲存修改">
                </form>
                </td>
            </tr>
        </table>
</td>
</tr>
</table>

</body>
