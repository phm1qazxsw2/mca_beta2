<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
 
 <div class=es02>&nbsp;&nbsp;<b>薪資明細:</b></div>
<br>
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
            <td>員工</td>
            <td width=100 align=middle>帳單流水號/名稱</td>
            <td>應付金額</td>
            <td width=260>
                <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr class=es02>
                        <td width=150 align=left>薪資項目</td>
                        <td width=110 align=right>應付金額</td>
                    </tr>
                </table>
            </td>
            </tr>
            <%
                // 以下純粹展示，請改
                _ws.setBookmark(ud2, "薪資明細 - " + nowMonth);
                while (miter.hasNext()) {
                    Membr membr = miter.next();
                    Vector<MembrInfoBillRecord> vbills = billMap.get(new Integer(membr.getId()));
                    for (int i=0; vbills!=null && i<vbills.size(); i++) {
                        MembrInfoBillRecord bill = vbills.get(i);
                        int subtotal = (int) 0;
                        Vector<ChargeItemMembr> fees = feeMap.get(bill.getTicketId());
            %>
                <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
                    <%
                        if(vbills.size()>1 && i ==0)
                        {
                    %>
                            <td rowspan=<%=vbills.size()%> class=es02 bgcolor=ffffff>
                                <%=membr.getName()%>
                                <br>
                                (共<%=vbills.size()%>張)
                            </td>
                    <%  }else if(vbills.size()==1){   %>
                            <td class=es02>
                                <%=membr.getName()%>
                    <%  }   %>
                    <td valign=top>
                        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td rowspan=2 align=middle valign=middle>
                                    <img src="pic/bill6.gif" border=0></td>
                                <td class=es02><%=bill.getTicketId()%></td>
                            </tr>
                            <tr>
                                <td class=es02>
                                                            <a href="salary_detail.jsp?sid=<%=membr.getId()%>&rid=<%=bill.getBillRecordId()%>&backurl=salaryrecord_chart.jsp?month=<%=monstr%>&type=<%=type%>"><font color=blue><%=bill.getBillRecordName()%></font></a></td>
                            </tr>
                        </table>
                    </td>
                   <%
                        int nowTotalX=bill.getReceivable()-bill.getReceived();
                    %>
                    <td valign=middle bgcolor=<%=(nowTotalX>0)?"4A7DBD":"F77510"%>>
                        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td width=100% class=es02>
                               <font color=white>
                                應收：<%=mnf.format(bill.getReceivable())%> - 已付：<%=mnf.format(bill.getReceived())%>
                                </font>
                            </td>
                        </tr>
                        <tr>
                            <td width=100% class=es02>
                            <a href="salary_detail.jsp?sid=<%=membr.getId()%>&rid=<%=bill.getBillRecordId()%>&backurl=salaryrecord_chart.jsp?month=<%=monstr%>&type=<%=type%>"><font color=white>
                            <%  if(nowTotalX >0){   %>
                            =未付金額：<%=mnf.format(nowTotalX)%>
                            <%  }else{  %>
                            =已繳清
                            <%  }   %>
                            </font></a>
                            </td>
                        </tr>
                        </table>
                    </td>    
                    <td valign=top>
                        <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                        <%
                        for (int j=0; fees!=null&&j<fees.size(); j++) {
                            ChargeItemMembr c = fees.get(j);
                            int item_discount = 0;
                            Vector<DiscountInfo> discounts = discountMap.get(c.getChargeKey());
                            for (int k=0; discounts!=null && k<discounts.size(); k++) {
                                item_discount += discounts.get(k).getAmount();
                            } 
                            subtotal += c.getMyAmount()-item_discount;
                            IncomeSmallItem si = smallitemMap.get(new Integer(c.getSmallItemId()));
                            %>
                            <tr class=es02>
                                <td width=150 align=left>
                                     <img src="img/flag2.png" border=0>&nbsp;<%=c.getChargeName()%>
                                </td>
                                <td width=110 align=right>
                                    <%  int shouldPay=c.getMyAmount()-item_discount;    %>
                                    <%=(shouldPay<0)?"("+Math.abs(shouldPay)+")":mnf.format(shouldPay)%>
                                </td>
                            </tr>
                    <%  }  %>                        
                    </table>
                  </td>
                </tr>
            <%      }
                
                }
            %>
            </table>       
        </td>
        </tr>
        </table>
    </center>
            <br>
            <br>

