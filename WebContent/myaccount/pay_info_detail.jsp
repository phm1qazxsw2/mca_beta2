<%@ page language="java"  import="phm.ezcounting.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%


    Membr membr = MembrMgr.getInstance().find("id=" + sid);
    ArrayList<BillPayInfo> history = BillPayInfoMgr.getInstance().retrieveList("billpay.membrId=" + sid, "");
    Iterator<BillPayInfo> iter = history.iterator();
    SimpleDateFormat sdfPay = new SimpleDateFormat("yyyy/MM/dd");
    DecimalFormat mnf = new DecimalFormat("###,###,##0");
    int total = (int)0;
    Map<Integer, Vector<User>> userMap = new SortingMap().doSort(users2, new ArrayList<User>(), "getId");
%>
	
<b>&nbsp;&nbsp;<font color=blue><%=(membr!=null)?membr.getName():"不明帳號"%></font>
&nbsp;&nbsp;個人帳戶交易記錄</b> 
<br>
<br>
<%
    if (history.size()==0) {
        out.println("<blockquote>沒有繳費記錄</blockquote>");
        return;
    }
%>

<center>
<table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>登入日期</td>
        <td>帳號</td>
        <td>存入</td>
        <td>支出</td>
        <td>小計</td>
        <td>登入人</td>
        <td>備註</td>
	</tr>
<%
    while(iter.hasNext()) {
        BillPayInfo b = iter.next(); 
        total += b.getAmount();
        int subtotal = b.getAmount();
%>
    <tr bgcolor=#ffffff class=es02>		
        <td><%=sdfPay.format(b.getRecordTime())%></td>
        <td>
            <img src="../eSystem/pic/feeIn.png"> 學費收款-<%  
            if (b.getVia()==BillPay.VIA_INPERSON)
                out.println("臨櫃繳款");
            else if (b.getVia()==BillPay.VIA_ATM)
                out.println("ATM繳款");
            else if (b.getVia()==BillPay.VIA_STORE)
                out.println("便利商店代收");
            else
                out.println("其他");
            %>	
        </td>	
        <td align=right><%=mnf.format(b.getAmount())%></td>
        <td align=right></td>
        <td align=right><b><%=mnf.format(subtotal)%></b></td>
        <td><%=(b.getUserId()==0)?"系統":getUserName(b.getUserId(), userMap)%></td>  
        <td>
        </td>		
    </tr>	
<%

        ArrayList<BillPaidInfo> paidhistory = BillPaidInfoMgr.getInstance().retrieveList("billPayId=" + b.getId(), "");
        Iterator<BillPaidInfo> iter2 = paidhistory.iterator();
        while (iter2.hasNext()) {
            BillPaidInfo p = iter2.next();
            total -= p.getPaidAmount();
            subtotal -= p.getPaidAmount();
%>
    <tr bgcolor=#ffffff class=es02>
        <td><%=sdfPay.format(p.getPaidTime())%></td>
        <td>
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;學費沖帳<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;銷帳流水號: <%=p.getTicketId()%>
    
        </td>	
        <td align=right></td>
        <td align=right><%=mnf.format(p.getPaidAmount())%></td>

        <td align=right><b><%=mnf.format(subtotal)%></b></td>
        <td> 
             <%=(b.getUserId()==0)?"系統":getUserName(b.getUserId(), userMap)%>
        </td> 
        <td>   
        </td>
    </tr>	

<%      }  
    }
%>

    <tr class=es02> 
        <td colspan=4 align=middle><b>帳 戶 餘 額</b></td>
        <td align=right><b><font color=blue><%=mnf.format(total)%></font></b></td>
        <td colspan=3>
        </td>	
    </tr>
    </table> 

</td>
</tr>
</table>

</center>
<br>
<br>

<%!
    public String getUserName(int uid, Map<Integer,Vector<User>> userMap)
    {
        Vector<User> vu = userMap.get(new Integer(uid));
        if (vu==null)
            return "###";

        if(vu.get(0).getUserFullname().length()>0)
            return vu.get(0).getUserFullname();
        else
            return vu.get(0).getUserLoginId();
    }

%>