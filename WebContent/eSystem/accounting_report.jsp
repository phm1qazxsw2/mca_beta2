<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*,jsi.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=10;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%
    if(!checkAuth(ud2,authHa,502))
    {
        response.sendRedirect("authIndex.jsp?code=502");
    }
%>
<%@ include file="leftMenu10.jsp"%> 


<style type="text/css">
<!--
.x1 {  border: #A498BD double; height: 0px; color: #4D2078; border-width: 0px 0px 3px} 
-->
</style>
<%
    DecimalFormat nf = new DecimalFormat("###,##0");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");



    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

    Date d = new Date();
    try { d = sdf.parse(request.getParameter("calcDate")); } catch (Exception e) {}

    // 資產有
    //    現金(0), 未兌現收款支票3, 應收(學費1, 雜費2)
    // 負債有
    //    預收款4, 未兌現付款支票5, 應付(應付薪資13, 雜費6), 
    // 股東權益有
    //    股東挹注7 提領8, 累計盈虧(學費9 薪資支出10 雜費收入11 雜費支出12)
    
    Map<Object/*帳號*/, Integer/*餘額*/> cashaccounts = new LinkedHashMap<Object/*帳號名*/, Integer/*餘額*/>();   
    int[] numbers = new int[22];
    EzCountingService ezsvc = EzCountingService.getInstance();
    ezsvc.getAccountingNumbers(d, cashaccounts, numbers);

    int cash_total = numbers[0];
    int revenue_receivable = numbers[1];
    int income_receivable = numbers[2];
    int cheque_receivable = numbers[3];
    int pre_received = numbers[4];
System.out.println("#### pre_received=" + pre_received);
    int cheque_payable = numbers[5];
    int spending_payable = numbers[6];
    int shareholder_moneyin = numbers[7];
    int shareholder_moneyout = numbers[8];
    int costofgoods_payable = numbers[17];

        // numbers[9] : 學費收入
        // numbers[10] : 薪資支出
        // numbers[11] : 雜費收入
        // numbers[12] : 雜費支出
        // numbers[13] : 應付薪資

%>

<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

<br>
<TABLE border=0>
    <TR class=es02>
        <td>
            <b>&nbsp;&nbsp;&nbsp;資產負債試算</b>
        </td>
        
<form action="" method="get" name="xs" id="xs">
        <td width=80 align=right>
            <b>日期:</b>
        </td>
        <td width=150>
            <input type=text name="calcDate" value="<%=sdf.format(d)%>" size=7>
            &nbsp;<a href="#" onclick="displayCalendar(document.xs.calcDate,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
        </td>
        

        <tD width=40>
            <input type=submit value="確認">    
        </td>
</form>
    </tr>
</table>       

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>


<BR>
<center>
<table border=0 width=88%>
    <tr>
        <td width=47%>
<table class=es02 border=0 width=100%>
    <tr class=es02 height=20>
        <td align=left valign=middle>
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr width=100%>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                    <td width=90%  bgcolor=#696a6e class=es02>
                        <font color=ffffff>&nbsp;&nbsp;<img src="pic/A.png" border=0>&nbsp;&nbsp;<b>資 產</b></font>
                    </td>
                    <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                    </td>
                    <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                </tr>
            </table>
        </tD>
        </tr>
    <tr class=es02  height=10>
        <td align=left valign=middle>
        </tD>
    </tr>
</table>
          <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                        <td>代碼</td>
                        <tD align=middle>資&nbsp;&nbsp;產</td>
                        <td align=middle>金額</td>
                        <td align=middle>%</td>
                    </tr>
   
    <tr bgcolor=#ffffff class=es02>
        <tD> 
        </td>
        <td colspan=3>
        <b>現金:</b>
        </td>
    </tr>
    
<%
    int stockvalue = numbers[16] - numbers[15]; // 進貨成本 - 銷貨成本 = 庫存金額
    int prepaid_spending = numbers[18];
    int prepaid_salary = numbers[20];
    int inventory_prepaid = numbers[21];
    int prepaidTotal = prepaid_spending + prepaid_salary + inventory_prepaid;
    int assetTotal= cash_total  // 現金
                    +prepaid_spending // 預付雜費
                    +prepaid_salary // 預付薪資
                    +inventory_prepaid // 存貨預付
                    +cheque_receivable // 支票未兌
                    +revenue_receivable  // 學費應收
                    +income_receivable   // 雜費應收
                    +stockvalue;   // 庫存金額

    Set keys = cashaccounts.keySet();
    Iterator<Object> iter = keys.iterator();
    while (iter.hasNext()) {
        Object o = iter.next();
        Integer v = cashaccounts.get(o);
        if (o instanceof Tradeaccount) { 
            Tradeaccount t = (Tradeaccount) o;
         %>
        <tr bgcolor=ffffff class=es02>
            <td>
            1112 
            </td>
            <td nowrap>
                &nbsp;&nbsp;&nbsp;零用金:

                <a href="show_costpay_detail.jsp?bankType=1&baid=<%=t.getId()%>">
                <%=t.getTradeaccountName()%>
                </a>
            </td>
            <tD align=right>
                <%=changeNumber(v.intValue())%>
            </td>
            <tD align=right>
                <%=changePercent(v.intValue(),assetTotal)%>
            </td>
        </tr>
     <% } else { 
            BankAccount b = (BankAccount) o;
         %>
        <tr bgcolor=#ffffff class=es02>
            <td>
                1113 
            </td>
            <td nowrap>
            &nbsp;&nbsp;&nbsp;銀行帳戶:
                <a href="show_costpay_detail.jsp?bankType=2&baid=<%=b.getId()%>">
                <%=b.getBankAccountName()%>
                </a>
            </td>
            <tD align=right>
            <%=changeNumber(v.intValue())%>
            </td>
            <td align=right>
            <%=changePercent(v.intValue(),assetTotal)%>
            </td>
        </tr>
    <% 
        } 
    } 
    %>
    <tr class=es02 bgcolor=ffffff>
        <tD>
            111x 
        </td>
        <td align=middle>
            現金合計:
        </td>
        <tD align=right>    
        <u><%=changeNumber(cash_total)%></u>
        </tD>
        <td align=right>
            <u><%=changePercent(cash_total,assetTotal)%></u>
        </td>
    </tr>

<% if (prepaidTotal!=0) { %>
    <tr bgcolor=#ffffff class=es02>
        <tD> 
        </td>
        <td colspan=3>
        <b>預付款:</b>
        </td>
    </tr>
<% } %>
<% if (prepaid_spending!=0) { %>
    <tr class=es02 bgcolor=ffffff>
        <tD>
            1258
        </td>
        <td align=left>
            &nbsp;&nbsp;&nbsp;預付雜費:
        </td>
        <tD align=right>    
        <%=changeNumber(prepaid_spending)%>
        </tD>
        <td align=right>
            <%=changePercent(prepaid_spending,assetTotal)%>
        </td>
    </tr>
<% } %>
<% if (prepaid_salary!=0) { %>
    <tr class=es02 bgcolor=ffffff>
        <tD>
            1258
        </td>
        <td align=left>
            &nbsp;&nbsp;&nbsp;預付薪資:
        </td>
        <tD align=right>    
        <u><%=changeNumber(prepaid_salary)%></u>
        </tD>
        <td align=right>
            <%=changePercent(prepaid_salary,assetTotal)%>
        </td>
    </tr>
<% } %>
<% if (inventory_prepaid!=0) { %>
    <tr class=es02 bgcolor=ffffff>
        <tD>
            1258
        </td>
        <td align=left>
            &nbsp;&nbsp;&nbsp;預付貨款:
        </td>
        <tD align=right>    
        <%=changeNumber(inventory_prepaid)%>
        </tD>
        <td align=right>
            <%=changePercent(inventory_prepaid,assetTotal)%>
        </td>
    </tr>
<% } %>
<% if (prepaidTotal!=0) { %>
    <tr class=es02 bgcolor=ffffff>
        <tD>
            125x
        </td>
        <td align=center>
            預付合計:
        </td>
        <tD align=right>    
        <u><%=changeNumber(prepaidTotal)%></u>
        </tD>
        <td align=right>
            <u><%=changePercent(prepaidTotal,assetTotal)%></u>
        </td>
    </tr>
<% } %>
    <tr class=es02 bgcolor=ffffff>
        <tD>
        </td>
        <td colspan=3>
        <b>應收票據:</b>
        </td>
    </tr>
    <tr class=es02 bgcolor=ffffff>
        <tD>1131</td>
        <td>
            &nbsp;&nbsp;&nbsp;
            <a href="query_cheque.jsp">支票:</a>
        </td>
        <td align=right>
        <%=changeNumber(cheque_receivable)%>
        </tD>
        <tD align=right>
            <%=changePercent(cheque_receivable,assetTotal)%>
        </tD>
    </tr>
    <tr class=es02 bgcolor=ffffff>
        <tD>113x</td>
        <td align=middle>
            &nbsp;&nbsp;&nbsp;應收票據合計:
        </td>
        <td align=right>
            <u><%=changeNumber(cheque_receivable)%></u>
        </tD>
      <tD align=right>
            <%=changePercent(cheque_receivable,assetTotal*100)%>
        </tD>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <tD>
        </td>
        <td colspan=3>
        <b>應收帳款:</b>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
            1141
        </td>
        <td>
         &nbsp;&nbsp;&nbsp;
            <a href="query_unpaid.jsp">應收帳款 學費</a>
        </td>
        <td align=right>
            <%=changeNumber(revenue_receivable)%>
        </td>
        <tD align=right>
            <%=changePercent(revenue_receivable,assetTotal)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
            1141
        </td>
        <td>
         &nbsp;&nbsp;&nbsp;
        <a href="spending_list.jsp?type=1&paidstatus=1&start=1980/01/01">
        應收帳款 雜費</a>
        </td>
        <td align=right>
            <%=changeNumber(income_receivable)%>
        </td>
        <tD align=right>
            <%=changePercent(income_receivable,assetTotal)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <tD>114x</td>
        <td align=middle>
            應收帳款合計:
        </td>
        <td align=right>
            <% 
                int shouldTotal=revenue_receivable+income_receivable;
            %>
            <u><%=changeNumber(shouldTotal)%></u>
        </td>   
        <tD align=right>
            <u><%=changePercent(shouldTotal,assetTotal)%></u>
        </td>
    </tr>

    
    <tr bgcolor=ffffff class=es02>
        <tD>
        </td>
        <td colspan=3>
        <b>存貨:</b>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
            121x
        </td>
        <td>
         &nbsp;&nbsp;&nbsp;
            商品存貨
        </td>
        <td align=right>
            <%=changeNumber(stockvalue)%>
        </td>
        <tD align=right>
            <%=changePercent(stockvalue,assetTotal)%>
        </td>
    </tr>
    
    
    
    <tr class=es02  height=20 bgcolor=ffffff>
        <td align=left valign=middle colspan=4>
        </tD>
    </tr>
    <tr class=es02>
        <td>1xxx</td>
        <td>
            資 產 總 計:
        </td>
        <td align=right>
        <div class=x1><%=changeNumber(assetTotal)%></div>
        </td>
        <tD align=right>
            <div class=x1><%=changePercent(assetTotal,assetTotal)%></div>            
        </tD>
    </tr>
    </table>

    </td>
    </tr>
    </table>


    </td>
    <tD width=6% class=es02 align=middle valign=middle><b>=</b></td>    
    <td width=47% valign=top>
<%
    int spending_pre_received = numbers[19];
    int totalIncome = numbers[9] // 學費收入
              +numbers[11] // 雜費收入
              -numbers[10] // 薪資支出
              -numbers[12] // 雜費支出
              -numbers[15]; // 銷貨成本

    int totalX = pre_received  // 學費預收
                 + spending_pre_received  // 雜費預收
                 + cheque_payable 
                 + spending_payable
                 + costofgoods_payable
                 + shareholder_moneyin 
                 - shareholder_moneyout 
                 + totalIncome // 累計盈虧
                 + numbers[13] + numbers[14];
%>

<table class=es02 border=0 width=100%>
    <tr class=es02 height=20>
        <td align=left valign=middle>
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr width=100%>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                    <td width=90%  bgcolor=#696a6e class=es02>
                        <font color=ffffff>&nbsp;&nbsp;<img src="pic/L.png" border=0> + <img src="pic/E.png" border=0>&nbsp;&nbsp;<b>負 債 及 業 主 權 益</b></font>
                    </td>
                    <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                    </td>
                    <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                </tr>
            </table>
        </tD>
        </tr>
    <tr class=es02  height=10>
        <td align=left valign=middle>
        </tD>
    </tr>
</table>
          <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 align=left valign=middle class=es02>
                    <td>代碼</td>
                    <tD align=middle>負債及業主權益</td>
                    <td align=middle>金額</td>
                    <td align=middle>%</td>
                </tr>
    <tr bgcolor=ffffff class=es02>
        <td>                        
        </td>
        <td colspan=3>
           <b>負債:</b>
        </tD>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
        2131                        
        </td>
        <td>
           &nbsp;&nbsp;&nbsp;
            <a href="query_cheque.jsp">應付票據</a>
        </tD>
        <td align=right>
            <%=changeNumber(cheque_payable)%>
        </tD>
        <td align=right>
            <%=changePercent(cheque_payable,totalX)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
        2141                        
        </td>
        <td>
           &nbsp;&nbsp;&nbsp;
            <a href="spending_list.jsp?type=0&paidstatus=1&start=1980/01/01">
            應付帳款-雜費</a>
        </tD>
        <td align=right>
            <%=changeNumber(spending_payable)%>
        </tD>
        <td align=right>
            <%=changePercent(spending_payable,totalX)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
        2141                        
        </td>
        <td>
            &nbsp;&nbsp;&nbsp;
            應付帳款-薪資
        </tD>
        <td align=right>
            <%=changeNumber(numbers[13])%>
        </tD>
        <td align=right>
            <%=changePercent(numbers[13],totalX)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>
        2141                        
        </td>
        <td>
            &nbsp;&nbsp;&nbsp;
            應付帳款-存貨
        </tD>
        <td align=right>
            <%=changeNumber(costofgoods_payable)%>
        </tD>
        <td align=right>
            <%=changePercent(costofgoods_payable,totalX)%>
        </td>
    </tr>
<% if (pre_received!=0) { %>
    <tr bgcolor=ffffff class=es02>
        <td>
        2262                        
        </td>
        <td>
           &nbsp;&nbsp;&nbsp;
            <a href="query_overpay.jsp">學費預收</a>
        </tD>
        <td align=right>
            <%=changeNumber(pre_received)%>
        </tD>
        <td align=right>
            <%=changePercent(pre_received,totalX)%>
        </td>
    </tr>
<% } %>
<% if (spending_pre_received!=0) { %>
    <tr bgcolor=ffffff class=es02>
        <td>
        2262                        
        </td>
        <td>
           &nbsp;&nbsp;&nbsp;
           雜費預收
        </tD>
        <td align=right>
            <%=changeNumber(spending_pre_received)%>
        </tD>
        <td align=right>
            <%=changePercent(spending_pre_received,totalX)%>
        </td>
    </tr>
<% } %>

    <tr bgcolor=ffffff class=es02>
        <td>
        2xxx                        
        </td>
        <td align=middle>
           &nbsp;&nbsp;&nbsp;負債合計:
        </tD>
        <td align=right>
            <%
                int xtotal2=pre_received+cheque_payable+spending_payable+costofgoods_payable+numbers[13];
            %>
            <u><%=changeNumber(xtotal2)%></u>
        </tD>
        <td align=right>
            <u><%=changePercent(xtotal2,totalX)%></u>
        </td>
    </tr>

    <tr bgcolor=ffffff class=es02>
        <td>         
        </td>
        <td colspan=3>
            <b>股東權益:</b>
        </tD>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>3116         
        </td>
        <td>
           &nbsp;&nbsp;&nbsp;
            <a href="listOwnerIndex.jsp">股東挹注</a>
        </tD>
        <td align=right>
            <%=changeNumber(shareholder_moneyin)%>
        </tD>
        <td align=right>
            <%=changePercent(shareholder_moneyin,totalX)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>3117      
        </td>
        <td>
            &nbsp;&nbsp;&nbsp;
            <a href="listOwnerIndex.jsp">股東提取</a>
            <%
            int showSO=shareholder_moneyout-(shareholder_moneyout*2);
            %>
        </tD>
        <td align=right>
            <%=changeNumber(showSO)%>
        </tD>
        <td align=right>
            <%=changePercent(showSO,totalX)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>3118      
        </td>
        <td>
            &nbsp;&nbsp;&nbsp;
            現金初始化調整
        </tD>
        <td align=right>
            <u><%=changeNumber(numbers[14])%></u>
        </tD>
        <td align=right>
            <u><%=changePercent(numbers[14],totalX)%></u>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>3351         
        </td>
        <td>
            &nbsp;&nbsp;&nbsp;累積盈虧
        </tD>
        <td align=right>
            <%=changeNumber(totalIncome)%>
        </tD>
        <td align=right>
            <%=changePercent(totalIncome,totalX)%>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>3353         
        </td>
        <td>
            &nbsp;&nbsp;&nbsp;本期損益
        </tD>
        <td align=right>
        </tD>
        <td>
        </td>
    </tr>
    <tr bgcolor=ffffff class=es02>
        <td>3xxx         
        </td>
        <td align=middle>
            <%
            int sharetotal=shareholder_moneyin-shareholder_moneyout+totalIncome;
            %>

            股東權益合計:
        </tD>
        <td align=right>
            <u><%=changeNumber(sharetotal)%></u>
        </tD>
        <td align=right>
            <u><%=changePercent(sharetotal,totalX)%></u>
        </td>
    </tr>
    <tr class=es02  height=20 bgcolor=ffffff>
        <td align=left valign=middle colspan=4>
        </tD>
    </tr>
    <tr class=es02>
        <td></tD>
        <td>負債及股東權益總計</td>
        <td align=right><div class=x1><%=changeNumber(totalX)%></div></td>
        <td align=right>
            <div class=x1><%=changePercent(totalX,totalX)%></div>
        </td>
    </tr>
    </table> 
    </td>
    </tr>
    </table>

    <br>
    <br>
    <!--
    <div align=right class=es02>
    <a href="print_accounting_report.jsp?calcDate=<%=sdf.format(d)%>"><img src="pic/pdf.gif" border=0>&nbsp;輸出電子報表</a>
    </div>
    -->

</td></tr></table>   
</center>
<br>
<br>


<%@ include file="bottom.jsp"%>

<%!
    
    DecimalFormat nf = new DecimalFormat("###,##0");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    public String changeNumber(int number){

        if(number >=0)
        {
            return mnf.format(number)+"&nbsp;";
        }else{

            return "("+mnf.format(Math.abs(number))+")";
        }
    }


    public String changePercent(int number,int total){

        if(number==0 ||total==0)
        {
            return "-";
        }

        if(number >0){
            return nf.format(((float)number/(float)total*100))+"&nbsp;";
        }

        if(number <0){
            int abs=Math.abs(number);
            return "("+nf.format(((float)abs/(float)total*100))+")";
        }

        return "";
    }
%>