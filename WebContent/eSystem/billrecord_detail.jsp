<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td width="100%">
<%
    //##v2
    if(!checkAuth(ud2,authHa,101)){
        response.sendRedirect("authIndex.jsp?code=101");
    }
    String o = request.getParameter("o");
    String t = request.getParameter("t");
    String str = request.getParameter("freshonly");
    boolean freshonly = (str!=null) && str.equals("true");

    if (o==null || o.length()==0) {
        out.println("<ul>沒有預覽資料, <a href='javascript:history.go(-1);'>回上頁</a></ul>");
        return;
    }

    String[] pairs = o.split(",");
    HashMap m1 = new HashMap();
    HashMap m2 = new HashMap();
    StringBuffer sb1 = new StringBuffer();
    StringBuffer sb2 = new StringBuffer();
    for (int i=0;i<pairs.length; i++) {

        String[] tokens = pairs[i].split("#");
        if (m1.get(tokens[0])==null) {
            if (sb1.length()>0) sb1.append(",");
            sb1.append(tokens[0]);
            m1.put(tokens[0], "");
        }
        if (m2.get(tokens[1])==null) {
            if (sb2.length()>0) sb2.append(",");
            sb2.append(tokens[1]);
            m2.put(tokens[1], "");
        }
    }

    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    ArrayList<ChargeItemMembr> items = cismgr.retrieveListX(
        "charge.membrId in (" + sb1.toString() + ")" + 
        " and chargeitem.billRecordId in (" + sb2.toString() + ")", "", 
        _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能印 cover 單位的帳單

    items = new SortingMap(items).descendingBy("getMyAmount");

    Map<String, Vector<ChargeItemMembr>> m = new SortingMap(items).doSort("getTicketId");

    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    String query = "membrbillrecord.membrId in (" + sb1.toString() + ")" + 
        " and membrbillrecord.billRecordId in (" + sb2.toString() + ") and paidStatus in (0,1)" +
        " and receivable>0";
    if (freshonly) 
        query += " and printDate=0";
    ArrayList<MembrInfoBillRecord> records = 
        snbrmgr.retrieveListX(query, "order by membr.name asc", _ws2.getAcrossBillBunitSpace("bill.bunitId"));
        // 要能印 cover 單位的帳單

    String chargeItemIds = new RangeMaker().makeRange(items, "getChargeItemId");
    ArrayList<Discount> all_discounts = DiscountMgr.getInstance().
        retrieveList("chargeItemId in (" + chargeItemIds + ")", "");
    // chargeKey
    Map<String, Vector<Discount>> discountMap = new SortingMap(all_discounts).doSort("getChargeKey");

    ArrayList<FeeDetail> fees = FeeDetailMgr.getInstance().
        retrieveList("chargeItemId in (" + chargeItemIds + ")", "");
    // chargeKey
    Map<String, Vector<FeeDetail>> feeMap = new SortingMap(fees).doSort("getChargeKey");
    String billIds = new RangeMaker().makeRange(records, "getBillId");
    ArrayList<MembrInfoBillRecord> all_unpaid = snbrmgr.retrieveList
        ("bill.id in (" + billIds + ") and paidStatus in (0,1)", "");
    Map<String/*membrId#billId*/, Vector<MembrInfoBillRecord>> unpaidMap = 
        new SortingMap(all_unpaid).doSort("getMembrBillKey");
    
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");    
    DecimalFormat mnf = new DecimalFormat("###,###,##0");

    // 2008/12/31 檢查是否這批帳單有人有餘額可先沖
    boolean hasOverpay = BillPayMgr.getInstance().numOfRows("remain>0 and membrId in (" + sb1.toString() + ")")>0;
%>
<br>

<div class=es02>
&nbsp;&nbsp;&nbsp;    <b>
<% if (t!=null) { %>
 <%= t %> - 
<% } %>
<% if (!freshonly) { %>
    預覽全部
<% } else { %>
    預覽未列印帳單
<% } %>
</b>
</div>


<center>
<table>
    <tr>
<form name=f1 action="print_bill_step1.jsp" method=post>
        <td>

<% if (records.size()>0) { %>
<input type="submit" value="1. 發佈繳款單 ">
<% } %>
<input type="hidden" name="freshonly" value="<%=freshonly%>">
<input type="hidden" name="o" value="<%=o%>">
<% if (t!=null) { %>
<input type="hidden" name="t" value="<%=t%>">
<% } %>

        </td>
    </tR>
    </table>
</form>
</center>

<div class=es02 align=right>
<% if (!freshonly) { %>
    預覽全部 | <a href="javascript:preview_fresh()"><font color=blue>預覽未列印帳單</font> </a>
<% } else { %>
    <a href="javascript:preview_all()"><font color=blue>預覽全部</font></a> | 預覽未列印帳單
<% } %> | <a href="#" onClick="javascript:window.print();"><img src="pic/print.png" border=0>友善列印本頁</a>

</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

   
<%

    if (records.size()==0) {

%>
    <blockquote>
        <div class=es02><b>沒有資料!</b></div>
    </blockquote>

    <script>
        function preview_fresh()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "true";
            f.submit();
        }
        function preview_all()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "false";
            f.submit();
        }
    </script>
<%
        return;
    }            
%> 
<div class=es02 align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;合計: <%= records.size() %>筆&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
<center>
<table width="70%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
            <td>姓名</td>
            <td>帳單流水號</td>
            <td width=220>應付金額</td>
            <td width=335>
                <table width=100% border="0" cellpadding="0" cellspacing="0">
                <tr class=es02>
                    <tD align=middle width=135 nowrap>收費項目</td>        
                    <td align=middle width=50 nowrap>開單金額</td>
                    <TD align=middle width=50 nowrap>調整金額</td>
                    <td align=middle width=50 nowrap>應收金額</TD>
                    <TD align=middle width=50 nowrap>登入人</td>
                </tr> 
                </table>
            </td>
        </tr>

