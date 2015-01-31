<%@ page import="mca.*"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/show_voucher.js"></script>
<script type="text/javascript" src="js/bill.js"></script>
<%! 
    public String makeNameLink(String name, int membrId, int studentId)
    {
        if (name==null || name.trim().length()==0) {
            name = "##";
        }
        StringBuffer sb = new StringBuffer();
        sb.append("<a href=\"javascript:openwindow_phm('modifyStudent.jsp?studentId="+studentId+"','基本資料',700,700,false);\" onmouseover=\"ajax_showTooltip('peek_membr.jsp?id="+membrId+"',this);return false;\" onmouseout=\"ajax_hideTooltip()\">");
        sb.append(name);
        sb.append("</a>");
        return sb.toString();
    }
%>
<%
    //##v2
    if(!checkAuth(ud2,authHa,101))
    {
        response.sendRedirect("authIndex.jsp?cpde=101");
    }
 
    String backurl = request.getParameter("backurl");


    //backurl="bill_detail_express.jsp?"+request.getQueryString();

    String myurl = "bill_detail.jsp?" + request.getQueryString();

    int membrId = Integer.parseInt(request.getParameter("sid"));
    int billRecordId = Integer.parseInt(request.getParameter("rid"));

    WebSecurity _ws_ = WebSecurity.getInstance(pageContext);

    MembrInfoBillRecordMgr mibrmgr = MembrInfoBillRecordMgr.getInstance();
    MembrInfoBillRecord sinfo = mibrmgr.findX("membrId=" + membrId + " and billRecordId=" + 
        billRecordId + " and billType=" + Bill.TYPE_BILLING, _ws_.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能編 cover 單位的帳單

    if (sinfo==null) {
        %><script>alert("資料不存在,可能已經被刪除了");history.go(-1)</script><%
        return;
    }
    
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    ArrayList<ChargeItemMembr> items = cismgr.retrieveList(
        "charge.membrId=" + membrId + " and chargeitem.billRecordId=" + billRecordId, "order by pos asc");
    // items = new SortingMap(items).descendingBy("getMyAmount");
    /*
    ## 2009/1/20, by peter, need empty bill for 宏田(一開始帳單)
    if (items.size()==0) {
        Object[] objs = { sinfo };
        MembrBillRecordMgr.getInstance().remove(objs);
        out.println("<br><br><blockquote>這筆資料不存在，可能已經被刪除了!</blockquote>");
        return;
    }
    */

    String chargeItemIds = new RangeMaker().makeRange(items, "getChargeItemId");
    ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().retrieveList(
        "membrId=" + membrId + " and chargeItemId in (" + chargeItemIds + ")", "order by feeTime asc");
    Map<String, ArrayList<FeeDetail>> feeMap = new SortingMap(fees).doSortA("getChargeKey");

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");    
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yy年MM月");    
    java.text.SimpleDateFormat sdf3 = new java.text.SimpleDateFormat("yyyy-MM");    
    DiscountMgr dmgr = DiscountMgr.getInstance();

    BillCommentMgr bmgr = BillCommentMgr.getInstance();
    BillComment bc = bmgr.find("membrId=" + membrId + " and billRecordId=" + billRecordId);
    String comment = (bc==null)?"":bc.getComment();

    String billprintstr = sinfo.getMembrId() + "#" + sinfo.getBillRecordId();
    String mainTagName = null;
    try {
        MainTagStudent tag = MainTagStudentMgr.getInstance().find("membr.id=" + sinfo.getMembrId());
        mainTagName = tag.getTagName();
    }
    catch (Exception e) {}

    String title = sdf3.format(sinfo.getBillMonth()) + " " +  sinfo.getMembrName() + " " +sinfo.getBillPrettyName();


    boolean active_status=(sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID);
    String active_color = (active_status)?"F77510":"4A7DBD";
    
    boolean locked = (sinfo.getPrintDate()>0);
    long edit_remain = new Date().getTime() - sinfo.getForcemodify();
    boolean force = (edit_remain < 60*5*1000); // 5 mins

    ArrayList<MembrInfoBillRecord> all_bills = mibrmgr.retrieveListX("membrId=" + membrId, 
        "order by billrecord.id desc", _ws_.getAcrossBillBunitSpace("bill.bunitId"));

    int account_remain = (int)0;
    ArrayList<BillPay> payhistory = BillPayMgr.getInstance().
        retrieveList("membrId=" + membrId + " and remain>0", "");
    Iterator<BillPay> iter4 = payhistory.iterator();
    while (iter4.hasNext())
        account_remain += iter4.next().getRemain();

    Object[] users2 = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getUserLoginId");

%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script language="JavaScript" src="js/in.js"></script>
<script>
function print_receipt(bpayId, ticketId)
{
    var url = 'print_mcabill_receipt.jsp?pid=' + bpayId + '&tid=' + ticketId + '&r=' + new Date().getTime();
    if (confirm("Ok=116201應收學費, Cancel=214101預收學費"))
        url += '&a=1';
    else
        url += '&a=2';
    openwindow_phm2(url, '列印收據', 300, 300, 'receiptwin');
}

function setup_prorate()
{
    openwindow_phm2("mca_prorate_setup.jsp?tid=<%=sinfo.getTicketId()%>", '設定 Pro-rate', 400, 300, 'proratewin');    
}

function do_force()
{
    if (!confirm("確定開啟編輯狀態?")) {
        return;
    }

    var url = "membrbillrecord_forcemodify.jsp?ticketId=<%=sinfo.getTicketId()%>&r="+(new Date()).getTime();
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else
                    location.reload();
            }
            else if (req.readyState == 4 && (req.status == 500 || req.status == 404)) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function delete_item(cid, sid, name)
{
    if (!confirm("確定刪除 " + name)) {
        return;
    }

    var url = "billcharge_delete.jsp?cid="+cid +"&sid=" + sid + "&r="+(new Date()).getTime();
    var req = new XMLHttpRequest();

    if (req) 
    {
        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                var t = req.responseText.indexOf("@@");
                if (t>0)
                    alert(req.responseText.substring(t+2));
                else
                    location.reload();
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("刪除發生錯誤，沒有寫入");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);

}

function reset_lock()
{
    if (!confirm("鎖住的目的為防止已發出的帳單被修改或刪除，確定解開？")) {
        return;
    }
    var url = "reset_lock.jsp?brid=<%=billRecordId%>&mid=<%=membrId%>&r="+(new Date()).getTime();
    var req = new XMLHttpRequest();
    if (req) 
    {
        window.onerror = function()
        {
            alert('發生錯誤2');
            return;
        }

        req.onreadystatechange = function() 
        {
            if (req.readyState == 4 && req.status == 200) 
            {
                location.reload();
            }
            else if (req.readyState == 4 && req.status == 500) {
                alert("發生錯誤");
                return;
            }
        }
    };
    req.open('GET', url);
    req.send(null);
}

function do_delete()
{
    if (!confirm("刪除帳單的動作會記錄在日誌中，繼續？"))
        return;
    document.f1.submit();
}

function do_refund(payid)
{
    if (!confirm("退費會先把金額加入個人帳戶，該餘額可用來銷其他帳單或進行實際退款動作，繼續？"))
        return;
    f2.pid.value = payid;
    document.f2.submit();
}
</script>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;帳單資訊 - <%=title%></b>
&nbsp;&nbsp;&nbsp;&nbsp;
<%
    if(pageType==0){
%>
    <a href="<%=backurl%>"><img src="pic/last2.png" border=0 width=12>&nbsp;回上一頁</a>
<%
    }
%>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<center>


<table cellpadding=0 cellspacing=0 border=0 width=800 height=700>
<tr>
    <td width=160 valign=top>
    <br><br>
    <!-- list of transactions -->
    <table border=0 cellpadding=0 cellspacing=0 width=100%>
    <%
        Iterator<MembrInfoBillRecord> iter3 = all_bills.iterator();
        int unpaid_total =0;
        while (iter3.hasNext()) {
            MembrInfoBillRecord binfo = iter3.next();
            boolean lcked = (binfo.getPrintDate()>0);
            boolean paid = binfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID;
            String icon = "";
            if (paid)
                icon = "<img src='pic/lockfinish2.png' width=15 height=15 align=top>";
            else if (lcked) 
                icon = "<img src='pic/lockno2.png' width=15 height=15 align=top>";

            boolean isActive=binfo.getTicketId().equals(sinfo.getTicketId());
            String color = (isActive)?active_color:"white";
            unpaid_total += (binfo.getReceivable() - binfo.getReceived());
          %>
            <tr>
                <%
                    if(isActive)
                    {
                %>
                    <td width=8><img src='img/a<%=active_status?"2":"1"%>_left1.gif' border=0 height=25></td>              
                <%  
                  }else{
                        out.println("<td width=8></td>");
                    }
                %>
                <td bgcolor="<%=color%>"><%=icon%></td>
                <td bgcolor="<%=color%>" width=100% height=25 valign=center class=es02>&nbsp;<a href="<%=(pageType==0)?"bill_detail":"bill_detail_express"%>.jsp?sid=<%=membrId%>&rid=<%=binfo.getBillRecordId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>"><font color="<%=isActive?"ffffff":"5F5F5F"%>"><%=binfo.getBillRecordName()%></font></a></td>
            </tr>
    <%
        }
        
        int reportId=0;
    %>
        <%@ include file="billdetail_menu.jsp"%>
    </table>
    </td>
    <td valign=top>
        <table border=0 cellpadding=0 cellspacing=0 width=100% height=9>
        <tr width=100%>
            <td background="img/a<%=active_status?"2":"1"%>_11.gif" width=9 height=9></td>
            <td bgcolor="<%=active_color%>"><img src="img/aspace.gif" border=0></td>
            <tD width=9 height=9 background="img/a<%=active_status?"2":"1"%>_12.gif"></td>
        </tr>
        <tr bgcolor="<%=active_color%>">
            <td></td>
            <td>
            
            <table border=0 CELLSPACING=0 CELLPADDING=0 width=100%>
            <tr>
                <td>
                    <table border=0 CELLSPACING=0 CELLPADDING=0 width=100%>
                    <tr class=es02 height=30>
                    <td nowrap>
                        <a href="javascript:openwindow_phm('modifyStudent.jsp?studentId=<%=sinfo.getMembrSurrogateId()%>','基本資料',700,700,true);"><font color=ffffff>&nbsp;&nbsp;&nbsp;姓名: <b><%=sinfo.getMembrName()%></b><%=(mainTagName!=null)?"【"+mainTagName+"】":""%></font></a>
                        <font color=ffffff>(
                        <%
                            if(sinfo.getPrintDate()!=0){
                        %>
                            上次列印時間: <%=sdf.format(sinfo.getPrintDate())%>
                        <%  }else{  %>

                            從未列印
                        <%  }   %>

                         , 繳款狀態:
                        <% 
                        if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) out.println("<b>已繳清</b>");
                        else if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_PARTLY_PAID) out.println("<b>部分已繳</b>");
                        else out.println("尚未繳款");
                        if (sinfo.getPending_cheque()==1) out.println(" <b>支票尚未兌現</b>");
                        %>
                        )
                        (<%=PaymentPrinter.makePrecise(membrId+"", 4, false, '0')%>)
                        </font>
    
                    </td>
                    <td width=200>

                    </tD>
                    </tr>
                    <tr>
                    <td colspan=3 align=bottom>
            <table border=0>
                <tr>
                <% if (sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) { %>
                    <form action="billrecord_detail.jsp" target="_blank">
                    <td valign=top>
                        <input type=hidden name="o" value="<%=billprintstr%>">
                        <input type=hidden name="t" value="<%=title%>">            
                        <input type=submit value="發佈帳單">
                    </td>
                    </form>
<%
    McaRecord mfr = McaRecordInfoMgr.getInstance().find("billRecordId=" + 
        sinfo.getBillRecordId() + " and mca_fee.status!=-1");
    McaProrate mp = McaProrateMgr.getInstance().find("mcaFeeId=" + mfr.getMcaFeeId() + 
        " and membrId=" + sinfo.getMembrId());
    String btntext2 = (mp==null)?"Full Semester":("Pro-rated " + sdf.format(mp.getProrateDate()));

    if(checkAuth(ud2,authHa,103)){
%>
                        <% if ((sinfo.getReceivable()-sinfo.getReceived())>0) { %>
                <td valign=top>
                        <input type=button onclick="openwindow_phm('otc_pay_all.jsp?rid=<%=billRecordId%>&sid=<%=membrId%>','臨櫃繳款',500,500,true);" value="臨櫃繳款">
                </td>
                <td valign=top>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <input type=button value="<%=btntext2%>" onclick="setup_prorate()">
                </td>
                        <% } else { %>
                <td valign=top>
                        <input type=button onclick="location.href='membrbillrecord_markpaid.jsp?rid=<%=billRecordId%>&sid=<%=membrId%>&backurl=<%=java.net.URLEncoder.encode(myurl)%>'" value="設為已付">
                </td>
                        <% } %>
<%
    }
%>
                <% } else { /* %>
                    <form action="print_mcabill_receipt.jsp" target="_blank">
                        <td valign=top>
                                <input type=hidden name="r" value="<%=new Date().getTime()%>">            
                                <input type=hidden name="tid" value="<%=sinfo.getTicketId()%>">            
                                <input type=submit value="列印收據">
                        </td>
                    </form>
                <% */ } %>
                </tr>
                </table>
                    </td>
                    <% 
                        if (pd2.getPagetype()==7) { 
                            String btntxt = "Deferred Plan";
                            McaDeferred md = McaDeferredMgr.getInstance().find("ticketId='" + sinfo.getTicketId() + "'");
                            if (md!=null) {
                                if (md.getType()==McaDeferred.TYPE_STANDARD)
                                    btntxt = "Standard Deferred";
                                else if (md.getType()==McaDeferred.TYPE_MONTHLY)
                                    btntxt = "Monthly Deferred";
                            }
                    %>
                    <td>
                            <input type=button value="<%=btntxt%>" <%=genDeferOnclick(sinfo)%>>
                    </td>
                    <% } %>
                <% if (!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID) { %>
<%
    if(checkAuth(ud2,authHa,102)){
%>
                    <td align=right><input type=button value="刪除帳單" onclick="do_delete();"></td>
<%  }   %>
                <% } else { %>
                    <td></td>
                <% } %>
                    </tr>
                    </table>
                    <br>
                </td>
            </tr>
            <tr bgcolor=ffffff width=100% height=600>
            <td width=100% valign=top>
                        <table border=0 CELLSPACING=0 CELLPADDING=0 width="100%">
                        <tr>
                            <td width="30%">
                                <br>
                                <center>
                                    <img src="img/billd.gif" border=0>
                                </center>
                            </td>
                            <td valign=top>
                                <br>
                                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>帳單資訊</b></div> 
                            <center>
                            <table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
                                <tr align=left valign=top>
                                <td bgcolor="#e9e3de">
                                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>A 標題</td>
                                        <td  bgcolor=ffffff colspan=2><%=sinfo.getBillPrettyName()%> <%=sdf2.format(PaymentPrinter.convertToTaiwanDate(sinfo.getBillMonth()))%></tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>B 帳單流水號</td>
                                        <td  bgcolor=ffffff colspan=2>
                    <%=sinfo.getTicketId()%>
                    <%  if (sinfo.getThreadId()>0) { %>
                         &nbsp;&nbsp;<a href="javascript:show_bill_vouchers('<%=sinfo.getTicketId()%>', <%=sinfo.getThreadId()%>)"><img src="pic/costtype3.png" border=0>&nbsp;傳票內容</a></div>
                    <%  }else{   %>
                        &nbsp;&nbsp;(尚未產生傳票)
                    <%  }   %>
                                        </tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>C 應繳金額</td>
                                        <td  bgcolor=ffffff colspan=2> <%
                                            if (sinfo.getReceived()==0)
                                                out.println(mnf.format(sinfo.getReceivable())+" 元");
                                            else
                                                out.println(mnf.format(sinfo.getReceivable()-sinfo.getReceived()) + " 元 (" + sinfo.getReceivable() + " - " + sinfo.getReceived() + ")");
                                     %></tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>D 繳費截止日期</td>
                                        <td bgcolor=ffffff><%=sdf.format(sinfo.getMyBillDate())%></tD>
                                        <td  bgcolor=ffffff rowspan=2 valign=middle align=middle>
                                        <% if (sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) { %> 

<%
    if(checkAuth(ud2,authHa,102)){
%>
                                            <a href="javascript:openwindow_phm('bill_modify.jsp?rid=<%=billRecordId%>&sid=<%=membrId%>','修改繳費截止日期和備註',500,300,true)"><img src="pic/fix.gif" border=0  align=texttop width=12> 修改截止日和備註</a>
                                        <%  }   %>
<%  }   %>
                                        </td>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>E 備註</td>
                                        <td bgcolor=ffffff><%=comment%></tD>
                                    </tR>
                                </table>
                                </td>
                                </tr>
                                </table>
                                </center>
                                &nbsp;&nbsp;　&nbsp;<a target=_blank href="mca_preview_defered.jsp?tid=<%=sinfo.getTicketId()%>">Preview Deferred Plan</a>
　　　　
                                <a target=_blank href="test/test30.jsp?tid=<%=sinfo.getTicketId()%>">.</a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2>

                <br>
                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>F 收費項目</b>&nbsp;&nbsp;&nbsp;
