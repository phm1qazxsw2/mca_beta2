<%@ page language="java" buffer="32kb" import="web.*,jsf.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<style>
.ei {
     border: 1px #e0e0e0 solid; 
}
</style>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int recordId = -1; try { recordId=Integer.parseInt(request.getParameter("rid")); } catch (Exception e) {}
    int bitemId = -1; try { bitemId=Integer.parseInt(request.getParameter("bid")); } catch (Exception e) {}
    int citemId = -1; try { citemId=Integer.parseInt(request.getParameter("cid")); } catch (Exception e) {}
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM");
    EzCountingService ezsvc = EzCountingService.getInstance();
    BillChargeItem bcitem = null;
    // br.getMonth():
    WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
    if (citemId<0)
        bcitem = BillChargeItemMgr.getInstance().findX("billrecord.id=" + recordId + " and billitem.id=" + bitemId, _ws_.getBunitSpace("bill.bunitId"));
    else
        bcitem = BillChargeItemMgr.getInstance().findX("chargeitem.id=" + citemId, _ws_.getBunitSpace("bill.bunitId"));

    if (bcitem==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

    BillRecord br = BillRecordMgr.getInstance().find("id=" + bcitem.getBillRecordId());
    ArrayList<ChargeItemMembr> chargedmembrs = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeItemId=" + bcitem.getId(), "");
    Map<Integer, ChargeItemMembr> chargemembrMap = new SortingMap(chargedmembrs).doSortSingleton("getMembrId");
    boolean connecting_product = (bcitem.getPitemId()>0);
    String conn_str = "";
    if (connecting_product) {
        PItem pi = PItemMgr.getInstance().find("id=" + bcitem.getPitemId());
        conn_str = "【連結" + pi.getName() + "】";
    }

%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/ajax-dynamic-content.js"></script>
<script type="text/javascript" src="js/ajax.js"></script>
<script type="text/javascript" src="js/ajax-tooltip.js"></script>
<script type="text/javascript" src="js/formcheck.js"></script>
<script>
function check(f)
{
    if (!IsNumeric(f.amount.value)) {
        alert("請填入正確的金額");
        f.amount.focus();
        return false;
    }
    return true;
}


function check_all(c) {
    var target = document.f2.target;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined')
            target.checked = c.checked;
        else {
            for (var i=0; i<target.length; i++) {
                target[i].checked = c.checked;
            }
        }
    }
}

var changed = false;
function update_change(i, chargeKey, org_amount, f)
{
    if (!IsNumeric(f.value)) {
        alert("請輸入正確的金額");
        f.focus();
        return;
    }
    if (f.value!=org_amount) {
        changed = true;
    }
}

function update_price(chargeKey, unitPrice, f)
{
    if (!IsNumeric(f.value)) {
        alert("請輸入正確的數量");
        f.focus();
        return;
    }
    var e = document.f2.elements["_" + chargeKey];
    e.value = unitPrice * f.value;
}

function do_remove() {
    var target = document.f2.target;
    var something_selected = false;
    if (typeof target!='undefined') {
        if (typeof target.length=='undefined') {
            if (target.checked)
                something_selected = true;
        }
        else {
            for (var i=0; i<target.length; i++) {
                if (target[i].checked) {
                    something_selected = true;
                    break;
                }
            }
        }
    }
    if (!something_selected) {
        alert("請先選取要刪除的對象");
    }
    else {
        if (confirm("確定刪除？")) {
            document.f2.action = "chargeitem_batchremove.jsp";
            document.f2.submit();
        }
    }
}

function doSave()
{
    changed = false;
    document.f2.action = "billchargeitem_setamount.jsp";
    document.f2.submit();
}

</script>
<br> 
<div class=es02>
&nbsp;&nbsp;&nbsp;
&nbsp; <b><%=bcitem.getBillRecordName()%></b>- 整批編輯收費項目
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<%
    if(pageType==0){
%>
<a href="editBillRecord.jsp?recordId=<%=bcitem.getBillRecordId()%>"><img src="pic/last2.png" border=0 width=12>&nbsp;回編輯帳單</a>
<%
    }
%>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>

