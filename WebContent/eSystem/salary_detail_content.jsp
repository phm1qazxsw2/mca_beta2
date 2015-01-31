<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<%
    if(!checkAuth(ud2,authHa,300))
    {
        response.sendRedirect("authIndex.jsp?code=300");
    }
%>
<%
    //##v2

    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    String backurl = request.getParameter("backurl");
    String myurl = "salary_detail.jsp?" + request.getQueryString();
    int membrId = Integer.parseInt(request.getParameter("sid"));
    int billRecordId = Integer.parseInt(request.getParameter("rid"));

    MembrInfoBillRecordMgr mibrmgr = MembrInfoBillRecordMgr.getInstance();
    MembrInfoBillRecord sinfo = mibrmgr.find("membrId=" + membrId + 
        " and billRecordId=" + billRecordId + " and billType=" + Bill.TYPE_SALARY +
        " and privLevel>=" + ud2.getUserRole());

    if (sinfo==null) {
        out.println("<br><br><blockquote>這筆資料不存在，可能已經被刪除了.</blockquote>");
        return;
    }

    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    ArrayList<ChargeItemMembr> items = cismgr.retrieveList(
        "charge.membrId=" + membrId + " and chargeitem.billRecordId=" + billRecordId, "");

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
    String title = sdf3.format(sinfo.getBillMonth()) + " " + sinfo.getMembrName() + " " +sinfo.getBillPrettyName();


    boolean active_status=(sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID);
    String active_color = (active_status)?"F77510":"4A7DBD";
    
    boolean locked = (sinfo.getPrintDate()>0);
    ArrayList<MembrInfoBillRecord> all_bills = mibrmgr.retrieveList("membrId=" + membrId, "order by billrecord.id desc");

    Object[] users2 = UserMgr.getInstance().retrieve("", "");
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getUserLoginId");


    int account_remain = (int)0;
    ArrayList<BillPay> payhistory = BillPayMgr.getInstance().
        retrieveList("membrId=" + membrId + " and remain>0", "");
    Iterator<BillPay> iter4 = payhistory.iterator();
    while (iter4.hasNext())
        account_remain += iter4.next().getRemain();
%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script language="JavaScript" src="js/in.js"></script>
<script type="text/javascript" src="js/show_voucher.js"></script>
<script type="text/javascript" src="js/bill.js"></script>
<script>
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
    if (!confirm("退費會先把金額加入帳戶餘額，該餘額可用來銷其他單據或進行實際退款動作，繼續？"))
        return;
    f2.pid.value = payid;
    document.f2.submit();
}

function pay_salary()
{
    var backurl = "salary_detail.jsp?<%=request.getQueryString()%>";
    var o = "<%=membrId%>#<%=billRecordId%>";
    var t = "<%=title%>";
    var via = <%=BillPay.SALARY_CASH%>;
    var url = "salary_batchpay.jsp?via=" + via + "&o=" + encodeURIComponent(o) + "&p=1&t=" + encodeURIComponent(t) + "&backurl=" + encodeURIComponent(backurl);
    location.href = url;
}
</script>
<br>

<%
%>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;薪資明細 -- <%=title%></b>&nbsp;&nbsp;&nbsp;&nbsp;

