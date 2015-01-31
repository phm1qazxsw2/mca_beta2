<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=5;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu5.jsp"%>
<%
    //##v2
    String backurl = request.getParameter("backurl");
    int membrId = Integer.parseInt(request.getParameter("sid"));
    int reportId = Integer.parseInt(request.getParameter("poId"));

    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");    
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yy年MM月");    
    DiscountMgr dmgr = DiscountMgr.getInstance();

    boolean active_status=false;
    String active_color = (active_status)?"ffffff":"ffffff";
    
    ArrayList<MembrInfoBillRecord> all_bills = MembrInfoBillRecordMgr.getInstance().retrieveList("membrId=" + membrId, "order by billrecord.id desc");

    MembrMgr mm=MembrMgr.getInstance();
    Membr mb=(Membr)mm.find("id="+membrId);
    if(mb ==null)
    {
%>
        <blockquote>
            沒有此會員
        </blockquote>
<%
        return;
    }

    String title=mb.getName();
    String ticketIds = new RangeMaker().makeRange(all_bills, "getTicketId");

    int total_pays = (int) 0;
    ArrayList<BillPaidInfo> paidrecords = BillPaidInfoMgr.getInstance().
        retrieveList("billpaid.ticketId in (" + ticketIds + ")", "");
    Iterator<BillPaidInfo> iter4 = paidrecords.iterator();
    while (iter4.hasNext()) {
        BillPaidInfo bp = iter4.next();
        total_pays += bp.getPaidAmount();
    }
    Map<Integer, Vector<BillPaidInfo>> paywayMap = new SortingMap(paidrecords).doSort("getVia");
    int amount_via_cash = (int) 0;
    int amount_via_wire = (int) 0;
    int amount_via_check = (int) 0;
    Vector<BillPaidInfo> bv = paywayMap.get(new Integer(BillPay.SALARY_CASH));
    if (bv!=null) {
        for (int i=0; i<bv.size(); i++)
            amount_via_cash += bv.get(i).getPaidAmount();
    }
    bv = paywayMap.get(new Integer(BillPay.SALARY_WIRE));
    if (bv!=null) {
        for (int i=0; i<bv.size(); i++)
            amount_via_wire += bv.get(i).getPaidAmount();
    }
    bv = paywayMap.get(new Integer(BillPay.VIA_CHECK));
    if (bv!=null) {
        for (int i=0; i<bv.size(); i++)
            amount_via_check += bv.get(i).getPaidAmount();
    }
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

</script>
<br>

