<%@ page language="java"  import="phm.ezcounting.*,phm.accounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
    request.setCharacterEncoding("UTF-8");
    int bid = Integer.parseInt(request.getParameter("bid"));
    BillItem bi = BillItemMgr.getInstance().find("id=" + bid);
    int cid = -1;
    try { cid = Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}

    ArrayList<Alias> aliases = AliasMgr.getInstance().retrieveListX("status=" + Alias.STATUS_ACTIVE, "", _ws2.getBunitSpace("bunitId"));

    //###### 連結學用品 #####
    PItem pi = null;
    int pid = -1;
    try { 
        pid = Integer.parseInt(request.getParameter("pid")); 
        pi = PItemMgr.getInstance().find("id=" + pid);
    } catch (Exception e) {}
    //#######################
    String backurl = "billitem_edit.jsp?" + request.getQueryString();
%>
<script>
function modify_accounting(bid)
{
    // openwindow_phm2('edit_billitem_template.jsp?bid='+bid, '設定會計科目', 500,500, 'vchrtemplate');
    location.href = 'edit_billitem_template.jsp?bid='+bid + '&backurl=<%=java.net.URLEncoder.encode(backurl)%>';
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
          if (bi.getPitemId()>0) {
            pi = PItemMgr.getInstance().find("id=" + bi.getPitemId());
            out.println("<div class=es02><font color=red>*</font>&nbsp;<img src='pic/littlebag.png' border=0>&nbsp;已連結學用品-" + pi.getName());
            ArrayList<PitemOut> pouts = PitemOutMgr.getInstance().retrieveList("billitem.id=" + bi.getId(), "group by pitemId");
            if (pouts.size()==0 || pouts.get(0).getQuantity()==0)
                out.println("&nbsp;&nbsp;&nbsp; <a href='disconnect_pitem.jsp?bid=" + bid + "'>解除連結</a>");
            else
                out.println("&nbsp;&nbsp;&nbsp; <b>已有加入收費不可解除連結</b>");
            
            out.println("</div>");                
          }
          else if (pi!=null) {
              out.println("連結至[" + pi.getName() + "] 中");
          }
      %>
      <table width="390" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
<form name="f1" action="billitem_edit2.jsp" method="post" onsubmit="return doSubmit(this);">
<input type=hidden name="pitemId" value="<%=pid%>">
<input type=hidden name="bid" value="<%=bid%>">     
            收費項目:
                </td>
                <td>
<% if (!mca.McaService.isSystemCharge(bi.getName())) { %>
                    <input type=text name="name" value="<%=bi.getName()%>">
<% } else { %>
                    <%=bi.getName()%>
                    <input type=hidden name="name" value="<%=bi.getName()%>">
<% } %>
                </td>
            </tr>
            <input type=hidden name="smallitem" value="<%=bi.getSmallItemId()%>">
<% /* if (new VoucherService(0, _ws2.getSessionBunitId()).initialized==1) { %>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    自動傳票產生範本
                </td>
                <td>
<%
                    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
                    VchrHolder v = vsvc.getBillItemVoucher(bi);
                    Map<Integer, Bunit> bunitMap = new SortingMap(BunitMgr.getInstance().retrieveList("flag=1","")).
                        doSortSingleton("getId");
                    out.println("<table width='100%'><tr><td width='90%'>");
                    if (v==null) {
                        v = vsvc.getBillItemVoucher(VchrHolder.BILLITEM_DEFAULT);
                    }
                    ArrayList<VchrItem> items = VchrItemMgr.getInstance().retrieveList("vchrId=" + v.getId(), "");
                    VchrInfo vinfo = new VchrInfo(items, 0);
                    for (int i=0; i<items.size(); i++) {
                        VchrItem vi = items.get(i);
                        out.print((vi.getFlag()==VchrItem.FLAG_DEBIT)?"借":"貸");
                        out.print(" ");
                        if (vi.getBunitId()>0) {
                            out.print(bunitMap.get(vi.getBunitId()).getLabel() + " ");
                        }
                        out.print(vinfo.getMain(vi));
                        out.print(" ");
                        out.print(vinfo.getSub(vi));
                        out.print(" ");
                        out.print(vinfo.getAcodeName(vi));
                        out.println("<br>");
                    }
                    out.println("</td><td valign=bottom width='10%' nowrap>");
                    out.println("<a href=\"javascript:modify_accounting("+bi.getId()+");\">設定</a>");
                    out.println("</td></tr></table>");
%>
                </td>
            </tr>
<% } */ %>

<%
    // ####### 會計科目東東 #######
    VoucherService vsvc = new VoucherService(0, _ws2.getSessionBunitId());
    VchrItem vi = vsvc.getBillItemInfo(bi, VchrItem.FLAG_CREDIT, VchrHolder.BILLITEM_DEFAULT);
    VchrInfo vinfo = VchrInfo.getVchrInfo(vi,0);
    String cond = "t=4&t=2";
%>
<link rel="stylesheet" href="css/auto_complete.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/auto_complete.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<script src="mca_acode_data.jsp?<%=cond%>"></script>
<script src="js/billitem_acctcode.js?abc"></script>
<script>
function doinit()
{
    new AutoComplete(aNames, 
        document.getElementById('acctcode'), 
        document.getElementById('codetip'), 
        -1,
        ajax_get_name
    );	    

    document.f1.acctcode.value = '<%=vinfo.getMain(vi)+"-"+vinfo.getSub(vi)%>';
    document.f1.acctcode.onblur();
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
                <td nowrap>
                    <input type=text name="defaultAmount" value="<%=bi.getDefaultAmount()%>" size=10>
                    <span id="defaultAmount"></span>
<%
    if (cid>0) {
        out.println("<input type=checkbox name='apply' value='1'> 金額套用本期帳單");
    }
%>
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    Deferr/Intr. Base
                </td>
                <td>
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_YES%>" <%=(bi.getCopyStatus()==BillItem.COPY_YES)?"checked":""%>> Yes
                    <input type=radio name="copyStatus" value="<%=BillItem.COPY_NO%>" <%=(bi.getCopyStatus()==BillItem.COPY_NO)?"checked":""%>> No
                </td>
            </tr>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    說明:
                </td>
                <td>
                    <textarea rows=3 cols=18 name="description"><%=bi.getDescription()%></textarea>
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
                       <option value="<%=a.getId()%>"<%=((bi.getAliasId()==a.getId())?" selected":"")%>><%=a.getName()%>
                 <% } %>
                    </select>
                    <br>(同一統稱的收費項目在帳單上會加總在此項目下)
                </td>
            </tr>
<%  } %>

