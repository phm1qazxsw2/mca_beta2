<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<%
    int topMenu=1;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu1.jsp"%>
<%
    if(!checkAuth(ud2,authHa,101))
    {
        response.sendRedirect("authIndex.jsp?code=101");
    }

    //##v2
    String backurl = request.getParameter("backurl");
    int membrId = Integer.parseInt(request.getParameter("sid"));
    int billRecordId =1;// Integer.parseInt(request.getParameter("rid"));
    int reportId = Integer.parseInt(request.getParameter("poId"));

    MembrInfoBillRecordMgr mibrmgr = MembrInfoBillRecordMgr.getInstance();
    ChargeItemMembrMgr cismgr = ChargeItemMembrMgr.getInstance();

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");    
    java.text.SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yy年MM月");    
    DiscountMgr dmgr = DiscountMgr.getInstance();

    boolean active_status=false;
    String active_color = (active_status)?"ffffff":"ffffff";
    ArrayList<MembrInfoBillRecord> all_bills = mibrmgr.retrieveList("membrId=" + membrId + 
        " and billType=" + Bill.TYPE_BILLING, "order by billrecord.id desc");

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

    String mainTagName = null;
    try {
        MainTagStudent tag = MainTagStudentMgr.getInstance().find("membr.id=" + membrId);
        mainTagName = tag.getTagName();
    }
    catch (Exception e) {}

    String title=mb.getName();
    if (reportId==-1) {
        _ws.setBookmark(ud2, "繳費統計-" + title);
    }
    else if (reportId==-2) {
        _ws.setBookmark(ud2, "交易記錄-" + title);
    }
    int account_remain = (int)0;
    int total_pays = (int) 0;
    ArrayList<BillPay> payhistory = BillPayMgr.getInstance().
        retrieveList("membrId=" + membrId, "");
    Iterator<BillPay> iter4 = payhistory.iterator();
    while (iter4.hasNext()) {
        BillPay bp = iter4.next();
        total_pays += bp.getAmount();
        account_remain += bp.getRemain();
    }
    Map<Integer, Vector<BillPay>> paywayMap = new SortingMap(payhistory).doSort("getVia");
    int amount_via_otc = (int) 0;
    int amount_via_atm = (int) 0;
    int amount_via_store = (int) 0;
    Vector<BillPay> bv = paywayMap.get(new Integer(BillPay.VIA_INPERSON));
    if (bv!=null) {
        for (int i=0; i<bv.size(); i++)
            amount_via_otc += bv.get(i).getAmount();
    }
    bv = paywayMap.get(new Integer(BillPay.VIA_ATM));
    if (bv!=null) {
        for (int i=0; i<bv.size(); i++)
            amount_via_atm += bv.get(i).getAmount();
    }
    bv = paywayMap.get(new Integer(BillPay.VIA_STORE));
    if (bv!=null) {
        for (int i=0; i<bv.size(); i++)
            amount_via_store += bv.get(i).getAmount();
    }
%>
<link rel="stylesheet" href="css/ajax-tooltip-billsearch.css" media="screen" type="text/css">
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
</script>
<br>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;帳單明細 - <%=title%></b>&nbsp;&nbsp;&nbsp;&nbsp;<a href="<%=backurl%>"><img src="pic/last2.png" border=0 width=13>&nbsp;回上一頁</a>
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
        int unpaid_total = 0;
        int all_receivables = 0;
        int total_amount = 0;
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
                <td bgcolor="<%=color%>" width=100% height=25 valign=center class=es02>&nbsp;<a href="bill_detail.jsp?sid=<%=membrId%>&rid=<%=binfo.getBillRecordId()%>&backurl=<%=java.net.URLEncoder.encode(backurl)%>"><font color="<%=isActive?"ffffff":"5F5F5F"%>"><%=binfo.getBillRecordName()%></font></a></td>
            </tr>
    <%
        }
    %>
        <%@ include file="billdetail_menu.jsp"%>
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
                        <font color=#ffffff>&nbsp;&nbsp;&nbsp;姓名:<a href="javascript:openwindow_phm('modifyStudent.jsp?studentId=<%=mb.getSurrogateId()%>','基本資料',700,700,true);"><font color=#ffffff><%=title%><%=(mainTagName!=null)?"【"+mainTagName+"】":""%> </font></a>&nbsp;&nbsp;&nbsp;&nbsp;
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
                        retrieveList("charge.membrId=" + membrId + " and billType=" + Bill.TYPE_BILLING, "");
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
            <div class=es02>&nbsp;&nbsp;<b>收費總覽:</b></div>
            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width=20></tD>
                <td width=50%> 
           <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td align=middle>開單總金額</td><tD align=middle>折扣總金額(A)</td><td align=middle>應收小計(B)</td>
                    </tr>
                    <tr bgcolor=#ffffff class=es02>
                        <td align=right><%=mnf.format(allBill)%></td>
                        <tD align=right><%=mnf.format(allDiscount)%></td>
                        <td align=right><%=mnf.format(allMoney)%></td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td colspan=2 align=left>&nbsp;&nbsp;&nbsp;&nbsp;繳款金額合計(C)</td><td bgcolor=ffffff align=right><%=mnf.format(total_pays)%></td>
                    </tr>    
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td colspan=2 align=left>&nbsp;&nbsp;&nbsp;&nbsp;未繳金額</td><td bgcolor=ffffff align=right><%=mnf.format(allMoney-total_pays)%></td>
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
                        <td width=50%>
                            <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=xnow%>,<%=100-xnow%>&chs=120x60&chl=A|B&chco=EFF3EF,00EF00
