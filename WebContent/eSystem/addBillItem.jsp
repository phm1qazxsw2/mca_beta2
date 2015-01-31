<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }

    int billId = Integer.parseInt(request.getParameter("billId"));
    EzCountingService ezsvc = EzCountingService.getInstance();	
    Bill b = BillMgr.getInstance().find("id="+billId);

    //###### 連結學用品 #####
    String name = "";
    int aliasId = -1;
    PItem pi = null;
    int pid = -1;
    try { 
        pid = Integer.parseInt(request.getParameter("pid")); 
        pi = PItemMgr.getInstance().find("id=" + pid);
        //name = pi.getName();
        //IncomeSmallItem is = (IncomeSmallItem) ObjectService.find("jsf.IncomeSmallItem", "incomeSmallItemName='學用品'");
        //sid = is.getId();
    } catch (Exception e) {}
    //#######################

    ArrayList<Alias> aliases = AliasMgr.getInstance().retrieveListX("status=" + Alias.STATUS_ACTIVE, "", _ws2.getBunitSpace("bunitId"));

    String backurl = request.getParameter("backurl");
    if (backurl==null)
        backurl = "null";
%>
<script>
function check(s)
{
    if (s.options[s.selectedIndex].value==0) {
        while (true) {
            var name = prompt("請輸入新項目的名稱");
            if (name==null) {
                s.selectedIndex = 0;
                break;
            }
            else if (name.length>0) {
                location.href = "addBillItem.jsp?billId=<%=billId%>&n=" + encodeURI(name);
                break;
            }
            else if (name.length==0) {
                alert("您沒有輸入的名稱!");
            }
        }
    }
}
function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char; 
    if (sText.length==0)
        return false;
    var i = 0;
    if (sText.length>0 && sText.charAt(0)=='-')
        i = 1;
    for (; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;
}


function doSubmit(f)
{
    if (f.name.value.length==0) {
        alert("收費名稱不可空白");
        f.name.focus();
        return false;
    }
    if (trim(f.acctcode.value).length==0) {
        alert("請選擇一列帳科目");
        f.acctcode.focus();
        return false;
    }
    if (!IsNumeric(f.defaultAmount.value)) {
        alert("預設金額請輸入數字");
        f.defaultAmount.focus();
        return false;
    }
    f.defaultAmount.disabled = false;
    return true;
}

</script>
<body onload="doinit()">

<table border=0 width=100%>
<tr>
    <td align=middle valign=top width=150 class=es02>
                <img src="img/bbill.gif" border=0>
    </td>
    <td>
      <%
          if (pi!=null) {
              out.println("連結至[" + pi.getName() + "] 中");
          }
      %>

      <table width="390" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
<form name="f1" action="addBillItem2.jsp" method="post" onsubmit="return doSubmit(this);">
<input type=hidden name="billId" value="<%=billId%>">
<input type=hidden name="pitemId" value="<%=pid%>">
<input type=hidden name="backurl" value="<%=backurl%>">        
            收費項目:
                </td>
                <td>
                    <input type=text name="name" value="<%=name%>">
                <% if (pid==-1) { %>
                    &nbsp;&nbsp;&nbsp; <a href="connect_product.jsp?billId=<%=billId%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>">連結學用品扣庫存</a>
                <% } %>
                    <br>(此項目會印在帳單上)
                </td>
            </tr>
            <input type=hidden name="smallitem" value="0">
<% /* if (VoucherService.initialized==1) { %>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    自動傳票產生範本
                </td>
                <td>
<%
                    out.println("<table width='100%'><tr><td width='90%'>");
                    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
                    VchrHolder v = vsvc.getBillItemVoucher(VchrHolder.BILLITEM_DEFAULT);
                    ArrayList<VchrItem> items = VchrItemMgr.getInstance().retrieveList("vchrId=" + v.getId(), "");
                    VchrInfo vinfo = new VchrInfo(items, 0);
                    for (int i=0; i<items.size(); i++) {
                        VchrItem vi = items.get(i);
                        out.print((vi.getFlag()==VchrItem.FLAG_DEBIT)?"借":"貸");
                        out.print(" ");
                        out.print(vinfo.getAcodeFullName(vi, 36, true, false));
                        out.println("<br>");
                    }
                    out.println("</td><td valign=bottom width='10%' nowrap>");
                    out.println("</td></tr></table>");
%>
                    (新增後可修改)
                </td>
            </tr>
<% } */ %>

<%
    // ####### 會計科目東東 #######
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    String cond = "t=4&t=2";
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

    // 2009/2/22 by peter: 一開始空的強迫 user 自選
    //document.f1.acctcode.value = '<%=VoucherService.REVENUE%>';
    //document.f1.acctcode.onblur();
}
</script>

            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    列帳科目(貸方)
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
                    預設金額
                </td>
                <td>
                    <input type=text name="defaultAmount" value="<%=(pi!=null)?pi.getSalePrice():0%>" size=10>
                    <span id="defaultAmount"></span>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    複製設定
                </td>
                <td>
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_YES%>" <%=(pi==null)?"checked":""%>> 延續
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_NO%>" <%=(pi==null)?"":"checked"%>> 不延續
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    說明:
                </td>
                <td>
                    <textarea rows=3 cols=18 name="description"></textarea>
                    <br>(說明此項目不會印在帳單上)
                </td>
            </tr>
<%
    if (aliases.size()>0) { 
        Iterator<Alias> iter = aliases.iterator();
%>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    收費統稱
                </td>
                <td>
                    <select name=alias>
                       <option value="0">-- 不用 --
                 <% while (iter.hasNext()) { 
                     Alias a = iter.next(); %>
                       <option value="<%=a.getId()%>" <%=(aliasId==a.getId())?"selected":""%>><%=a.getName()%>
                 <% } %>
                    </select>
                    <br>(同一統稱的收費項目在帳單上會加總在此項目下)
                </td>
            </tr>
<%  } %>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=submit value="產生收費項目">
                </td>
            </tr>
        </table>
        </td>
        </tr>
        </table>
</form>
</body>

<% if (pi!=null) { %>
<script>
    document.f1.defaultAmount.disabled = true;
    document.getElementById("defaultAmount").innerHTML = "(連結學用品售價)";
</script>
<% } %>