<%
%>
<b>&nbsp;&nbsp;&nbsp;薪資明細 -- <%=title%></b><a href="<%=backurl%>"><img src="pic/last.gif" border=0>回上一頁</a>
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
        int unpaid_total = 0;
        int all_receivables = 0;
        int total_amount = 0;
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

            boolean isActive=false;
            String color = (isActive)?active_color:"white";
            unpaid_total += (binfo.getReceivable() - binfo.getReceived());

            all_receivables += binfo.getReceivable();
            
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
                <td bgcolor="<%=color%>" width=100% height=25 valign=center class=es02>&nbsp;<a href="salary_detail.jsp?sid=<%=membrId%>&rid=<%=binfo.getBillRecordId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>"><font color="<%=isActive?"ffffff":"5F5F5F"%>"><%=binfo.getBillRecordName()%></font></a></td>
            </tr>
    <%
        }
    %>
                <%@ include file="salarydetail_menu.jsp"%>
    </table>

    </td>
    <td valign=top>
        <table border=0 cellpadding=0 cellspacing=0 width=100% height=9>
        <tr width=100%>
            <td background="img/a3_11.gif" width=9 height=9></td>
            <td bgcolor="#6B696B"><img src="img/aspace.gif" border=0></td>
            <tD width=9 height=9 background="img/a3_12.gif"></td>
        </tr>
        <tr bgcolor="#6B696B">
            <td></td>
            <td>
            
            <table border=0 CELLSPACING=0 CELLPADDING=0 width=100%>
            <tr>
                <td valign=middle>
                  
                    <div class=es02>
                        <font color=ffffff>&nbsp;&nbsp;&nbsp;姓名: <%=mb.getName()%>&nbsp;&nbsp;&nbsp;&nbsp;
                            <%
                            if(reportId==-1){
                            %>
                            繳費統計
                            <%  }else{  %>
                            交易記錄
                            <%  }   %>
                        </font>
                    </div>
                    <br>
                    <%
                    if(reportId==-1){
                    %>
                        <input type="button" value="列印繳費統計" onClick="javascript:window.print();">
                    <% }else if(reportId==-2){  %>
                        <input type="button" value="列印交易記錄" onClick="javascript:window.print();">
                    <%  }   %>    
                    <br><br>
                </td>
            </tr>
            <tr bgcolor=ffffff width=100% height=600>
            <td width=100% valign=top>
            <%
                if(reportId==-1)
                {
                    DecimalFormat nf = new DecimalFormat("###,##0.00");
                    DecimalFormat mnf = new DecimalFormat("###,###,##0");
                    DecimalFormat mnf2 = new DecimalFormat("########0");            
                    Membr membr = MembrMgr.getInstance().find("id=" + membrId);
                    ArrayList<ChargeItemMembr> chargeitems = ChargeItemMembrMgr.getInstance().
                    retrieveList("charge.membrId=" + membrId, "");
                    ArrayList<DiscountInfo> discounts = DiscountInfoMgr.getInstance().
                    retrieveList("discount.membrId=" + membrId, "");

                    Map<Integer,Vector<ChargeItemMembr>> chargeMap = new SortingMap(chargeitems).doSort("getBillItemId");
                    Map<Integer,Vector<DiscountInfo>> discountMap = new SortingMap(discounts).doSort("getChargeItemId");

            %>   
                    <br>        
            <%
                    if (chargeitems.size()>0) {                        
                        Hashtable haFee=new Hashtable();
                        Hashtable haDiscount=new Hashtable();
                      
                        int allBill=0;
                        int allDiscount=0;
                        int allMoney=0;

                        Set keys = chargeMap.keySet();
                        Iterator<Integer> iter = keys.iterator();
                        while (iter.hasNext()) {
                            Vector<ChargeItemMembr> v = chargeMap.get(iter.next());
                            for (int i=0; i<v.size(); i++) {
                                ChargeItemMembr c = v.get(i);
                                Vector<DiscountInfo> v2 = discountMap.get(new Integer(c.getChargeItemId()));
                                
                                int totalDiscount=0;
                                if (v2!=null && v2.size()>0) {
                                    for (int j=0; j<v2.size(); j++) {
                                        DiscountInfo dinfo = v2.get(j);
                                        totalDiscount+=dinfo.getAmount();

                                        String oldDiscount=(String)haDiscount.get((String)dinfo.getDiscountTypeName());
                                        if(oldDiscount ==null)
                                        {
                                            int xputnum=(int)dinfo.getAmount();
                                            haDiscount.put((String)dinfo.getDiscountTypeName(),(String)String.valueOf(xputnum));
                                        }else{

                        
                                            int nowDistotal=Integer.parseInt(oldDiscount)+(int)dinfo.getAmount();
                                            haDiscount.put((String)dinfo.getDiscountTypeName(),(String)String.valueOf(nowDistotal));
                                        }
                                    }
                                }
                                allBill+=(int)c.getMyAmount();
                                allDiscount+=totalDiscount;

                                int[] oldTotal=(int[])haFee.get(c.getChargeName());
                                if(oldTotal ==null)
                                {
                                    int[] nowTotal={(int)c.getMyAmount(),totalDiscount};

                                    haFee.put((String)c.getChargeName(),(int[])nowTotal);
                                }else{
                                    int[] nowTotal={(int)c.getMyAmount()+oldTotal[0],totalDiscount+oldTotal[1]};
                                    haFee.put((String)c.getChargeName(),(int[])nowTotal);
                                }
                            }
                        }
                        allMoney=allBill-allDiscount;
            %>
            <div class=es02>&nbsp;&nbsp;<b>薪資總覽:</b></div>
            <br>
            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width=20></tD>
                <td width=50%> 
           <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>&nbsp;&nbsp;&nbsp;&nbsp;薪資總金額</td>
                        <td bgcolor=ffffff align=right><%=mnf.format(allMoney)%></td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;已付金額(C)</td>
                        <td bgcolor=ffffff align=right><%=mnf.format(total_pays)%></td>
                    </tr>    
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td align=left>&nbsp;&nbsp;&nbsp;&nbsp;未付金額</td><td bgcolor=ffffff align=right><%=mnf.format(allMoney-total_pays)%></td>
                    </tr>  
                  
                    </table>
                </td>
                </tr>    
            </table>
                </td>
                <td align=middle>
                  
                    <%
                        int xnow=(int)((float)(allDiscount)/(float)allBill*100);
                        int xpay=(int)((float)(total_pays)/(float)allMoney*100);
                    %>

                    <table border=0 width=90%>
                    <tr>
                    <td>
                        <img src="http://chart.apis.google.com/chart?chs=120x60&cht=gom&chd=t:<%=xpay%>&chl=c" border=0>
                    </td>
                    <td class=es02 valign=bottom>
                        收款比例: <%=xpay%>%
                    </td>
                    </tr>
                    </table>
            </tr>
            </table>

            <br>       
            <div class=es02>&nbsp;&nbsp;<b>薪資項目統計:</b></div><br>
            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width=20></td>
                <td width=70%> 
                
                <center>
                <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>收費項目</td>
                        <td align=middle>應付小計</TD>
                        <TD align=middle>應收總比例</td>
                    </tr> 
            <%  
                    Enumeration keys2=haFee.keys();
                    Enumeration elements2=haFee.elements();

                    int totalNumFee=0;

                    String chlString="";
                    String tString="";
                    int startChar=67;
                    int tIncome1=0;
                    int tIncome2=0;
                    int tIncome3=0;    

                    while(elements2.hasMoreElements())
                    {
                        startChar++;
                        totalNumFee ++;
                        String key=(String)keys2.nextElement();
                        int[] incomeTotal=(int[])elements2.nextElement();

                        int finaltotal=incomeTotal[0]-incomeTotal[1];
                        tIncome1+=incomeTotal[0];
                        tIncome2+=incomeTotal[1];
                        tIncome3+=finaltotal;
                        float fPercent=(float)((float)finaltotal/(float)allMoney)*100;
                        String percentX=(fPercent<0)?"("+nf.format(Math.abs(fPercent))+")":nf.format(fPercent);
                        
                        if(startChar !=68)
                        {
                            chlString+="|";
                            tString+=",";
                        }
                        tString+=String.valueOf((int)fPercent);
                        chlString+=(char)startChar;
                    %>
                    <tr bgcolor=ffffff class=es02>
                        <td align=left>
                            <%=(char)startChar%>.&nbsp;<%=key%>
                        </td>
                        <td align=right><%=(finaltotal<0)?"("+mnf.format(Math.abs(finaltotal))+")":mnf.format(finaltotal)%></td>
                        <td align=right><%=percentX%> %</td>
                    </tr>
                    <%
                    }
                    %>
                <tr class=es02 bgcolor=#f0f0f0>
                    <tD>合計</tD>
                    <tD align=right><%=mnf.format(allMoney)%></td>
                    <td></td>
                </tr>
                    </table>
                    </td>
                    </tr>
                    </table>      
             </center>
                
                </td>
                <td align=middle valign=middle>
                    
                    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tString%>&chs=120x60&chl=<%=chlString%>&chco=00EF00" border=0>
                </td>
            </tr>
            </table>
           
  
            <br>
            <br>
            <div class=es02>&nbsp;&nbsp;<b>付款方式統計:</b></div><br>
           
            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width=20></td>
                <td width=70%>                 
            
                    <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                        <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td>付款方式</td>
                            <td>金額</td>
                            <tD>比例</td>
                            </tr> 
                        </tr>
                        <%
                            String runChar1="";
                            String runChar2="";
                            ++startChar;

                            double cashPer=(double)0.0;
                            if(total_pays!=0 && amount_via_cash !=0)
                                cashPer=100*amount_via_cash/total_pays;
                            runChar1+=(char)startChar;
                            runChar2=mnf2.format(cashPer);                    
                        %>
                        <tr bgcolor=#ffffff class=es02>
                            <td align=left><%=(char)startChar%>.&nbsp;現金</td>
                            <td align=right><%=mnf.format(amount_via_cash)%></td>
                            <tD align=right><%=nf.format(cashPer)%>%</td>
                            </tr> 
                        </tr>
                        <%
                            ++startChar;
                            
                            double wirePer=(double)0.0;
                            if(amount_via_wire>0 && total_pays>0)
                                wirePer=100*amount_via_wire/total_pays;

                            runChar1+="|"+(char)startChar;
                            runChar2+=","+mnf2.format(wirePer);                    
                        %>
                        <tr bgcolor=#ffffff class=es02>
                            <td align=left><%=(char)startChar%>.&nbsp;匯款</td>
                            <td align=right><%=mnf.format(amount_via_wire)%></td>
                            <tD align=right><%=nf.format(wirePer)%>%</td>
                            </tr> 
                        </tr>
                        <%
                            ++startChar;
                            double checkPer=(double)0.0;
                            if(amount_via_check>0 && total_pays>0)
                                checkPer=100*amount_via_check/total_pays;
                            runChar1+="|"+(char)startChar;
                            runChar2+=","+mnf2.format(checkPer);                    
                        %>
                        <tr bgcolor=#ffffff class=es02>
                            <td align=left><%=(char)startChar%>.&nbsp;支票</td>
                            <td align=right><%=mnf.format(amount_via_check)%></td>
                            <tD align=right><%=nf.format(checkPer)%>%</td>
                            </tr> 
                        </tr>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td align=middle>&nbsp;繳款合計:</td>
                            <td align=right><b><%=mnf.format(total_pays)%></b></td>
                            <tD align=right></td>
                            </tr> 
                        </tr>
                    </table>
                    </td>
                    </tr>
                    </table>    
                </td>
                <td align=middle valign=middle>
                    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=(amount_via_cash >0 && total_pays>0)?100*amount_via_cash/total_pays:"0"%>,<%=(amount_via_wire >0 && total_pays>0)?100*amount_via_wire/total_pays:"0"%>,<%=(amount_via_check >0 && total_pays>0)?100*amount_via_check/total_pays:"0"%>&chs=120x60&chl=<%=runChar1%>&chco=F77510" border=0>
                </td>
            </tr>
        </table>

                <%
                    } // have data
                %>
            <%
                }else if(reportId ==-2 ){  //report page
                    String backurl2="bill_detail2.jsp?"+request.getQueryString();
            %>         
                    <%@ include file="pay_info_detail.jsp"%>
            <%  }   %>
                <br>
                <br>
            </td>
            </tr>
            </table>                       

            </td>
            <td></td>
        </tr>
        <tr width=100%>
            <td background="img/a3_21.gif" width=9 height=9></td>
            <td bgcolor="#6B696B"><img src="img/aspace.gif" border=0></td>
            <tD width=9 height=9 background="img/a3_22.gif"></td>
        </tr>
        </table>
            
            
    </td>
    </tr>
    </table>

    <br>
    <br>

<%@ include file="bottom.jsp"%>