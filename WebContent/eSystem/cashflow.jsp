<%@ page language="java" buffer="32kb" 
import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2-new.jsp"%>
<%!
	static DecimalFormat mnf2 = new DecimalFormat("###,###,###.##");
    String getUSD(Costpay cp)
    {
        if (cp.getOrgAmount()>0)
            return mnf2.format(cp.getOrgAmount());
        return "";
    }

    String getCheckInfo(Costpay cp)
    {
        if (cp.getCheckInfo()!=null&&cp.getCheckInfo().length()>0)
            return cp.getCheckInfo();
        return "";
    }

%>
<br>
<%
    request.setCharacterEncoding("UTF-8");
	DecimalFormat mnf = new DecimalFormat("###,###,##0");

	JsfAdmin ja=JsfAdmin.getInstance();

	
	JsfPay jp = JsfPay.getInstance();
 

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd");

    String receiptNo = request.getParameter("receiptNo");

    Date endDate = new Date();
    try { endDate=sdf.parse(request.getParameter("endDate")); } catch (Exception e) {}
    Date startDate =new Date();
    try { startDate=sdf.parse(request.getParameter("startDate")); } catch (Exception e) {}

%>
<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>

    <div class=es02>    
    &nbsp;&nbsp;&nbsp;<b>現金流量報表</b>

	<form action="cashflow.jsp" method="get" name="xs" id="xs">
         &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   查詢現金交易區間: &nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<a href="#" onclick="displayCalendar(document.xs.startDate,'yyyy/mm/dd',this);return false">開始日期:</a>
                <input type=text name="startDate" value="<%=(startDate==null)?"":sdf.format(startDate)%>" size=7>
<a href="#" onclick="displayCalendar(document.xs.endDate,'yyyy/mm/dd',this);return false">結束日期:</a>
				<input type=text name="endDate" value="<%=sdf.format(endDate)%>" size=7>
            <input type=submit value="搜尋">
	</form> 

	<form action="cashflow.jsp" method="get" name="xs" id="xs">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            Receipt# <input type=text size=5 name="receiptNo" value="<%=(receiptNo!=null&&receiptNo.length()>0)?receiptNo:""%>">
            <input type=submit value="搜尋">
	</form> 
    
    </div>		

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>	

    <%
        TradeaccountMgr tam=TradeaccountMgr.getInstance(); 
        BankAccountMgr bam2=BankAccountMgr.getInstance();

        Costpay[] cp = null;

        if (receiptNo!=null && receiptNo.length()>0) {
            Object[] objs = CostpayMgr.getInstance().retrieve("receiptNo like '%" + receiptNo + "%'", "");
            if (objs!=null) {
                cp = new Costpay[objs.length];
                for (int i=0; i<objs.length; i++) 
                    cp[i] = (Costpay) objs[i];
            }
        }
        else {
            cp = jp.getCashTypeDateCostpay(startDate,endDate, _ws.getBunitSpace("bunitId"));
        }

        if(cp==null){
    %>
        <blockquote>
            <div class=es02>
                所指定的日期沒有資料.
            </div>
        </blockquote>
    <%

        }else{
            
            Map billpay=null;
    %>
<br>
<div class=es02 align=right>
    本次搜尋合計:<font color=blue><%=cp.length%></font> 筆 | 
&nbsp;<a target=_blank href="print_costpay_detail.jsp"> 可列印版本</a>&nbsp;&nbsp;&nbsp;&nbsp;
</div>

<div id="content">
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

    <table width="100%" border=0 cellpadding=4 cellspacing=1>
		<td bgcolor=#f0f0f0 class=es02 nowrap>序號</td>
		<td bgcolor=#f0f0f0 class=es02 width=80 nowrap>登入日期</td>
        <td bgcolor=#f0f0f0 class=es02 align=middle nowrap>交易帳戶</td>
		<td bgcolor=#f0f0f0 class=es02 align=middle nowrap>交易明細</td>
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle nowrap>支出</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle nowrap>存入</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle nowrap>小計</td>	
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle>USD</td>	
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle>CheckInfo</td>	
		<td bgcolor=#f0f0f0 class=es02 width=80 align=middle>Receipt#</td>	
		<td bgcolor=#f0f0f0 class=es02 width=50 align=middle></td>
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
                    if (type==3)
                        accName += "(臺支)";
                    else if (type==4)
                        accName += "(美現)";
                    else if (type==5)
                        accName += "(美支)";
                }
    %>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
            <td class=es02><%=cp[i].getId()%></td>
            <td class=es02><%=sdf.format(cp[i].getCostpayDate())%></td>
            <td class=es02 nowrap><%=accName%></td>
            <td class=es02 nowrap>
                <%=outTitle[0]%>
                <%=((cp[i].getCostpayIncomeNumber()==0 && cp[i].getCostpayCostNumber()==0))?"(已刪除)":""%>
            </td>
            <td class=es02 align=right> 
                <%=(cp[i].getCostpayCostNumber()!=0)?mnf.format(cp[i].getCostpayCostNumber()):""%>
            </td>
            <td class=es02 align=right>
                <%=(cp[i].getCostpayIncomeNumber()!=0)?mnf.format(cp[i].getCostpayIncomeNumber()):""%>
            </td>
            <td class=es02 align=right>
                <%=mnf.format(totalIn-totalOut)%>
            </td>
            <td class=es02 align=right>
                <%=getUSD(cp[i])%>&nbsp;
            </td>
            <td class=es02 align=left>
                <%=getCheckInfo(cp[i])%>
            </td>
            <td class=es02 align=right>
                <a target=_blank href="print_costpay_receipt.jsp?r=<%=new Date().getTime()%>&id=<%=cp[i].getId()%>"><%=cpd.getReceiptNo(cp[i])%></a>
            </td>
            <td class=es02 nowrap>
                <%=outTitle[1]%>
            </tD>
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
        <tD></tD>
    </tr>
    </table>
    </td>
    </tr>
    </table>
    <%
    }
    %>

    </center>
</div>
    <br>
    <br>
    <%@ include file="bottom.jsp"%>
