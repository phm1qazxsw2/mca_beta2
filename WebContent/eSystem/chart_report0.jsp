<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    ArrayList<TagMembrInfo> ordered_membrs = null;
    ArrayList<Tag> tags = TagMgr.getInstance().retrieveList("typeId=" + ordr, "");
    if (tags.size()>0) {
        String tagIds = new RangeMaker().makeRange(tags, "getId");
        ordered_membrs = TagMembrInfoMgr.getInstance().retrieveList("tagId in (" + tagIds + ")", "");
        System.out.println("ordered_membrs.size=" + ordered_membrs.size());
    }
 
    if (ordered_membrs==null) 
        ordered_membrs = TagMembrInfoMgr.getInstance().retrieveList("", "group by membrId");

    Map<Integer/*membrId*/, Vector<Membr>> membrMap = new SortingMap(membrs).doSort("getId");

    _ws.setBookmark(ud2, "帳單明細 - " + nowMonth);

%>
<div class=es02>&nbsp;&nbsp;<b>帳單明細:</b></div>
<br>
<center>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
    <tr align=left valign=top>
    <td bgcolor="#e9e3de">
        <table width="100%" border=0 cellpadding=4 cellspacing=1>
            <tr bgcolor=#f0f0f0 class=es02>
            <td>繳款人</td>
            <td width=100 align=middle>帳單流水號/名稱</td>
            <td>應付金額</td>
            <td width=280>
                <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr class=es02>
                        <td width=100 align=left>收費項目</td>
                        <td width=60 align=right>開單金額</td>
                        <td width=60 align=right>折扣金額</td>
                        <td width=60 align=right>應收金額</td>
                    </tr>
                </table>
            </td>
            </tr>
            <%
                Iterator<TagMembrInfo> tmiter = ordered_membrs.iterator();
                int a=0, b=0;
                TagMembrInfo emptyInfo = new TagMembrInfo();
                emptyInfo.setTagName("未定");
                while (tmiter.hasNext() || membrMap.size()>0) {
                    TagMembrInfo tmembr = null;
                    Membr membr = null;
                    if (tmiter.hasNext()) {
                        tmembr = tmiter.next();
                        Vector<Membr> mv = membrMap.get(new Integer(tmembr.getMembrId()));
                        if (mv==null) {
                            b ++;
                            continue;
                        }
                        a ++;
                        membr = mv.get(0);
                    }
                    else {
                        Set<Integer> s = membrMap.keySet();
                        Iterator<Integer> kiter = s.iterator();
                        Vector<Membr> mv = membrMap.get(kiter.next());
                        tmembr = emptyInfo;
                        membr = mv.get(0);
                    }
                    membrMap.remove(new Integer(membr.getId()));
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
                                <%=tmembr.getTagName()%>-<br><%=membr.getName()%>
                                <br>
                                (共<%=vbills.size()%>張)
                            </td>
                    <%  }else if(vbills.size()==1){   %>
                            <td class=es02>
                                <%=tmembr.getTagName()%>-<br><%=membr.getName()%>
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
    <a href="bill_detail.jsp?sid=<%=membr.getId()%>&rid=<%=bill.getBillRecordId()%>&backurl=<%=java.net.URLEncoder.encode("billrecord_chart.jsp?month="+monstr+"&type=0")%>"><font color=blue><%=bill.getBillRecordName()%></font></a></td>
                            </tr>
                        </table>
                    </td>
                   <%
                        int nowTotalX=bill.getReceivable()-bill.getReceived();
                    %>
                    <td valign=top bgcolor=<%=(nowTotalX>0)?"4A7DBD":"F77510"%>>
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
                            <a href="bill_detail.jsp?sid=<%=membr.getId()%>&rid=<%=bill.getBillRecordId()%>&backurl=billrecord_chart.jsp?month=<%=monstr%>&type=<%=type%>"><font color=white>
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
                                <td width=100 align=left>
                                     <img src="img/flag2.png" border=0>&nbsp;<%=c.getChargeName()%>
                                </td>
                                <td width=60 align=right>
                                    <%=mnf.format(c.getMyAmount())%>
                                </td>
                                <td width=60 align=right>
                                    <%=mnf.format(item_discount)%> 
                                </td>
                                <td width=60 align=right>
                                    <%=mnf.format(c.getMyAmount()-item_discount)%>
                                </td>
                            </tr>
                    <%  }  %>                        
                    </table>
                  </td>
                </tr>
            <%      }
                
                }
System.out.println("## membrMap.size=" + membrMap.size() + " a=" + a + " b=" + b);
            %>

            </table>       
        </td>
        </tr>
        </table>
    </center>
            <br>
            <br>

