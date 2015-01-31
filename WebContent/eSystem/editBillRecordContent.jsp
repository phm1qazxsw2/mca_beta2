<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%!
    public String getItemName(BillItem bi, Map<Integer, Vector<Alias>> aliasMap)
    {
        String ret = bi.getName();
        if (bi.getAliasId()>0) {
            Vector<Alias> va = aliasMap.get(new Integer(bi.getAliasId()));
            if (va!=null)
                ret = "[" + va.get(0).getName() + "] <span class=es01>" + ret + "</span>";
        }
        return ret;
    }

    public String getConnectingPitem(int pitemId, Map<Integer, Vector<PItem>> pitemMap)
    {
        if (pitemId<=0)
            return "";
        Vector<PItem> vp = pitemMap.get(new Integer(pitemId));
        if (vp==null)
            return "";
        String ret = vp.get(0).getName();
        if (ret.length()>4)
            ret = ret.substring(0,3) + "..";
        return "<a href=\"javascript:openwindow_phm('modify_product.jsp?id="+pitemId+"','學用品資料',400,300,false);\">" + ret + "</a>";
    }

    public Boolean havePitem(int pitemId, Map<Integer, Vector<PItem>> pitemMap)
    {
        if (pitemId<=0)
            return false;
        Vector<PItem> vp = pitemMap.get(new Integer(pitemId));
        if (vp==null)
            return false;
        else
            return true;
    }
%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,102))
    {
        response.sendRedirect("authIndex.jsp?code=102");
    }
    int recordId = Integer.parseInt(request.getParameter("recordId"));
    EzCountingService ezsvc = EzCountingService.getInstance();
    WebSecurity _ws_ = WebSecurity.getInstance(pageContext);
    BillRecordInfo record = BillRecordInfoMgr.getInstance().findX("billrecord.id="+recordId,
        _ws_.getBunitSpace("bill.bunitId"));

    if (record==null) {
        %><script>alert("資料不存在,可能已經被刪除了");history.go(-1)</script><%
        return;
    }

    Bill b = BillMgr.getInstance().find("id="+record.getBillId());

    BillItemMgr bimgr = BillItemMgr.getInstance();
    ArrayList<BillItem> bitems = bimgr.retrieveList("billId=" + b.getId(),"order by pos asc, id asc");
        // 如果只 select status==active, 那在比對 chargeitem 的 billitem 時就不會找到已刪除的
        // 所以在這要全部選出
        // retrieveList("billId=" + b.getId() + " and status=" + BillItem.STATUS_ACTIVE,"");
        // billItemId
    Map<Integer, ChargeItem> chargeitemMap = new SortingMap(ChargeItemMgr.getInstance().retrieveList(
        "billRecordId=" + recordId, "")).doSortSingleton("getBillItemId");

    ArrayList<ChargeItemMembr> allcharges = ChargeItemMembrMgr.getInstance().
        retrieveList("chargeitem.billRecordId=" + recordId, "");

    // billItemId
    Map<Integer, Vector<ChargeItemMembr>> chargeMap = 
        new SortingMap(allcharges).doSort("getBillItemId");

    // chargeItemId
    Map<Integer, Vector<Discount>> discountMap = null;
    if (allcharges.size()>0) {
        String chargeItemIds = new RangeMaker().makeRange(allcharges, "getChargeItemId");
        ArrayList<Discount> discounts = DiscountMgr.getInstance().
            retrieveList("chargeItemId in (" + chargeItemIds + ")", "");        
        discountMap = new SortingMap(discounts).doSort("getChargeItemId");
    }  

    Map<Integer, Vector<Alias>> aliasMap = 
        new SortingMap(AliasMgr.getInstance().retrieveListX("","",_ws.getMetaBunitSpace("bunitId"))).doSort("getId");
    Map<Integer, Vector<PItem>> pitemMap = 
        new SortingMap(PItemMgr.getInstance().retrieveList("","")).doSort("getId");

    int billNum = MembrBillRecordMgr.getInstance().numOfRows("billRecordId=" + recordId);
    int printOutNum = MembrBillRecordMgr.getInstance().numOfRows("billRecordId=" + recordId + " and printDate>'1980-01-01'");

    String backurl = "editBillRecord.jsp?" + request.getQueryString();
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");
    _ws.setBookmark(ud2, "整批編輯帳單-" + record.getName());
%>
&nbsp; 
<div class=es02>
<b>&nbsp;&nbsp;<%=record.getName()%></b> - 整批編輯帳單


