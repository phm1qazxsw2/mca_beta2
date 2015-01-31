<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="../eSystem/style.css" type="text/css">
<%@ include file="topMenuAdvanced.jsp"%>
<%
    int membrId =12; 
    String sidS=request.getParameter("sid");
    if(sidS!=null)
        membrId=Integer.parseInt(sidS);

    int billRecordId =48; // Integer.parseInt(request.getParameter("rid"));
    String ridS=request.getParameter("rid");
    if(ridS!=null)
        billRecordId=Integer.parseInt(ridS);
    MembrInfoBillRecordMgr mibrmgr = MembrInfoBillRecordMgr.getInstance();
    MembrInfoBillRecord sinfo = mibrmgr.find("membrId=" + membrId + " and billRecordId=" + billRecordId);
    if (sinfo==null) {
        out.println("<br><br><blockquote>這筆資料不存在，可能已經被刪除了.</blockquote>");
        return;
    }
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    ArrayList<ChargeItemMembr> items = cismgr.retrieveList(
        "charge.membrId=" + membrId + " and chargeitem.billRecordId=" + billRecordId, "");

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");    
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yy年MM月");    
    DiscountMgr dmgr = DiscountMgr.getInstance();

    BillCommentMgr bmgr = BillCommentMgr.getInstance();
    BillComment bc = bmgr.find("membrId=" + membrId + " and billRecordId=" + billRecordId);
    String comment = (bc==null)?"":bc.getComment();

    String billprintstr = sinfo.getMembrId() + "#" + sinfo.getBillRecordId();
    String title = sinfo.getMembrName() + " " +sinfo.getBillPrettyName();

    boolean active_status=(sinfo.getPaidStatus()==MembrBillRecord.STATUS_FULLY_PAID);
    String active_color = (active_status)?"F77510":"4A7DBD";
    
    boolean locked = (sinfo.getPrintDate()>0);
    ArrayList<MembrInfoBillRecord> all_bills = mibrmgr.retrieveList("membrId=" + membrId, "order by billrecord.id desc");

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
</script>
<br>

<b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;帳單查詢</b>


<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<center>


