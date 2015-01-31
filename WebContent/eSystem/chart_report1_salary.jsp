<%@ page language="java"  
    import="web.*,jsf.*,java.util.*,java.text.*,phm.ezcounting.*" 
    contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    _ws.setBookmark(ud2, "薪資項目統計 - " + nowMonth);
    Hashtable haFee=new Hashtable();
    int allMoney=0;
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
                allMoney+=c.getMyAmount()-item_discount;
                int[] oldTotal=(int[])haFee.get(c.getChargeName());  
                if(oldTotal ==null)
                {
                    int[] nowTotal={(int)c.getMyAmount(),item_discount,1};
                    haFee.put((String)c.getChargeName(),(int[])nowTotal);
                }else{
                    int[] nowTotal={(int)c.getMyAmount()+oldTotal[0],item_discount+oldTotal[1],oldTotal[2]+1};
                    haFee.put((String)c.getChargeName(),(int[])nowTotal);
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
                        <td align=middle>應收小計</TD>
                        <td align=middle>筆數</TD>
                        <TD align=middle>應收總比例</td>
                    </tr> 
<%

    Enumeration keys2=haFee.keys();
    Enumeration elements2=haFee.elements();

    int totalNumFee=0;
    String chlString="";
    String tString="";
    int startChar=64;
    int tIncome1=0;
    int tIncome2=0;
    int tIncome3=0;  

    boolean runX=false;
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
        String percentX=nf.format(fPercent);
        
        if(finaltotal>=0)
        {
            if(runX)
            {
                chlString+="|";
                tString+=",";
            }
            tString+=String.valueOf((int)fPercent);
            chlString+=(char)startChar;
            runX=true;
        }
    %>
    <tr bgcolor=ffffff class=es02>
        <td align=left>
            <%=(char)startChar%>.&nbsp;<%=key%>
        </td>
        <td align=right><%=(finaltotal<0)?"("+Math.abs(finaltotal)+")":mnf.format(finaltotal)%></td>
        <td align=right><%=incomeTotal[2]%></td>        
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
                    <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=tString%>&chs=400x230&chl=<%=chlString%>&chco=94B6D6,F7B639,AD657B" border=0>
</center>    
            <br>
            <br>