&nbsp;&nbsp;&nbsp;&nbsp;<a href="billoverview.jsp"><img src="pic/last2.png" border=0>&nbsp;回帳單總覽</a>
</div>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<center>
<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
<tr>
    <td align=middle valign=top width=150 class=es02 nowrap>
        <br>
        <img src="img/bbill.gif" border=0>
        <br>
        <br>
        <div align=left>
        合計名單: <%=billNum%>     &nbsp;筆 <br>
        合計應收: <span id="total_sum"></span> 元<br>
        已發布鎖住: <%=printOutNum%>張 
        <% if (printOutNum>0) { %>
            <img src='pic/lockno2.png' width=15 height=15 align=top><a href="billrecord_unlock.jsp?rid=<%=recordId%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>" onclick="return confirm_unlock(<%=recordId%>)"> 解鎖</a>
        <% } else { /* %>
        <a href="javascript:do_delete_all()">刪除所有帳單</a>
        <% */ } %>
        </div>
        <br>
        <input type=button value="已開帳單列表" onClick="javascript:window.location='searchbillrecord.jsp?brId=<%=recordId%>'">
    </td>
    <td width=600 valign=top class=es02>
        <b>收費項目列表</b>
        <a href="javascript:openwindow_phm('addBillItem.jsp?billId=<%=record.getBillId()%>','新增收費項目',650,450,true);"><img src="pic/add.gif" border=0>&nbsp;新增收費項目</a>


        <br><br>
        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr align=left valign=top>
            <td bgcolor="#e9e3de">

            <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
                <td width=20 nowrap>No.</td>
                <td nowrap width=35% align=middle><b>收費項目</b></td>
<% if (pZ2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
                <td nowrap width=1%><b>附屬</b></td>
<% } %>
                <td nowrap width=1% align=middle><b>預設</b></td>
                <td nowrap width=1% align=middle><b>Defer/Intr.<br>Base</b></td>
                <td nowrap width=15% align=middle><b>應收小計</b></td>
                <td nowrap width=25% align=middle><b>收費名單</b></td>
                <td nowrap width=25% align=middle><b>調整名單</b></td>
                <td nowrap width=25% align=middle><b>調整小計</b></td>
            </tr>
        <%
            int total_sum = 0;
            int total_discount = 0;
            for (int i=0, row=0; i<bitems.size(); i++)
            {
                BillItem bi = bitems.get(i);
                Vector<ChargeItemMembr> cv = chargeMap.get(bi.getId());
                if (cv==null && bi.getStatus()!=BillItem.STATUS_ACTIVE) // 沒有內容也不是 active
                    continue;
                row ++;
                int cid = -1;
                int amt = 0;
                int d_amt = 0;
                boolean hasContent = (cv!=null);
                Vector<Discount> dv = null;
                if (bi.getPos()!=(row*10)) {
                    bi.setPos(row*10);
                    bimgr.save(bi);
                }

                String sortcolor = null;
                if (bi.getColor()!=null && bi.getColor().length()>0)
                    sortcolor = bi.getColor();

                String color = "#f0f0f0";
                String cls = "normal3";
                if (hasContent) {
                    ChargeItemMembr sample_ci = cv.get(0);
                    cid = sample_ci.getChargeItemId();
                    dv = discountMap.get(new Integer(sample_ci.getChargeItemId()));
                    for (int j=0; j<cv.size(); j++) {
                        amt += cv.get(j).getMyAmount();
                        total_sum += cv.get(j).getMyAmount();
                    }
                    for (int j=0; dv!=null&&j<dv.size(); j++) {
                        amt -= dv.get(j).getAmount();
                        total_sum -= dv.get(j).getAmount();
                        d_amt += dv.get(j).getAmount();
                        total_discount += dv.get(j).getAmount();
                    }
                    color = "white";
                    cls = "normal2";
                }
                else { // 有可能沒有人加入該收費項目，可是 chargeItem 已經產生了
                    ChargeItem tmp = chargeitemMap.get(bi.getId());
                    if (tmp!=null)
                        cid = tmp.getId();
                }
                %>
            <tr bgcolor=<%=color%> align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='<%=cls%>'">
                <td width=10 align=right <%=(sortcolor!=null)?"bgcolor=\""+sortcolor+"\"":""%>>
                    <a href="javascript:change_pos(<%=bi.getId()%>)"><%=row%></a></td>
                <td class=es02 width=200>
                <table width=100% cellpadding="0" cellspacing="0">
                <tr class=es02>
                    <td nowrap>
                    <%
                        if(havePitem(bi.getPitemId(), pitemMap)){
                    %>                        
                            <a href="javascript:openwindow_phm('modify_product.jsp?id=<%=bi.getPitemId()%>','學用品資料',400,300,false);"><img src="pic/littlebag.png" border=0 width=14></a>
                    <%
                        }else{
                            if(hasContent){
                        %>
                            <img src="img/flag2.png" border=0>&nbsp;
                        <%  }else{  %>
                            &nbsp;&nbsp;&nbsp;
                        <%  }   %>
                    <%  }   %>
                    &nbsp;<%=getItemName(bi, aliasMap)%> 
                    </td>
                    <td width=40 nowrap>
                    (<a href="javascript:openwindow_phm2('billitem_edit.jsp?bid=<%=bi.getId()%>&cid=<%=cid%>','編輯收費項目',650,450,'editwin');">修改</a>)
                    </td>
                </tr>
                </table>    
                </td>
<% if (pZ2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) { %>
                <td nowrap width=1% align=middle><%=(bi.getMainBillItemId()>0)?"是":""%></td>
<% } %>
                <td nowrap align=center class=es02>
                    <%=mnf.format(bi.getDefaultAmount())%>
                </td>
                <td nowrap align=center class=es02>
                    <%=bi.getCopyStatus()==BillItem.COPY_YES?"是":"否"%>
                </td>
                <td class=es02 nowrap align=right> 
<% if (hasContent) { %>
                <%=mnf.format(amt)%> 元
<% } %>
                </td>
                <td>
                    <table width=100% border=0 class=es02>
                    <tr class=es02>
                        <td width=40% align=right nowrap>
<% if (hasContent) { %>
                            <%=cv.size()%>筆 
<% } %>
                        </td>
                        <td width=30%  align=middle nowrap>
                            <a href="editChargeItem.jsp?rid=<%=recordId%>&bid=<%=bi.getId()%>&cid=<%=cid%>"><img src="pic/fix.gif" border=0 width=12>編輯名單</a>
                        </td>
                    </table>
                </td>
                <td class="es02">
<% if (hasContent) { %>
                    <table width=100% border=0 class=es02>
                    <tr class=es02>
                        <td width=30% align=right nowrap>
                            <%=(dv==null)?0:dv.size()%>筆 
                        </td>
                        <td width=30%  align=middle  nowrap>
                            <a href="editChargeItemDiscount.jsp?cid=<%=cid%>"><img src="pic/fix.gif" border=0 width=12>編輯名單</a>
                        </td>
                    </table>
<% } else if (!mca.McaService.isSystemCharge(bi.getName())) { %>
                    <a href="billitem_remove.jsp?bid=<%=bi.getId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>" onclick="return confirm_delete(<%=bi.getPitemId()%>)">刪除</a>
<% } %>
                </td>

                <td nowrap class="es01" align=right>
<% if (hasContent) { 
      if (d_amt!=0) { %>            
                    &nbsp;<%=mnf.format(0-d_amt)%> 元
<% } } %>
                </td>

            </tr>
<%          } %>