<%
    if(pageType==0){
%>

<a href="<%=backurl%>"><img src="pic/last2.png" border=0>&nbsp;回上一頁</a>
<%  }   %>
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
        boolean outsourcing = (PaySystem2Mgr.getInstance().find("id=1").getWorkflow()==2);
        Iterator<MembrInfoBillRecord> iter3 = all_bills.iterator();
        int unpaid_total =0;
        StringBuffer pay_sb = new StringBuffer();
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
            if ((binfo.getReceivable() - binfo.getReceived())>0) {
                if (pay_sb.length()>0) pay_sb.append(',');
                pay_sb.append(binfo.getMembrId() + "#" + binfo.getBillRecordId());
            }
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
                <td bgcolor="<%=color%>" width=100% height=25 valign=center class=es02>&nbsp;<a href="<%=(pageType==0)?"salary_detail":"salary_detail_express"%>.jsp?sid=<%=membrId%>&rid=<%=binfo.getBillRecordId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>"><font color="<%=isActive?"ffffff":"5F5F5F"%>"><%=binfo.getBillRecordName()%></font></a></td>
            </tr>
    <%
        }
        
        int reportId=0;

        if(pageType==0){
    %>
        <%@ include file="salarydetail_menu.jsp"%>
    <%  }   %>
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
                    <td>
                        <font color=ffffff>&nbsp;&nbsp;&nbsp;姓名: <%=sinfo.getMembrName()%></font>
                    </td>
                    <td>
                        <font color=ffffff>(
                        付款狀態:
                        <% 
                        if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID) out.println("<b>已付</b>");
                        else if (sinfo.getPaidStatus()==MembrBillRecord.STATUS_PARTLY_PAID) out.println("<b>部分付款</b>");
                        else out.println("尚未付款");
                        %>
                        )
                        </font>
                    </td>
                    <td width=250>

                    </tD>
                    </tr>
                    <tr>
                        <form action="print_salaryslip.jsp" method="post" target="_blank">
                        <td>    
                            <input type=submit value="列印薪資條">
                        </td>
                            <input type=hidden name="tid" value="<%=sinfo.getTicketId()%>">
                        </form>
                        <td colspan=2>                    

        <%  if(checkAuth(ud2,authHa,302)){   %>
                <% if (sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) { %>
                    <% if ((sinfo.getReceivable()-sinfo.getReceived())>0) { %>
                        <input type=button onclick="javascript:pay_salary();" value="櫃臺發放">
                    <% } else { %>
                        <input type=button onclick="location.href='membrbillrecord_markpaid.jsp?rid=<%=billRecordId%>&sid=<%=membrId%>&backurl=<%=java.net.URLEncoder.encode(myurl)%>'" value="設為已付">
                    <% } %>
                <% } %>
        <%  }   %>            
                    </td>

                <% if (!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID && checkAuth(ud2,authHa,301)) { %>
                    <td align=right><input type=button value="刪除薪資" onclick="do_delete();"></td>
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
                                    <img src="pic/salaryDetail.gif" border=0>
                                </center>
                            </td>
                            <td valign=top>
                                <br>
                                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>薪資資訊</b></div> 

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
                                        <td>B 薪資流水號</td>
                                        <td  bgcolor=ffffff colspan=2><%=sinfo.getTicketId()%></tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>C 應付金額</td>
                                        <td  bgcolor=ffffff colspan=2> <%
                                            if (sinfo.getReceived()==0)
                                                out.println(mnf.format(sinfo.getReceivable())+" 元");
                                            else
                                                out.println(mnf.format((sinfo.getReceivable()-sinfo.getReceived())) + " 元 (" + mnf.format(sinfo.getReceivable()) + " - " + mnf.format(sinfo.getReceived()) + ")");
                                     %></tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>D 備註</td>
                                        <td bgcolor=ffffff width=50%><%=(comment.length()<=0)?"(無)":comment%></tD>
                                        <td  bgcolor=ffffff valign=middle align=middle>
        <%  if(checkAuth(ud2,authHa,301)){   %>
                                        <% if (sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) { %> 
                                            <a href="javascript:openwindow_phm('salary_modify.jsp?rid=<%=billRecordId%>&sid=<%=membrId%>','修改付款日期和備註',500,300,true)"><img src="pic/fix.gif" border=0  align=texttop> 修改備註</a>
                                        <%  }   %>
        <%  }   %>
                                        </td>
                                    </tR>
                                </table>
                                </td>
                                </tr>
                                </table>
                                </center>
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2>

                <br>
                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>E 薪資明細</b>&nbsp;&nbsp;&nbsp;<%=(locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID)?"( <img src='images/lockno.gif' width=16 height=16 align=top>鎖定中, 欲修改請先&nbsp;<a href='javascript:reset_lock()'>解除鎖定</a> )":""%> </div>
                <center>
                

                <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    
                <% 
            int subtotal_1=0;
            Map<Integer, Vector<ChargeItemMembr>> chiMap = new SortingMap(items).doSort("getSmallItemId");
            Set chikey = chiMap.keySet();
            Iterator<Integer> chiiter = chikey.iterator();
            while (chiiter.hasNext()) {
                Integer ciId = chiiter.next();
                Vector<ChargeItemMembr> chv = chiMap.get(ciId);
        %>
            <tr>
                <td colspan=4 bgcolor=4A7DBD>
                </tD>
            </tr> 
            <tr bgcolor=f0f0f0 class=es02>
                <td width=45% class=es02>
                    <font color=black><b>
                    <%
                        switch(ciId){
                            case BillItem.SALARY_PAY:
                                out.println("+ 應付薪資");                            
                                break;
                            case BillItem.SALARY_DEDUCT1:
                                out.println("- 代扣薪資");
                                break;
                            case BillItem.SALARY_DEDUCT2:
                                out.println("- 應扣薪資");
                                break;
                            default:
                                out.println(ciId);        
                        }
                    %>
                    </b></font>
                </td>
                 <td width=30% align=middle>金額</td>
                 <TD width=15% align=middle>登入人</td>
                 <td width=10%></td>
            </tr>
        <%
            for(int k=0;chv !=null &&k<chv.size();k++)
            {
                ChargeItemMembr item =(ChargeItemMembr)chv.get(k);
                ArrayList<FeeDetail> vfees = feeMap.get(item.getChargeKey());
                FeeDetailHandler fdhander = new FeeDetailHandler(vfees, outsourcing);

                subtotal_1 += item.getMyAmount();
                        // 是否要加上修改減免的 add.gif
                %>
                <tr bgcolor=#ffffff class=es02>
                    <td><img src="img/flag2.png" border=0>&nbsp;<%=item.getChargeName()%>            
                    </td>
                    <td align=right>



<%=(item.getMyAmount()<0)?"("+mnf.format(Math.abs(item.getMyAmount()))+")":mnf.format(item.getMyAmount())%>
        <%  if(checkAuth(ud2,authHa,301)){   %>

                        <% if (!locked && sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID && !fdhander.hasOutsourcingEntries())    {
                              if (vfees==null) {%> 
                            (<a href="javascript:openwindow_phm('salarycharge_modify.jsp?cid=<%=item.getChargeItemId()%>&sid=<%=item.getMembrId()%>','修改薪資明細',500,300,true)"><img src='pic/fix.gif' border=0 width=8> 修改</a>)
                           <% } else { %>
                            (<a href="javascript:openwindow_phm('salaryfeedetail_list.jsp?cid=<%=item.getChargeItemId()%>&sid=<%=item.getMembrId()%>','修改薪資明細',500,300,true)"><img src='pic/fix.gif' border=0 width=8> 修改</a>)
                           <% }
                          }%>        
        <%  }   %>

                    </td>
                    <td align=middle><%=getUserName(item.getUserLoginId(), userMap)%></td>
                    <td align=right>
        <%  if(checkAuth(ud2,authHa,301)){   %>

                        <% if (!locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID && !fdhander.hasOutsourcingEntries()) {%> 
                            <a href="javascript:delete_item(<%=item.getChargeItemId()%>,<%=item.getMembrId()%>,'<%=phm.util.TextUtil.escapeJSString(item.getChargeName())%>');">刪除</a>
        <% }    %>     
                        <%}%>        
                    </td>
                </tr>              
            <%  
                if (vfees!=null) { 
                    for (int i=0; i<vfees.size(); i++) { 
                        FeeDetail fd = vfees.get(i); %>
                <tr bgcolor=#ffffff class=es02>
                    <td colspan=6 nowrap><img src=images/spacer.gif width=80 height=1>
                        <%=sdf.format(fd.getFeeTime())%><img src=images/spacer.gif width=30 height=1>
                        單價 <%=(fd.getUnitPrice()<0)?"("+mnf.format(Math.abs(fd.getUnitPrice()))+")":mnf.format(fd.getUnitPrice())%> x 數量 <%= fd.getNum()%> = <%=(fd.getUnitPrice()<0)?"("+mnf.format(Math.abs(fd.getUnitPrice()*fd.getNum()))+")":mnf.format(fd.getUnitPrice()*fd.getNum())%>
                        <%=fdhander.getSalaryNote(fd) %>
                    </td>
                </tr>           
            <%      }
                }
            }
            
        }
        
        if(checkAuth(ud2,authHa,301)){

            if(!locked && sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) {
                %>
                <tr bgcolor=ffffff class=es02>
                    <td colspan=6 height=25 valign=center>

<a href="javascript:openwindow_phm('salarycharge_add.jsp?brid=<%=sinfo.getBillRecordId()%>&sid=<%=sinfo.getMembrId()%>','新增收費項目',500,350,true)"><img src="pic/add.gif" border=0 width=8>&nbsp;新增薪資項目</a>
        <%  }   %>            
                    </td>
                </tr>
        <%  } %>
                <tr bgcolor="#f0f0f0" class=es02>
                    <td align=middle><b>小 計</b></td>
                    <td align=right><b><%=(subtotal_1<0)?"("+mnf.format(Math.abs(subtotal_1))+")":mnf.format(subtotal_1)%></b></td>
                    <td colspan=2></td> 
                </tr>
                </table>
                </td>
                </tr>
                </table>
                </center>
                <br>
                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>付款 </b></div>
                    <center>
                    <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                        <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td width=16% align=middle>
                                應付金額:
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=(sinfo.getReceivable()<0)?"("+mnf.format(Math.abs(sinfo.getReceivable()))+")":mnf.format(sinfo.getReceivable())%>
                            </td>
                            <td  width=16% align=middle>
                                已付金額:
                            </td>    
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=mnf.format(sinfo.getReceived())%>
                            </td>
                            <td  width=16% align=middle>
                                <b>需付金額:</b>
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
        
                    <br>
                     <% 
                ArrayList<BillPaidInfo> paidrecords = BillPaidInfoMgr.getInstance().
                    retrieveList("billpaid.ticketId='" + sinfo.getTicketId() + 
                    "' and via>=100", "");
                if (paidrecords.size()>0) {
            %>
            <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>付款記錄</b></div>
            <center>
            <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#F77510">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr class=es02 bgcolor=f0f0f0>
                        <td></td>
                        <td class=es02 align=middle>付款時間</td>
                        <td class=es02 align=middle>方式</td>
                        <td class=es02 align=middle>金額</td>
                        <td class=es02 align=middle>登入人</td>
                        <td class=es02></td>
                        <!--<td class=es02></td>-->
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
                        if (bp.getVia()==BillPay.SALARY_CASH) via = "現金";
                        else if (bp.getVia()==BillPay.SALARY_WIRE) via = "匯款";
                        else if (bp.getVia()==BillPay.SALARY_CHECK) via = "支票";
                        else via = "其他";
            %>
                    <tr bgcolor=#ffffff align=left valign=middle class=es02>	
                        <td align=middle><img src="images/lockfinish.gif" border=0 width=15></td>
                        <td><%=(bp.getPaidTime()!=null)?sdf.format(bp.getPaidTime()):""%></td>
                        <td align=left><%=via%></td>
                        <td align=right><%=mnf.format(bp.getPaidAmount())%></td>
                        <td align=right><%=userId%></td>
                        <td align=right>
                            <a href="javascript:openwindow_phm('salary_paydetail.jsp?pid=<%=bp.getBillPayId()%>','薪資支付歷史',800,500,false);">詳細資料</a>
                        </td>	
                        <!--<td align=right><a href="javascript:do_refund(<%=bp.getBillPayId()%>)">退至餘額帳戶</a></td>-->
                    </tr>
            <%      }%>
                    </table>
                </td>
                </tr>
            </table>
            <%  } %>
            </center>
                
        <%  if (sinfo.getThreadId()>0) { %>
            <br>
            <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <a href="javascript:show_bill_vouchers('<%=sinfo.getTicketId()%>', <%=sinfo.getThreadId()%>)">相關傳票內容</a></div>
        <%  } %>
            <br>
            <br>  

            </td>
            </tr>
            </table>
            <br>
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

<form name="f1" action="salarybillrecord_delete.jsp">
<% String delete_backurl = "salary_detail2.jsp?poId=-1&" + request.getQueryString(); %>
<input type=hidden name="backurl" value="<%=delete_backurl%>">
<input type=hidden name="tid" value="<%=sinfo.getTicketId()%>">
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

%>