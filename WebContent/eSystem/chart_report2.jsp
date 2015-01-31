<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    _ws.setBookmark(ud2, "收費會計科目 - " + nowMonth);
    Hashtable haFeea=new Hashtable();
    int allMoneya=0;
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
                allMoneya+=c.getMyAmount()-item_discount;
                IncomeSmallItem si = smallitemMap.get(new Integer(c.getSmallItemId()));
                if(si !=null){                
                    int[] oldTotal=(int[])haFeea.get(si.getIncomeSmallItemName());  
                    if(oldTotal ==null)
                    {
                        int[] nowTotal={(int)c.getMyAmount(),item_discount,1};
                        haFeea.put((String)si.getIncomeSmallItemName(),(int[])nowTotal);
                    }else{
                        int[] nowTotal={(int)c.getMyAmount()+oldTotal[0],item_discount+oldTotal[1],oldTotal[2]+1};
                        haFeea.put((String)si.getIncomeSmallItemName(),(int[])nowTotal);
                    }     
                }
            }
        }
    }  
%>
 <div class=es02>&nbsp;&nbsp;<b>收費項目統計:</b></div><br>
       <center>
                <table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                    <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#f0f0f0 class=es02>
                        <td>收費項目</td>
                        <td>開單金額</td>
                        <tD>折扣金額</td>
                        <td align=middle>應收小計</TD>
                        <td align=middle>筆數</TD>
                        <TD align=middle>應收總比例</td>
                    </tr> 
<%

    Enumeration keys2a=haFeea.keys();
    Enumeration elements2a=haFeea.elements();

    int totalNumFeea=0;
    String chlStringa="";
    String tStringa="";
    int startChara=64;
    int tIncome1a=0;
    int tIncome2a=0;
    int tIncome3a=0;  

    while(elements2a.hasMoreElements())
    {
        startChara++;
        totalNumFeea ++;
        String key=(String)keys2a.nextElement();
        int[] incomeTotal=(int[])elements2a.nextElement();

        int finaltotal=incomeTotal[0]-incomeTotal[1];
        tIncome1a+=incomeTotal[0];
        tIncome2a+=incomeTotal[1];
        tIncome3a+=finaltotal;
        float fPercent=(float)((float)finaltotal/(float)allMoneya)*100;
        String percentX=nf.format(fPercent);
        
        if(startChara !=65)
        {
            chlStringa+="|";
            tStringa+=",";
        }
        tStringa+=String.valueOf((int)fPercent);
        chlStringa+=(char)startChara;
    %>
    <tr bgcolor=ffffff class=es02>
        <td align=left>
            <%=(char)startChara%>.&nbsp;<%=key%>
        </td>
        <td align=right><%=mnf.format(incomeTotal[0])%></td>
        <td align=right><%=mnf.format(incomeTotal[1])%></td>                    
        <td align=right><%=mnf.format(finaltotal)%></td>
        <td align=right><%=incomeTotal[2]%></td>        
        <td align=right><%=percentX%> %</tD>
    </tr>
    <%
    }
    %>
<tr class=es02 bgcolor=#f0f0f0>
    <tD>合計</tD>
    <tD align=right><%=mnf.format(tIncome1a)%></td>
    <tD align=right><%=mnf.format(tIncome2a)%></td>                    
    <tD align=right><%=mnf.format(allMoneya)%></td>
    <td></td>
    <td></td>
</tr>
    </table>
    </td>
    </tr>
    </table> 
    </center> 
    <BR>
    <BR>
   <div class=es02>&nbsp;&nbsp;<b>收費項目統計圖示:</b></div><br>  
    
<center>
                    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tStringa%>&chs=400x230&chl=<%=chlStringa%>&chco=00EF00" border=0>
</center>    
            <br>
            <br>

