<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    _ws.setBookmark(ud2, "收費總覽 - " + nowMonth);
    int allbill=0;
    int alldiscount=0;
    int allShould=0;
    int allPay=0;

    while (miter.hasNext()) {
        Membr membr = miter.next();
        Vector<MembrInfoBillRecord> vbills = billMap.get(new Integer(membr.getId()));
        for (int i=0; vbills!=null && i<vbills.size(); i++) {
            MembrInfoBillRecord bill = vbills.get(i);
            int subtotal = (int) 0;
            Vector<ChargeItemMembr> fees = feeMap.get(bill.getTicketId());

            for (int j=0; fees!=null&&j<fees.size(); j++) {
                ChargeItemMembr c = fees.get(j);
                int item_discount = 0;
                Vector<DiscountInfo> discounts = discountMap.get(c.getChargeKey());
                for (int k=0; discounts!=null && k<discounts.size(); k++) {
                    item_discount += discounts.get(k).getAmount();
                } 
                subtotal += c.getMyAmount()-item_discount;
                IncomeSmallItem si = smallitemMap.get(new Integer(c.getSmallItemId()));

                allbill+=c.getMyAmount();
                alldiscount+=item_discount;
            }

            allPay+=bill.getReceived();
          }
    }

    allShould=allbill-alldiscount;
%>
 <div class=es02>&nbsp;&nbsp;<b>結帳資訊:</b></div>
    <blockquote>
    結帳狀態: 
    </blockquote>
<br>
<br>
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
                        <td align=right><%=mnf.format(allbill)%></td>
                        <tD align=right><%=mnf.format(alldiscount)%></td>
                        <td align=right><%=mnf.format(allShould)%></td>
                    </tr>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td colspan=2 align=left>&nbsp;&nbsp;&nbsp;&nbsp;繳款金額合計(C)</td><td bgcolor=ffffff align=right><%=mnf.format(allPay)%></td>
                    </tr>    
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td colspan=2 align=left>&nbsp;&nbsp;&nbsp;&nbsp;未繳金額</td><td bgcolor=ffffff align=right><%=mnf.format(allShould-allPay)%></td>
                    </tr>  
                  
                    </table>
                </td>
                </tr>    
            </table>
                </td>
                <td align=middle>
                  
                    <%
                        int xnow=(int)((float)(alldiscount)/(float)allbill*100);
                        int xpay=(int)((float)(allPay)/(float)allShould*100);
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
