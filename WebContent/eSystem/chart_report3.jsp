<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">

<%
    _ws.setBookmark(ud2, "折扣項目統計 - " + nowMonth);
    Hashtable haFeeb=new Hashtable();
    int allDiscount=0;
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
                    allDiscount += discounts.get(k).getAmount();
                    String disName=" <a href=bill_detail.jsp?sid="+membr.getId()+"&rid="+bill.getBillRecordId()+"&backurl=billrecord_chart.jsp?month="+monstr+"&type="+type+"><font color=blue>"+membr.getName()+":"+String.valueOf(discounts.get(k).getAmount())+"</font></a> ,";

                    String[] oldWord=(String[])haFeeb.get(discounts.get(k).getDiscountTypeName());  
                    if(oldWord ==null)
                    {
                        String[] nowWord={(String)String.valueOf(discounts.get(k).getAmount()),(String)disName};
                        haFeeb.put((String)discounts.get(k).getDiscountTypeName(),(String[])nowWord);
                    }else{
                        int nowTotal=Integer.parseInt(oldWord[0])+discounts.get(k).getAmount();
                        String[] nowWord={(String)String.valueOf(nowTotal),(String)oldWord[1]+disName};
                        haFeeb.put((String)discounts.get(k).getDiscountTypeName(),(String[])nowWord);
                    }
                } 
            }   
       }
    }

%>
 <div class=es02>&nbsp;&nbsp;<b>折扣項目統計:</b></div><br>

            <%
                Enumeration keys3=haFeeb.keys();
                Enumeration elements3=haFeeb.elements();

            %>
       <center>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                    <tr align=left valign=top>
                    <td bgcolor="#e9e3de">
                        <table width="100%" border=0 cellpadding=4 cellspacing=1>
                        <tr bgcolor=#f0f0f0 class=es02>
                            <td>折扣項目</td>
                            <td>折扣金額</td>
                            <tD>折扣比例</td>
                            <td>折扣名單</td>
                        </tr> 
                        <%
                            int startCharc=64;
                            int startDis=0;                            
                            String tString2="";
                            String chlString2="";
                            while(elements3.hasMoreElements())
                            {
                                startCharc++;
                                startDis++;
                                if(startDis !=1)
                                {
                                    chlString2+="|";
                                    tString2+=",";
                                }
                                String diskey=(String)keys3.nextElement();
                                String[] disTotalS=(String[])elements3.nextElement();
                                int disTotal=Integer.parseInt(disTotalS[0]);
                                double percentX2=(double)disTotal/(double)allDiscount;
                                percentX2=percentX2*100;
                                chlString2+=(char)startCharc;
                                tString2+=String.valueOf((int)percentX2);
                        %>
                                <tr bgcolor=#ffffff class=es02>
                                    <td><%=(char)startCharc%>.&nbsp;<%=diskey%></td>
                                    <td align=right><%=mnf.format(disTotal)%></td>
                                    <tD align=right><%=(int)percentX2%>%</td>
                                    <td><%=disTotalS[1]%></td>
                                </tr> 
                        <%  }   %>

                    </table>
                        </td>
                        </tr>
                    </table>
    </center> 
    <BR>
    <BR>
   <div class=es02>&nbsp;&nbsp;<b>收費項目統計圖示:</b></div><br>  
    
    <center>
                
    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tString2%>&chs=400x230&chl=<%=chlString2%>&chco=B9BEB9" border=0>