<form action="editChargeItem2.jsp" onsubmit="return check(this);">
<input type=hidden name="param" value="<%=bcitem.getBillRecordId()%>#<%=bcitem.getBillItemId()%>#<%=bcitem.getId()%>">
<div class=es02>
<b>收費項目設定 - <%=bcitem.getName()%> <%=conn_str%></b>
</div>
    <table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#4A7DBD">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
         <tr bgcolor=ffffff class=es02>
            <td width=100%>
 
    <table border=0 width=100%>
    <tr>
    <td width=150 align=middle>
        <img src="img/cbill.gif" border=0>
    </td>
    <td class=es02>
    
            <table width="400" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=f0f0f0 class=es02>
                        <td>列帳科目:</td>
                        <td bgcolor=ffffff>
                            <input type=hidden name="smallitem" value="<%=bcitem.getSmallItemId()%>">
<%
    VoucherService vsvc = new VoucherService(0, _ws_.getSessionBunitId());
    BillItem bi = BillItemMgr.getInstance().find("id=" + bcitem.getBillItemId());
    VchrItem vi = vsvc.getBillItemInfo(bi, VchrItem.FLAG_CREDIT, VchrHolder.BILLITEM_DEFAULT);
    VchrInfo vinfo = VchrInfo.getVchrInfo(vi,0);
    out.println(vinfo.getAcodeFullName(vi, 50, false, false));
%>
<%/*
                    VoucherService vsvc = new VoucherService(0, _ws.getSessionBunitId());
                    BillItem bi = BillItemMgr.getInstance().find("id=" + bcitem.getBillItemId());
                    VchrHolder v = vsvc.getBillItemVoucher(bi);
                    out.println("<table width='100%' class=es02 cellpadding=0 cellspacing=0><tr><td width='90%'>");
                    if (v==null) {
                        v = vsvc.getBillItemVoucher(VchrHolder.BILLITEM_DEFAULT);
                    }
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
*/ %>

                        </td>
                    </tr>
                    <tr bgcolor=f0f0f0 class=es02>
                        <td>本月應收金額:</td>
                        <tD bgcolor=ffffff>
                    
            <%  if (chargedmembrs.size()==0) { 
                   if (bcitem.getPitemId()==0) { %>
                        <input type=text name="amount" size=12 value="<%=bcitem.getDefaultAmount()%>">
                <% } else { %>
                        <input type=hidden name="amount" value="<%=bcitem.getDefaultAmount()%>">
                        <input type=text name="amountStr" size=12 value="<%=bcitem.getDefaultAmount()%>" disabled> (連結學用品售價)
                <% } %>

            <%  }else{  %>
                        <font color=blue><%=(bcitem.getChargeAmount()==0)?mnf.format(bcitem.getDefaultAmount()):mnf.format(bcitem.getChargeAmount())%></font>   元

            <%  }   %>
                        </td>
                    </tr>
<%
    PaySystem _ps_ = (PaySystem) PaySystemMgr.getInstance().find(1);
    TagHelper th = TagHelper.getInstance(_ps_, 0, _ws_.getSessionStudentBunitId());
    ArrayList<Tag> tags = th.getTagsForChargeItem(bcitem);
    String tagNames = th.getTagNamesForChargeItem(bcitem);
%>
                    
                    <tr bgcolor=f0f0f0 class=es02>
                        <td>連結的標籤:</td>
                        <tD bgcolor=ffffff valign=middle>                        
                            <%=tagNames%>
                        </td>
                    </tr>
    <%                                      
        if (chargedmembrs.size()==0) { %>
                    <tr bgcolor=ffffff>
                        <td colspan=2 align=middle>
                            <input type=submit value=" &nbsp;設定 &nbsp;">
                        </td>
                    </tr>
    <%  }   %>

                    </form>
                    </table>
                </td>
                </tr>

            </table>
    </td>
    </tr>
  </table>

        </td>
        </tr>
        </table>
    </td>
    </tr>
    </table>
<br>
<%
   // Date doNew = sdf.parse("2009/03");
   // if (br.getMonth().compareTo(doNew)>=0 && (tags.size()>0)) { 
if (tags.size()>0) { 
%>
<%@ include file="chargemembr_edit_tag.jsp"%>  
<% } else { %>
<%@ include file="chargemembr_edit_notag.jsp"%>
<% } %>
</blockquote>