<%
    DiscountMgr dmgr = DiscountMgr.getInstance();
    Iterator<MembrInfoBillRecord> iter2 = records.iterator();
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");
    while (iter2.hasNext()) {
        MembrInfoBillRecord sinfo = iter2.next();
        Vector v = (Vector) m.get(sinfo.getTicketId());
%>
<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02 align=left valign=middle width=80>
                <%=sinfo.getMembrName()%>
            </td>
            <td class=es02 align=left valign=middle>
                流水號:<a href="bill_detail.jsp?sid=<%=sinfo.getMembrId()%>&rid=<%=sinfo.getBillRecordId()%>&backurl=billrecord_detail.jsp"><font color=blue><%=sinfo.getTicketId()%></font></a><br>
                繳費截止日期:<%=sdf.format(sinfo.getMyBillDate())%><br>
            </tD>
            <%      
                int nowTotalX=sinfo.getReceivable()-sinfo.getReceived();
                int unpaidAmount = 0;
                Date now = new Date();
                Vector<MembrInfoBillRecord> unpaid = unpaidMap.get(sinfo.getMembrId()+"#"+sinfo.getBillId());
                if (unpaid!=null && unpaid.size()>0) {
                    for (int i=0; i<unpaid.size(); i++) {
                        MembrInfoBillRecord mib = unpaid.get(i);
                        if (mib.getMyBillDate().compareTo(now)<0 && mib.getTicketId().compareTo(sinfo.getTicketId())<0) {
                            unpaidAmount += (mib.getReceivable()-mib.getReceived());
                        }
                    }
                }
            %>
            <td width=220 valign=middle bgcolor=<%=(nowTotalX>0)?"4A7DBD":"F77510"%>>
                  <table width="100%" height="" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width=100% class=es02 nowrap>
                               <font color=white>
                                應收：<%=sinfo.getReceivable()%> - 已付：<%=sinfo.getReceived()%>
                                <% if (unpaidAmount>0) { 
                                       nowTotalX += unpaidAmount; %>
                                + 前期未繳:<%=unpaidAmount%>
                                <% } %>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td width=100% class=es02>
                               <a href="bill_detail.jsp?sid=<%=sinfo.getMembrId()%>&rid=<%=sinfo.getBillRecordId()%>&backurl=billrecord_detail.jsp">
                            <font color=white>

                            <%  if(nowTotalX >0){   %>
                            =未付金額：<%=mnf.format(nowTotalX)%>
                            <%  }else{  %>
                            =已繳清
                            <%  }   %>
                            </font></a>
                            </td>
                        </tr>
                    </table>
            </tD>
            <tD width=335  class=es02 >
                <table border=0 width=100% class=es02>
                    <% 
                        double subtotal_1=0, subtotal_2=0;
                        for (int j=0; v!=null&&j<v.size(); j++) {
                            ChargeItemMembr item = (ChargeItemMembr) v.get(j);
                            Vector<Discount> discounts = discountMap.get(item.getChargeKey());
                            int discountAmount = 0;
                            for (int i=0; discounts!=null && i<discounts.size(); i++) {
                                Discount d = discounts.get(i);
                                subtotal_2 += d.getAmount();
                                discountAmount += d.getAmount();
                            }
                            subtotal_1 += item.getMyAmount();
                    %>
                    <tr class=es02>
                        <td nowrap width=135>
                            <img src="img/flag2.png" border=0>&nbsp;<%=item.getChargeName()%><% 
                                Vector<FeeDetail> fv = feeMap.get(item.getChargeKey());
                                for (int i=0; fv!=null && i<fv.size(); i++) {
                                    FeeDetail fd = fv.get(i);                                   
                                    out.println("<br>&nbsp;&nbsp;&nbsp;" + sdf2.format(fd.getFeeTime()) + " " + fd.getUnitPrice() + "x" + fd.getNum() + "=" + mnf.format(fd.getUnitPrice() * fd.getNum()));
                                }
                      %></td>
                        <td width=50 align=right nowrap><%=mnf.format(item.getMyAmount())%></td>
                        <td width=50 align=right nowrap><%=mnf.format(0-discountAmount)%></td>
                        <td width=50 align=right nowrap><%=mnf.format(item.getMyAmount() - discountAmount)%></td>
                        <tD width=50 align=middle nowrap><%=item.getUserLoginId()%></td>
                    </tr>              
                    <%
                        }
                    %>
                </table>            
            </td>
        </tr> 
        <tr bgcolor=ffffff>
            <td colspan=4 class=es02 align=middle valign=middle>
             ......................................................................................................................................................................................................   
            </td>
        </tr>
<%  } %>
        <tr bgcolor=ffffff>
            <td colspan=4 class=es02 align=middle valign=middle height=40>
                
                主管簽核:   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 日期:                

            </td>
        </tr>


        </table>
    </td>
    </tr>
    </table>
</center>
<br>
<br>
  <script>
        function preview_fresh()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "true";
            f.submit();
        }
        function preview_all()
        {
            var f = document.f1;
            f.action = "billrecord_detail.jsp";
            f.freshonly.value = "false";
            f.submit();
        }

        if (<%=hasOverpay%>) {
            if (confirm("這批帳單有餘額可先沖銷, 是否先沖帳?\n按取消可繼續發佈")) {
                location.href = "query_overpay.jsp";
            }
        }
    </script>