<table cellpadding=0 cellspacing=0 border=0 width=800 height=700>
<tr>
    <td valign=top>


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
                icon = "<img src='../eSystem/pic/lockfinish2.png' width=15 height=15 align=top>";
            else if (lcked) 
                icon = "<img src='../eSystem/pic/lockno2.png' width=15 height=15 align=top>";
            else 
                continue;
            boolean isActive=binfo.getTicketId().equals(sinfo.getTicketId());
            String color = (isActive)?active_color:"white";
            unpaid_total += (binfo.getReceivable() - binfo.getReceived());
          %>
            <tr>
                <%
                    if(isActive)
                    {
                %>
                    <td width=8><img src='../eSystem/img/a<%=active_status?"2":"1"%>_left1.gif' border=0 height=25></td>              
                <%  
                  }else{
                        out.println("<td width=8></td>");
                    }
                %>

                <td bgcolor="<%=color%>"><%=icon%></td>
                <td bgcolor="<%=color%>" width=100% height=25 valign=center class=es02>&nbsp;<a href="bill_detail.jsp?sid=<%=membrId%>&rid=<%=binfo.getBillRecordId()%>"><font color="<%=isActive?"ffffff":"5F5F5F"%>"><%=binfo.getBillRecordName()%></font></a></td>
            </tr>
    <%
        }
        
        int reportId=0;
    %>
    </table>

    </td>
    <td valign=top>
        <table border=0 cellpadding=0 cellspacing=0 width=100% height=9>
        <tr width=100%>
            <td background="../eSystem/img/a<%=active_status?"2":"1"%>_11.gif" width=9 height=9></td>
            <td bgcolor="<%=active_color%>"><img src="../eSystem/img/aspace.gif" border=0></td>
            <tD width=9 height=9 background="../eSystem/img/a<%=active_status?"2":"1"%>_12.gif"></td>
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
                        %>
                        )
                        </font>

    
                    </td>
                    <td width=250>

                    </tD>
                    </tr>
                    <tr>
                    <td colspan=3>
                <% if (sinfo.getPaidStatus()!=MembrBillRecord.STATUS_FULLY_PAID) { %>
                        <input type=button onclick="window.location='billrecord_detail.jsp?o=<%=java.net.URLEncoder.encode(billprintstr)%>&t=<%=java.net.URLEncoder.encode(title,"UTF-8")%>'" value="列印帳單">
        
                //只有鎖定的帳單才會出現及以繳款的帳單才會出現

                <% }    %>

   
                    </td>
               
                    <td></td>
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
                                    <img src="../eSystem/img/billd.gif" border=0>
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
                                        <td  bgcolor=ffffff colspan=2><%=sinfo.getTicketId()%></tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>C 應繳金額</td>
                                        <td  bgcolor=ffffff colspan=2> <%
                                            if (sinfo.getReceived()==0)
                                                out.println(sinfo.getReceivable());
                                            else
                                                out.println((sinfo.getReceivable()-sinfo.getReceived()) + " (" + sinfo.getReceivable() + " - " + sinfo.getReceived() + ")");
                                     %></tD>
                                    </tR>
                                <tr bgcolor=#f0f0f0 class=es02>
                                        <td>D 繳費截止日期</td>
                                        <td bgcolor=ffffff><%=sdf.format(sinfo.getMyBillDate())%></tD>
                                        <td  bgcolor=ffffff rowspan=2 valign=middle align=middle>
                                        
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
                            </td>
                        </tr>
                        <tr>
                            <td colspan=2>

                <br>
                <div class=es02>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b>F 收費項目</b>&nbsp;&nbsp;&nbsp;<%=(locked && sinfo.getPaidStatus()==MembrBillRecord.STATUS_NOT_PAID)?"( <img src='../eSystem/images/lockno.gif' width=16 height=16 align=top>鎖定中, 欲修改請先&nbsp;<a href='javascript:reset_lock()'>解除鎖定</a> )":""%> </div>
                <center>
                

                <table width="93%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                    <td>項目</td>
                    <td align=right>金額</td>
                    <TD align=right>折扣</td>
                    <td align=right>應收金額</TD>
                    <TD align=middle>登入人</td>

                </tr> 
                <% 
                    int subtotal_1=0, subtotal_2=0;
                    Iterator<ChargeItemMembr> iter = items.iterator();
                    while (iter.hasNext()) {
                        ChargeItemMembr item = iter.next();
                        Iterator<Discount> diter = dmgr.retrieveList("chargeItemId=" + 
                            item.getChargeItemId() + " and membrId=" + item.getMembrId(), "").iterator();
                        int discountAmount = 0;
                        subtotal_1 += item.getMyAmount();
                        while (diter.hasNext()) {
                            Discount dc = diter.next();
                            subtotal_2 += dc.getAmount();
                            discountAmount += dc.getAmount();
                        }
                        String dstr = (discountAmount>0)?"("+discountAmount+") ":"";
                        // 是否要加上修改減免的 add.gif
                       
                %>
                <tr bgcolor=#ffffff class=es02>
                    <td width=180><img src="../eSystem/img/flag2.png" border=0>&nbsp;<%=item.getChargeName()%>            
                    </td>
                    <td align=right width=80>
                            <%=item.getMyAmount()%>
                    </td>
                    <td align=right width=80><%=dstr%></td>
                    <td align=right width=80><%=item.getMyAmount() - discountAmount%></td>
                    <td align=middle><%=item.getUserLoginId()%></td>
                </tr>              
                <%
                    }
                    String dstr = (subtotal_2>0)?"(" + subtotal_2 + ")":"";
                %>
                   <tr bgcolor="#f0f0f0" class=es02>
                    <td align=middle><b>小 計</b></td>
                    <td align=right><%=subtotal_1%></td>
                    <td align=right><%=dstr%></td>
                    <td align=right><b><%=subtotal_1-subtotal_2%></b></td>   
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
                                應繳金額:
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=sinfo.getReceivable()%>
                            </td>
                            <td  width=16% align=middle>
                                已繳金額:
                            </td>    
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=sinfo.getReceived()%>
                            </td>
                            <td  width=16% align=middle>
                                <b>需繳金額:</b>
                            </td>
                            <td  width=16% bgcolor=ffffff align=right>
                                <%=sinfo.getReceivable()-sinfo.getReceived()%>
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
                    retrieveList("billpaid.ticketId='" + sinfo.getTicketId() + "'", "");
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
                        <td class=es02 align=middle>繳費時間</td>
                        <td class=es02 align=middle>付款方式</td>
                        <td class=es02 align=middle>金額</td>
                        <td class=es02 align=middle>登入人</td>
                    </tr>
            <%
                    DecimalFormat mnf = new DecimalFormat("###,###,##0");
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
                        else via = "臨櫃繳款";
            %>
                    <tr bgcolor=#ffffff align=left valign=middle class=es02>	
                        <td align=middle><img src="../eSystem/pic/lockfinish2.png" border=0 width=15></td>
                        <td><%=sdf.format(bp.getPaidTime())%></td>
                        <td align=left><%=via%></td>
                        <td align=right><%=mnf.format(bp.getPaidAmount())%></td>
                        <td align=right><%=userId%></td>
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
    <td background="../eSystem/img/a<%=active_status?"2":"1"%>_21.gif" width=9 height=9></td>
    <td bgcolor="<%=active_color%>"><img src="../eSystem/img/aspace.gif" border=0></td>
    <tD width=9 height=9 background="../eSystem/img/a<%=active_status?"2":"1"%>_22.gif"></td>
</tr>
</table>
            
</td>
</tr>
</table>


<%@ include file="bottom.jsp"%>