<% 
    int colspan = 4;
    if (pZ2.getWorkflow()==PaySystem2.WORKFLOW_NEIL) {
        colspan += 1;
    }
%>

            <tr bgcolor=white class=es02>
                <td colspan="<%=colspan%>" align=right>應收小計&nbsp;</td>
                <td align=right nowrap><%=mnf.format(total_sum)%> 元</td>
                <td colspan=2 align=right>調整小計&nbsp;</td>
                <td nowrap colspan=2 align=left>&nbsp;<%=mnf.format(0-total_discount)%> 元</td>
            </tr>

        </table>
        </td></tr></table>

    </td>
    </tr>
    </table>

</center>
<br>
<br>

<br>
<br>

<script>
var d = document.getElementById("total_sum");
d.innerHTML = '<%=mnf.format(total_sum)%>';
function do_delete_all()
{
    if (!confirm("確定刪除全部帳單？"))
        return;
    location.href = "billrecord_delete_hard.jsp?brid=<%=recordId%>";
}

function confirm_delete(pitemId)
{
    if (pitemId>0) {
        alert("請先解除和學用品的連結才可刪除");
        return false;
    }
    if (confirm('刪除不會影響以前開過的帳單，確定刪除？')) 
        return true; 
    return false;
}

function confirm_unlock(rid)
{
    if (confirm("鎖住的目的是為了避免已發布的帳單意外被修改或刪除, 確定解鎖?")) {
        return true;
    }
    return false;
}

function change_pos(bid)
{
    openwindow_phm2('billitem_property.jsp?bid=' + bid, '修改順序與顏色', 500, 400, 'propertywin');
}
</script>