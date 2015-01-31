<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
    //##v2
try {
    String o =  request.getParameter("o");
    String t = request.getParameter("t");
    String str = request.getParameter("freshonly");
    String bdate = request.getParameter("billdate");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    boolean freshonly = (str!=null) && str.equals("true");

    BillRecordMgr bmgr = BillRecordMgr.getInstance();
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();
    PaySystem2Mgr pmgr = PaySystem2Mgr.getInstance();
    PaySystem2 pSystem= pmgr.find("id=1");

    String[] pairs = o.split(",");
    HashMap m1 = new HashMap();
    HashMap m2 = new HashMap();
    StringBuffer sb1 = new StringBuffer();
    StringBuffer sb2 = new StringBuffer();
    for (int i=0; i<pairs.length; i++) {
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
    MembrInfoBillRecordMgr snbrmgr = MembrInfoBillRecordMgr.getInstance();
    String query = "membrbillrecord.membrId in (" + sb1.toString() + ")" + 
        " and membrbillrecord.billRecordId in (" + sb2.toString() + ") and paidStatus in (0,1)";
    if (freshonly) 
        query += " and printDate=0 and billType=" + Bill.TYPE_BILLING;
    ArrayList<MembrInfoBillRecord> records = 
        snbrmgr.retrieveList(query, "");
    
    StringBuffer sb3 = new StringBuffer();
    for (int i=0; i<records.size(); i++) {
        if (sb3.length()>0) sb3.append(",");
        sb3.append("'" + records.get(i).getTicketId() + "'");
    }
    // BillDate
    Map<Date, Vector<MembrInfoBillRecord>> billdateMap = new SortingMap(records).doSort("getMyBillDate");
    Iterator<MembrInfoBillRecord> iter = records.iterator();

    Date newBillDate = null;
    if (bdate!=null) {
        newBillDate = sdf.parse(bdate);
        billdateMap.clear();
        billdateMap.put(newBillDate, new Vector<MembrInfoBillRecord>());
    }

    int total = 0;    
    Vector too_many_items_problem = new Vector();
    Vector isbirthday = new Vector();
    Vector over_limit = new Vector();
    Vector amt_setup_warning = new Vector();
    Vector nothing_in_it = new Vector();
    MembrBillRecordMgr mbrmgr = MembrBillRecordMgr.getInstance();
    while (iter.hasNext()) {
        MembrInfoBillRecord sinfo = iter.next();
        // check if too many chargeitems
        if (cismgr.numOfRows("chargeitem.billRecordId=" + sinfo.getBillRecordId() + " and membr.id=" + sinfo.getMembrId())>15)
            too_many_items_problem.addElement(sinfo);
        if (sinfo.getMembrBirth()!=null && sinfo.getBillMonth().getMonth()==sinfo.getMembrBirth().getMonth())
            isbirthday.addElement(sinfo);
        if (pSystem.storePayEnabled() && (sinfo.getReceivable()-sinfo.getReceived())>pSystem.getPaySystemLimitMoney())
            over_limit.addElement(sinfo);
        // 獨立消單 的帳單不能用 指定帳號轉帳 或 約定帳號轉帳, 因為無法判斷銷哪張
        if ((pSystem.getPaySystemATMActive()==3 || pSystem.getPaySystemATMActive()==2) && sinfo.getBalanceWay()==0)
            amt_setup_warning.addElement(sinfo);
        if (sinfo.getReceivable()==(int)0) 
            nothing_in_it.addElement(sinfo);
        if (newBillDate!=null) {
            sinfo.setBillDate(newBillDate);
            mbrmgr.save(sinfo);
        }
    }

    BunitHelper bh = new BunitHelper();
    String companyName = bh.getBillCompanyName(_ws2.getSessionBunitId()); // pSystem.getPaySystemCompanyName();
    String companyAddress = bh.getBillAddress(_ws2.getSessionBunitId()); // pSystem.getPaySystemCompanyAddress();
    String companyPhone = bh.getBillPhone(_ws2.getSessionBunitId()); // pSystem.getPaySystemCompanyPhone();
%>
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script src="js/string.js"></script>
<script src="js/dateformat.js"></script>
<script src="js/bill.js?<%=new Date().getTime()%>"></script>
<script>
function setBillDateComment(billdate, comment)
{
    document.getElementById("billdate").innerHTML = billdate + "," + comment;
}

function doCheck(f)
{
    if (f.way[1].checked && <%=pSystem.getPaySystemEmailServer()==null||pSystem.getPaySystemEmailServer().length()==0%>) {
        alert("郵件服務器尚未設定無法 Email 帳單，請先設定或聯絡必亨客服");
        return false;
    }
    if (confirm('產生帳單可能需要大約10秒鐘,所產生的帳單也將鎖住,確認產生帳單?'))
        return true;
    return false;
}

</script>
<body>
<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;    <b>
<%=(t!=null)?t:""%>-發佈繳款單</b>
<a href="javascript:history.go(-1)"><img src="pic/last.gif" border=0>&nbsp;回上一頁 </a>
</div>

 <table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<br>
<table width=100%>
    <tr>
        <td width=150 align=middle valign=top class=es02>
            <br>
            <img src="img/abill.gif" border=0><br><br>
        </td>
        <td>
    <table border=0>
    <tr class=es02>
        <form name="f1" action="print_bill_step2.jsp" method="post" onsubmit="return doCheck(this)">
        <td>
            <input type=radio name="way" value="pdf" checked>列印(下載PDF檔)
        </td>
        <tD>
            <input type=radio name="way" value="email">Email帳單
        </td>
        <!--
        <td>
            <input type=radio name="way" chekced>簡訊通知
        </td>
        -->
        <td>
            <input type="hidden" name="freshonly" value="<%=freshonly%>">
            <input type=hidden name=o value="<%=o%>">
            <% if (t!=null) { %>
            <input type="hidden" name="t" value="<%=t%>">
            <% } %>
            <input type="submit" value="2 發佈繳款單 ">
        </td>
    </tr>
    </table>                

</form>

<%
    if (nothing_in_it.size()>0) {%>
        <br><li><font color="red">有 <%=nothing_in_it.size()%> 筆帳單收費金額為 0  &nbsp;&nbsp;<b></font><br>
<%  }  %>

<form name="f2" action="print_bill_step1.jsp" method="post" onsubmit="return doSubmit();">
<input type="hidden" name="freshonly" value="<%=freshonly%>">
<input type=hidden name=o value="<%=o%>">
<input type=hidden name=t value="<%=t%>">

<div class=es02><b>帳單資訊:</b></div>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
                <td>出單機構</td>
                <tD bgcolor=ffffff><%=companyName%></tD>
            </tr>
<%
    if(pd2.getPagetype() !=1){
%>
            <tr bgcolor=#f0f0f0 class=es02>
                <td>地址</td>
                <tD bgcolor=ffffff><%=companyAddress%></tD>    
            </tr>
            <tr bgcolor=#f0f0f0 class=es02>
                <tD>電話</tD>
                <td bgcolor=ffffff><%=companyPhone%></td>                
            </tr>
<%  } %>  

          <tr bgcolor=#f0f0f0 class=es02>
                <tD>繳款期限</tD>
                <td bgcolor=ffffff><span id="billdate">
                    <% Set keys = billdateMap.keySet();
                       Iterator<Date> diter = keys.iterator();
                       while (diter.hasNext()) {
                           out.print(sdf.format(diter.next()));
                           out.print(" ");
                       }                    
                    %></span>&nbsp;<a href="javascript:modify_bill(document.f3.ticketIds.value);"><img src="pic/fix.gif" border=0 width=12>&nbsp;修改整批期限與備註</a></td>
            </tr>

<%
    //光仁和傳統帳單要直接編輯內容

    if(pd2.getPagetype() !=1 && pd2.getPagetype() !=2){
%>
            <tr bgcolor=#f0f0f0 class=es02>
                <tD>生日祝福</tD>
                <td bgcolor=ffffff class=es02>

                <%
                    if (isbirthday.size()>0) {
                %>
                        <table width=100% border=0 cellpadding=0 cellspacing=0>
                        <tr class=es02 bgcolor=f0f0f0><td align=middle>狀態</td><td align=middle>筆數</td><td align=middle>文案</td><td></td> </tr>
                        <tR class=es02>
                            <td align=middle><%=(pSystem.getPaySystemBirthActive()==1)?"使用中":"停用"%></td>
                            <td align=middle><%=isbirthday.size()%> 筆</td>
                            <td align=middle>
                                <%=pSystem.getPaySystemBirthWord()%>
                                <br>
                                [YYY:名字，XXX:生日日期]
                            </td>
                            <td>
                                <a href="javascript:openwindow_phm('print_bill_modify.jsp','修改帳單祝賀語狀態',400,400,true);"><img src="pic/fix.gif" border=0 width=12>&nbsp;編輯</a>
                            </td>
                        </tr>
                        </table>
                <%  }else{   %>
                        本月沒有繳款人生日.
                <%  }   %>
                </td>                
            </tr>
<%  }else{  %>
            <tr bgcolor=#f0f0f0 class=es02>
                <tD><%=(pd2.getPagetype()==1)?"頁首最新消息":"注意事項"%></tD>
                <td bgcolor=ffffff class=es02>
                    <%=(pd2.getPaySystemBirthWord()==null || pd2.getPaySystemBirthWord().length()<=0)?"<font color=blue>尚未設定</font>":pd2.getPaySystemBirthWord().replace("\n","<br>")%>&nbsp;&nbsp;<a href="javascript:openwindow_phm('print_bill_modify.jsp','修改最新消息',400,400,true);"><img src="pic/fix.gif" border=0 width=12>&nbsp;編輯</a>
                </td>
            </tr>

<%  }   %>  

      </table>
    </td>
    </tr>
</table>
</form>
<form name=f3>
<input type=hidden name="ticketIds" value="<%=sb3.toString()%>">
</form>

<%

/*
    boolean goodpay = false;
%>
<br>
<div class=es02><b>繳款資訊:</b></div>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
        <tr bgcolor=#f0f0f0 class=es02>
            <td>繳款方式</td><tD>目前狀態</td><td>銷帳時間</td><td>入帳時間</td>
        </tr>
        <tr class=es02 bgcolor=ffffff>
            <td>便利商店</td>
<%
    if (pSystem.storePayEnabled()) {
        String n = bh.getServiceID(_ws2.getSessionBunitId()); // pSystem.getPaySystemBankStoreNickName(); // 669
        String nn =  bh.getStoreID(_ws2.getSessionBunitId()); // pSystem.getPaySystemCompanyStoreNickName(); // PHM00..

        if (n==null || n.trim().length()==0 || nn==null || nn.trim().length()==0) {
            pSystem.setPaySystemStoreActive(0);
            pmgr.save(pSystem);
%>
            <td>停用</tD><td colspan=2>便利商店繳款參數設定不全, 請聯絡必亨客服中心 02-23693566</tD></tr>      
<%
        }else{
%>
            <td>使用中</tD><td>隔日中午</td><td>四個工作天</td></tr>
<% 
           goodpay = true;
        }
    }else{
        %>
            <td>尚未啟用</tD><td colspan=2><a href="javascript:openwindow_phm('print_bill_question.jsp?q=1','便利商店繳款尚未啟用',300,300,false)">怎麼辦?</b></a></font></td></tr>

<%  } %>
<%  if (over_limit.size()>0) { %>
    <tr><td></td><td>警示</tD><td colspan=2>有 <%=over_limit.size()%> 筆</a>超過便利商店繳款限制<%=pSystem.getPaySystemLimitMoney()%>,不會印出便利商店繳款條碼。</td></tr>

<%  } %>
    <tr class=es02 bgcolor=ffffff>
        <td>虛擬帳號-依帳單編號</td>
<%

    String n1 = pSystem.getPaySystemBankName();
    String n2 = pSystem.getPaySystemBankId();
    String virtualID = bh.getVirtualID(_ws2.getSessionBunitId());
    
    if (pSystem.getPaySystemATMActive()==1) {
        String n3 = virtualID;  //95481
        // 指定帳單轉帳
        if (n1==null || n1.trim().length()==0 || n2==null || n2.trim().length()==0 || n3==null || n3.trim().length()==0) {
            pSystem.setPaySystemATMActive(0);
            pmgr.save(pSystem);
%>
            <td>停用中</td><td colspan=2>指定帳單轉帳參數設定不全, 請聯絡必亨客服中心 02-23693566</td></tr>  
<%  
        }else{
%>
            <td>使用中</td><td>30分鐘</td><td>即時</td></tr>
<%
            goodpay = true;
        }
    }
    // 先進先銷才可用 每個學生的專屬的固定帳號，不然很難判斷是否那些沒繳的單子要銷
    else if (pSystem.getPaySystemATMActive()==3) {
%>
    <tr class=es02 bgcolor=ffffff>
        <td>虛擬帳號-依約定帳號</td>
<%
        // 繳款者虛擬帳戶
        String n4 = virtualID;
        String n5 = pSystem.getPaySystemFixATMAccount();
        int n6 = pSystem.getPaySystemFixATMNum(); // better to be 5
        if (n6<3 || n4==null || n4.length()==0 || n5==null || n5.length()==0) {
            pSystem.setPaySystemATMActive(0);
            pmgr.save(pSystem);
%>
            <td>停用中</td><td colspan=2>虛擬帳號轉帳參數設定不全, 請聯絡必亨客服中心 02-23693566</td></tr>  
<%
        }else {
%>
            <td>使用中</td><td colspan=2>銀行轉帳，按每個學生的專屬的固定帳號</td></tr>  
<%  
          if (amt_setup_warning.size()==0)
                goodpay = true;
            else %>
        <tr><td>虛擬帳號轉帳</td><td>警示</td><td colspan=2>有 <%=amt_setup_warning.size()%> 筆獨立銷單但非浮動帳號,不會印出銀行轉帳條碼。
         請聯絡必亨客服中心 02-23693566</font></td></tr>  
<%
        }
    }
    else
        %>
        <td>尚未申請</td><td colspan=2><font color='red'>銀行轉帳功能未啟用  &nbsp;&nbsp;<b><a href="javascript:openwindow_phm('print_bill_question.jsp?q=1','銀行轉帳繳款尚未啟用',300,300,false)">怎麼辦?</b></a></font></td></tr>          
<%
    if (!goodpay) {
%>
    <tr class=es02 bgcolor=ffffff><td>櫃臺繳款</td><td>使用中</td><td colspan=2>申請多元付款可結省75%的收款作業</td></tR>
<%
    }else{
%>
    <tr class=es02 bgcolor=ffffff><td>櫃臺繳款</td><td>使用中</td><td>即時</td><tD>即時</td></tR>
<%  }   %>

    </table>
    </td>
    </tr>
    </table>        

<% 

*/
   /*
    這個暫不開放，怕 user 亂搞
    else if (pSystem.getPaySystemATMActive()==2) {
        int account = pSystem.getPaySystemATMAccountId();
        if (account==0)
            out.println("<br><li><font color='red'>指定帳單轉帳參數設定不全, 請聯絡必亨客服中心 02-23693566</font>");
        else
            out.println("<br><li>指定帳單轉帳繳款開通");
    }
    */
  %>
</td>
</tr>
</table>
<br>
<br>

<%
    Date now = new Date();
    long range = (long)((long)10*(long)86400*(long)1000);
    Iterator<Date> iter3 = billdateMap.keySet().iterator();
    while (iter3.hasNext()) {
        Date d = iter3.next();
        if (d.getTime()-now.getTime()<range) {
          %><script>alert("今天到繳款期限不到十天\n可修改繳款期限");</script><%
            break;
        }
    }
}
catch (Exception e) {
    e.printStackTrace();
    if (e.getMessage()!=null) {
  %><script>alert('<%=phm.util.TextUtil.escapeJSString(e.getMessage())%>');history.go(-1);</script><%
    } else {
  %><script>alert("錯誤發生");history.go(-1);</script><%
    }
    return;
}
%>