" border=0>
                        </td>
                        <td width=40% class=es02 valign=bottom> 
                            A:折扣比例: <%=xnow%>%  <br>
                            B:應收比例: <%=100-xnow%>%
                        </td>
                </tr>
                <tr>
                    <td>
                        <img src="http://chart.apis.google.com/chart?chs=120x60&cht=gom&chd=t:<%=xpay%>&chl=c" border=0>
                    </td>
                    <td class=es02 valign=bottom>
                        C:收款比例: <%=xpay%>%
                    </td>
                </tr>
                </table>
        </tr>
        </table>

            <br>       
            <div class=es02>&nbsp;&nbsp;<b>收費項目統計:</b></div><br>
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
                        <td>開單金額</td>
                        <tD>折扣金額</td>
                        <td align=middle>應收小計</TD>
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

                        String percentX="0";
                        if(allMoney >0){
                            float fPercent=(float)((float)finaltotal/(float)allMoney)*100;
                            percentX=nf.format(fPercent);
                        }

                        if(startChar !=68)
                        {
                            chlString+="|";
                            tString+=",";
                        }
                        tString+=percentX;
                        chlString+=(char)startChar;
                    %>
                    <tr bgcolor=ffffff class=es02>
                        <td align=left>
                            <%=(char)startChar%>.&nbsp;<%=key%>
                        </td>
                        <td align=right><%=mnf.format(incomeTotal[0])%></td>
                        <td align=right><%=mnf.format(incomeTotal[1])%></td>                    
                        <td align=right><%=mnf.format(finaltotal)%></td>
                        <td align=right><%=percentX%> %</tD>
                    </tr>
                    <%
                    }
                    %>
                <tr class=es02 bgcolor=#f0f0f0>
                    <tD>合計</tD>
                    <tD align=right><%=mnf.format(tIncome1)%></td>
                    <tD align=right><%=mnf.format(tIncome2)%></td>                    
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
           
            <%
                if(haDiscount!=null && haDiscount.size()>0){
            %>
             <br>
            <br>
            <div class=es02>&nbsp;&nbsp;<b>折扣項目統計:</b></div><br>

            <%
                Enumeration keys3=haDiscount.keys();
                Enumeration elements3=haDiscount.elements();

            %>
           <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td width=20></td>
                <td width=70%>                 

                    <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                        <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td>折扣項目</td>
                            <td>折扣金額</td>
                            <tD>折扣比例</td>
                        </tr> 
                        <%
                            int startDis=0;                            
                            String tString2="";
                            String chlString2="";
                            while(elements3.hasMoreElements())
                            {
                                startChar++;
                                startDis++;
                                if(startDis !=1)
                                {
                                    chlString2+="|";
                                    tString2+=",";
                                }
                                String diskey=(String)keys3.nextElement();
                                String disTotalS=(String)elements3.nextElement();
                                int disTotal=Integer.parseInt(disTotalS);
                                double percentX2=(double)0.0;
                                if(allDiscount >0){
                                    percentX2=(double)disTotal/(double)allDiscount;
                                    percentX2=percentX2*100;
                                }
                                chlString2+=(char)startChar;
                                tString2+=String.valueOf((int)percentX2);
                        %>
                                <tr bgcolor=#ffffff class=es02>
                                    <td><%=(char)startChar%>.&nbsp;<%=diskey%></td>
                                    <td align=right><%=mnf.format(disTotal)%></td>
                                    <tD align=right><%=(int)percentX2%>%</td>
                                </tr> 
                        <%  }   %>

                    </table>
                        </td>
                        </tr>
                    </table>
                </td>
                <td align=middle valign=middle>
                    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tString2%>&chs=120x60&chl=<%=chlString2%>&chco=B9BEB9" border=0>
                </td>
            </tr>
            </table>
            <%
                }
            %>
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
                            
                            double otcPer=(double)0.0;
                            if(total_pays>0)
                            {
                                otcPer=(double)100*amount_via_otc/total_pays;
                            }
                            runChar1+=(char)startChar;
                            runChar2=mnf2.format(otcPer);                    
                        %>
                        <tr bgcolor=#ffffff class=es02>
                            <td align=left><%=(char)startChar%>.&nbsp;櫃臺繳款</td>
                            <td align=right><%=mnf.format(amount_via_otc)%></td>
                            <tD align=right><%=nf.format(otcPer)%>%</td>
                            </tr> 
                        </tr>
                        <%
                            ++startChar;
                            double storePer=(double)0.0;
                            if(total_pays>0)
                                storePer=(double)100*amount_via_store/total_pays;

                            runChar1+="|"+(char)startChar;
                            runChar2+=","+mnf2.format(storePer);                    
                        %>
                        <tr bgcolor=#ffffff class=es02>
                            <td align=left><%=(char)startChar%>.&nbsp;便利商店代收</td>
                            <td align=right><%=mnf.format(amount_via_store)%></td>
                            <tD align=right><%=nf.format(storePer)%>%</td>
                            </tr> 
                        </tr>
                        <%
                            ++startChar;
                            double atmPer=(double)0.0;
                            if(total_pays>0)
                                atmPer=(double)100*amount_via_atm/total_pays;
                            runChar1+="|"+(char)startChar;
                            runChar2+=","+mnf2.format(atmPer);                    
                        %>
                        <tr bgcolor=#ffffff class=es02>
                            <td align=left><%=(char)startChar%>.&nbsp;虛擬帳號轉帳</td>
                            <td align=right><%=mnf.format(amount_via_atm)%></td>
                            <tD align=right><%=nf.format(atmPer)%>%</td>
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
            
                    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=(total_pays!=0)?100*amount_via_otc/total_pays:"0"%>,<%=(total_pays!=0)?100*amount_via_store/total_pays:"0"%>,<%=(total_pays!=0)?100*amount_via_atm/total_pays:"0"%>&chs=120x60&chl=<%=runChar1%>&chco=F77510" border=0>
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