<% 
    if (sinfo.getPaidStatus()!=MembrBillRecord.STATUS_NOT_PAID) {

        if(checkAuth(ud2,authHa,102) && !force) {
%>
            已有繳費記錄，強制修改 <a href="javascript:do_force();">請按此</a>(5分鐘內)
<%
        }

    } else if (locked) {
        
        out.println("( <img src='images/lockno.gif' width=16 height=16 align=top>鎖定中,");
    
        if(checkAuth(ud2,authHa,102)){
%>
            欲修改請先&nbsp;<a href='javascript:reset_lock()'>解除鎖定</a>
<%
        }else{
%>
            由於權限不足,無法解除鎖定.
<%
        }
        out.println(" )");
    }
%> </div>
                <center>
                

                <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                    <td>項目</td>
                    <td align=right>金額</td>
                    <TD align=right>調整</td>
                    <td align=right>應收金額</TD>
                    <TD align=middle>登入人</td>
                    <td></td>
                </tr> 
                <% 
                    int subtotal_1=0, subtotal_2=0;
                    Iterator<ChargeItemMembr> iter = items.iterator();
                    boolean outsourcing = (PaySystem2Mgr.getInstance().find("id=1").getWorkflow()==2);

                    while (iter.hasNext()) {
                        ChargeItemMembr item = iter.next();
                        ArrayList<FeeDetail> vfees = feeMap.get(item.getChargeKey());
                        Iterator<Discount> diter = dmgr.retrieveList("chargeItemId=" + 
                            item.getChargeItemId() + " and membrId=" + item.getMembrId(), "").iterator();
                        int discountAmount = 0;
                        subtotal_1 += item.getMyAmount();
                        while (diter.hasNext()) {
                            Discount dc = diter.next();
                            subtotal_2 += dc.getAmount();
                            discountAmount += dc.getAmount();
                        }
                        String dstr = mnf.format(0-discountAmount);
                        FeeDetailHandler fdhander = new FeeDetailHandler(vfees, outsourcing);

                        // 是否要加上修改減免的 add.gif
                        if ((!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID) || force) {
                            dstr += "(<a href=\"javascript:openwindow_phm('billdiscount_list.jsp?cid="+item.getChargeItemId()+"&sid="+item.getMembrId()+"','調整',500,350,true);\"><img src='pic/fix.gif' border=0 width=12> 編輯</a>)";
                        }
                        else if (discountAmount>0) {
                            dstr += " <a href=\"javascript:openwindow_phm('billdiscount_list.jsp?cid="+item.getChargeItemId()+"&sid="+item.getMembrId()+"&ro=1','調整',500,350,true);\"><img src='pic/fix.gif' border=0 width=12></a>";
                        }
                        boolean isIntrBase = (item.getCopyStatus()==BillItem.COPY_YES);
                %>
                <tr bgcolor=#ffffff class=es02>
                    <td nowrap>
                    <% if (isIntrBase) { %>
                        <img src="img/flag2.png" border=0>
                    <% } else { %>
                        　
                    <% } %>
                       &nbsp; <%=item.getChargeName()%>
                    </td>
                    <td align=right nowrap><%=mnf.format(item.getMyAmount())%>
                    <% if (!mca.McaService.isSystemCharge(item.getChargeName())) { %>
                        <% if ((!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID) || force) {
                             if (vfees==null) { %> 
                                (<a href="javascript:openwindow_phm('billcharge_modify.jsp?cid=<%=item.getChargeItemId()%>&sid=<%=item.getMembrId()%>','修改收費項目',500,400,true)"><img src='pic/fix.gif' border=0 width=12> 編輯</a>)
                        <%   } else { %>
                                (<a href="javascript:openwindow_phm('feedetail_list.jsp?cid=<%=item.getChargeItemId()%>&sid=<%=item.getMembrId()%>','修改收費項目',500,400,true)"><img src='pic/redfix.png' border=0 width=7> 編輯</a>)
                        <%   } 
                           } else { 
                             if (vfees==null) { %> 
                                <a href="javascript:openwindow_phm('billcharge_modify.jsp?cid=<%=item.getChargeItemId()%>&sid=<%=item.getMembrId()%>&ro=1','查看收費項目',500,400,true)"><img src='pic/fix.gif' border=0 width=12></a>
                        <%   }    
                           } %>
                    <% } else { 
                             if (vfees==null) { %> 
                                <a href="javascript:openwindow_phm('billcharge_modify.jsp?cid=<%=item.getChargeItemId()%>&sid=<%=item.getMembrId()%>&ro=1','查看收費項目',500,400,true)"><img src='pic/fix.gif' border=0 width=12></a>
                    <%       }    
                       } %>
                    </td>
                    <td align=right width=110><%=dstr%></td>
                    <td align=right width=80><%=mnf.format(item.getMyAmount() - discountAmount)%></td>
                    <td align=middle><%=getUserName(item.getUserLoginId(), userMap)%></td>
                    <td align=right>

<%
        if(checkAuth(ud2,authHa,102)){
            if (!mca.McaService.isSystemCharge(item.getChargeName())) {
%>
                        <% if (((!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID)||force) 
                                && !fdhander.hasOutsourcingEntries()) {%> 
                            <a href="javascript:delete_item(<%=item.getChargeItemId()%>,<%=item.getMembrId()%>,'<%=phm.util.TextUtil.escapeJSString(item.getChargeName())%>');">刪除</a>
                        <%}%>        
<%          }   
        }%>
                    </td>
                </tr>              
                <%  
                        if (vfees!=null) { 
                            for (int i=0; i<vfees.size(); i++) { 
                                FeeDetail fd = vfees.get(i); %>
                <tr bgcolor=#ffffff class=es02>
                    <td colspan=6 nowrap><img src=images/spacer.gif width=80 height=1>
                        <%=sdf.format(fd.getFeeTime())%><img src=images/spacer.gif width=30 height=1>
                        單價 <%=mnf.format(fd.getUnitPrice())%> x 數量 <%= fd.getNum()%> = <%=mnf.format(fd.getUnitPrice()*fd.getNum())%>
                        <%=fdhander.getNote(fd) %>
                    </td>
                </tr>           
                        <%  }
                        }
                    }
                    String dstr = (subtotal_2>0)?"(" + mnf.format(subtotal_2) + ")":"";
                    if((!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID)||force) {

                        if(checkAuth(ud2,authHa,102)){
                %>
                <tr bgcolor=ffffff class=es02>
                    <td colspan=6 height=25 valign=center>
                <% if (outsourcing) { %>
                    <a href="javascript:openwindow_phm('billcharge_add_adv.jsp?brid=<%=sinfo.getBillRecordId()%>&sid=<%=sinfo.getMembrId()%>','新增收費項目',600,400,true)"><img src="pic/add.gif" border=0 width=12>&nbsp;新增收費項目</a></td>
                <% } else { %>
                    <a href="javascript:openwindow_phm('billcharge_add.jsp?brid=<%=sinfo.getBillRecordId()%>&sid=<%=sinfo.getMembrId()%>','新增收費項目',600,400,true)"><img src="pic/add.gif" border=0 width=12>&nbsp;新增收費項目</a></td>
                <% } %>
                </tr>
                <%      } 
                    }                        
                %>
                <tr bgcolor="#f0f0f0" class=es02>
                    <td align=middle><b>小 計</b></td>
                    <td align=right><%=mnf.format(subtotal_1)%></td>
                    <td align=right><%=dstr%></td>
                    <td align=right><b><%=mnf.format(subtotal_1-subtotal_2)%></b></td>   
                    <td colspan=2></td> 
                </tr>
                </table>
                </td>
                </tr>
                </table>
                </center>
                <br>
                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>繳費狀況 </b></div>
                    <center>
                    <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                        <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td width=16% align=middle>
                                帳單金額
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                            <%
                                McaInterest mi = new McaInterest(0);                            
                                mi.setup(sinfo);
                                int autoAmt = mi.getAutoGeneratedLateFeeInterest(sinfo.getTicketId());
                                int orgAmount = sinfo.getReceivable() - autoAmt;
                                out.println(mnf.format(orgAmount));
                            %>
                            </td>
                            <td  width=16% align=middle>
                                Defer/Intr.Base
                            </td>    
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=mnf.format(mi.getBaseWithoutLatefee(sinfo))%>
                            </td>
                            <td  width=16% align=middle nowrap>
                                ##Late&Intr.
                            </td>    
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=mnf.format(autoAmt)%>
                            </td>
                        </tr>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td  width=16% align=middle>
                                Total
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=mnf.format(sinfo.getReceivable())%>
                            </td>
                            <td  width=16% align=middle>
                                Paid
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=mnf.format(sinfo.getReceived())%>
                            </td>
                            <td align=middle>
                                Remain
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=mnf.format(sinfo.getReceivable()-sinfo.getReceived())%>
                            </td>
                        </tr>
                    </table>
                        </td>
                        </tr>
                        </table>
                    </center>

                    <br>
                     <% 
                ArrayList<BillPaidInfo> paidrecords = BillPaidInfoMgr.getInstance().
                    retrieveList("billpaid.ticketId='" + sinfo.getTicketId() + "' and billpay.membrId>0 and billpaid.amount>0", "");
                if (paidrecords.size()>0) {
            %>
            <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>繳費記錄</b></div>
            <center>
            <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="<%=active_color%>">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr class=es02 bgcolor=f0f0f0>
                        <td></td>
                        <td class=es02 align=middle>登入時間</td>
                        <td class=es02 align=middle>繳費時間</td>
                        <td class=es02 align=middle>付款方式</td>
                        <td class=es02 align=middle>金額</td>
                        <td class=es02 align=middle>登入人</td>
                        <td class=es02></td>
                    </tr>
            <%

                    Iterator<BillPaidInfo> iter2 = paidrecords.iterator();
                    while (iter2.hasNext()) {
                        BillPaidInfo bp = iter2.next();
                        String userId = bp.getUserLoginId();
                        if (userId==null) {
                            userId = "系統";
                        }
                        String via = null;
                        if (bp.getVia()==BillPay.VIA_ATM) via = "ATM轉帳";
                        else if (bp.getVia()==BillPay.VIA_STORE) via = "便利商店繳款";
                        else if (bp.getVia()==BillPay.VIA_CHECK) via = "支票繳款";
                        else if (bp.getVia()==BillPay.VIA_WIRE) via = "銀行轉帳繳款";
                        else if (bp.getVia()==BillPay.VIA_CREDITCARD) via = "信用卡繳款";
                        else via = "臨櫃繳款";
            %>
                    <tr bgcolor=#ffffff align=left valign=middle class=es02>	
                        <td align=middle><img src="images/lockfinish.gif" border=0 width=15></td>
                        <td><%=sdf.format(bp.getCreateTime())%></td>
                        <td><%=sdf.format(bp.getPaidTime())%></td>
                        <td align=left><%=via%></td>
                        <td align=right><%=mnf.format(bp.getPaidAmount())%><%=(bp.getPending()==1)?"<br><a href='query_cheque.jsp'>(未兌現)</a> ":""%></td>
                        <td align=middle><%=(bp.getUserLoginId()==null)?userId:getUserName(userId, userMap)%></td>
                        <td align=right nowrap>
                            <a href="javascript:openwindow_phm('pay_info.jsp?sid=<%=membrId%>','繳費歷史',800,500,true);">詳細資料</a>
                        | <a href="javascript:openwindow_phm('membrbillrecord_refund.jsp?pid=<%=bp.getBillPayId()%>&tid=<%=sinfo.getTicketId()%>','轉至個人帳戶',400,300,true)">轉至個人帳戶</a>
                        | <a href="javascript:print_receipt(<%=bp.getBillPayId()%>, '<%=sinfo.getTicketId()%>')">印收據</a>
                        </td>
                    </tr>
            <%      }%>
                    </table>
                </td>
                </tr>
            </table>
            <%  } %>
            </center>


            </td>
            </tr>
            </table>

        <tr>
            <td colspan=5></td>
        </tr>
    </table>

    </td>
    <td></td>