<%
    if (pd2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) {
        ArrayList<BillChargeItem> bcitems = BillChargeItemMgr.getInstance().retrieveList("billType="+Bill.TYPE_BILLING, "");
        
%>
            <tr class=es02 bgcolor=ffffff>
                <td bgcolor=f0f0f0>
                    派遣收費<br>
                    附屬於
                </td>
                <td>
                    <select name=mainBillItemId>
                       <option value="0">
                 <% for (int i=0; i<bcitems.size(); i++) {
                     BillChargeItem item = bcitems.get(i);
                     if (item.getStatus()==BillItem.STATUS_ACTIVE || bi.getMainBillItemId()==item.getBillItemId()) {
                 %>
                       <option value="<%=item.getBillItemId()%>"<%=((item.getBillItemId()==bi.getMainBillItemId())?" selected":"")%>><%=item.getName()%>                      
                 <%  } 
                    } %>
                    </select>
                    <br>主項目空白即可
                </td>
            </tr>
<%  } %>
            <tr>
                <td colspan=2 bgcolor=ffffff valign=bottom align=middle>
                <input type=hidden name='cid' value='<%=cid%>'>
                <input type=submit value="儲存">
                </td>
            </tr>
        </table>
        </td>
        </tr>
        </table>
                </form>
</body>

<% if (bi.getPitemId()>0) { %>
<script>
    document.f1.defaultAmount.disabled = true;
    document.getElementById("defaultAmount").innerHTML = "(連結學用品售價)";
</script>
<% } %>

