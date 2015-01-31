<%@ page language="java" buffer="32kb" 
import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<br>
<%
    request.setCharacterEncoding("UTF-8");
	DecimalFormat mnf = new DecimalFormat("###,###,##0");

	JsfAdmin ja=JsfAdmin.getInstance();

	
	JsfPay jp = JsfPay.getInstance();
 

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");


    Date endDate = new Date();
    try { endDate=sdf.parse(request.getParameter("endDate")); } catch (Exception e) {}
    Date startDate =new Date();
    try { startDate=sdf.parse(request.getParameter("startDate")); } catch (Exception e) {}

%>
    <div class=es02>    
    &nbsp;&nbsp;&nbsp;<b>現金流量報表</b>


         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   入帳日期&nbsp;起:<b><%=sdf.format(startDate)%></b>
                至:
                <b><%=sdf.format(endDate)%>
    </div>		

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>	

    <br>
<center>
<form>
<input type="button" value="列印本頁" onClick="window.print()" />
</form>
</center>

    <%
        TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
        BankAccountMgr bam2=BankAccountMgr.getInstance();

        Costpay[] cp=jp.getCashTypeDateCostpay(startDate,endDate, _ws2.getBunitSpace("bunitId"));

        if(cp==null){
    %>
        <blockquote>
            <div class=es02>
                所指定的日期沒有資料.
            </div>
        </blockquote>
    <%

        }else{
    %>
<div class=es02 align=right>
    本次搜尋合計:<font color=blue><%=cp.length%></font> 筆&nbsp;&nbsp;&nbsp;&nbsp;
</div>
<center>
    <table width="95%" border=1 cellpadding=4 cellspacing=1>
		<td bgcolor=#f0f0f0 class=es02>序號</td>
		<td bgcolor=#f0f0f0 class=es02 width=80>登入日期</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle>交易帳戶</td>
		<td bgcolor=#f0f0f0 class=es02 align=middle>交易明細</td>
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle>支出</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle>存入</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle>小計</td>	
        </tr>
    <%
            int totalIn=0;
            int totalOut=0;
            CostpayDescription cpd = new CostpayDescription(cp);
            for(int i=0;i<cp.length;i++)
            {
                String[] outTitle = jp.showCostpayTitle(cp[i], ud2, cpd, "cashflow.jsp");
                
                int type=cp[i].getCostpayAccountType();
                int bid=cp[i].getCostpayAccountId();

                String accName="";

                totalIn+=cp[i].getCostpayIncomeNumber();
                totalOut+=cp[i].getCostpayCostNumber();
                

                if(type==2)
                {
                    BankAccount  banNow=(BankAccount)bam2.find(bid);
                    accName=banNow.getBankAccountName();
                }else{
            		Tradeaccount tradeA=(Tradeaccount)tam.find(bid);
                    accName=tradeA.getTradeaccountName();
                }
    %>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02><%=cp[i].getId()%></td>
            <td class=es02><%=sdf.format(cp[i].getCostpayDate())%></td>
            <td class=es02><%=accName%></td>
            <td class=es02>
                <%=outTitle[0]%>
                <%=((cp[i].getCostpayIncomeNumber()==0 && cp[i].getCostpayCostNumber()==0))?"(已刪除)":""%>
            </td>
            <td class=es02 align=right> 
                <%=(cp[i].getCostpayCostNumber()!=0)?mnf.format(cp[i].getCostpayCostNumber()):"&nbsp;"%>
            </td>
            <td class=es02 align=right>
                <%=(cp[i].getCostpayIncomeNumber()!=0)?mnf.format(cp[i].getCostpayIncomeNumber()):"&nbsp;"%>
            </td>
            <td class=es02 align=right>
                <%=mnf.format(totalIn-totalOut)%>
            </td>

        </tr>
    <%
            }
%>
    <tr class=es02>
        <td colspan=4 align=middle>
            小&nbsp;&nbsp;計
        </tD>
        <tD align=right><b><%=mnf.format(totalOut)%></b></tD>
        <tD align=right><b><%=mnf.format(totalIn)%></b></tD>
        <tD align=right><b><%=mnf.format(totalIn-totalOut)%></b></tD>
    </tr>
    </table>
  
    <%
    }
    %>

    </center>