</tr>
<tr width=100%>
    <td background="img/a<%=active_status?"2":"1"%>_21.gif" width=9 height=9></td>
    <td bgcolor="<%=active_color%>"><img src="img/aspace.gif" border=0></td>
    <tD width=9 height=9 background="img/a<%=active_status?"2":"1"%>_22.gif"></td>
</tr>
</table>
            
</td>
</tr>
</table>
            <br>
<form name="f1" action="membrbillrecord_delete.jsp">
<input type=hidden name="tid" value="<%=sinfo.getTicketId()%>">
<% String delete_backurl = "bill_detail2.jsp?poId=-1&" + request.getQueryString(); %>
<input type=hidden name="backurl" value="<%=delete_backurl%>">
</form>
<form name="f2" action="membrbillrecord_refund.jsp">
<input type=hidden name="tid" value="<%=sinfo.getTicketId()%>">
<input type=hidden name="pid" value="">
<input type=hidden name="backurl" value="<%=myurl%>">
</form>


<%!
    public String getUserName(String uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(uid);
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }

    public String genDeferOnclick(MembrBillRecord bill)
    {
        if (bill.getPrintDate()==0 && bill.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID) {
            return "onclick=\"openwindow_phm2('mca_setup_deferred.jsp?ticketId=" + bill.getTicketId()+ "','Deferred Plan Setup',200,250, 'deferwin');\""; 
        }
        return "onclick=\"alert('bill locked or paid, cannot change')\"";
    }
%>