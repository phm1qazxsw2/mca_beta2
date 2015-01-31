<%@ page language="java"  import="web.*,jsf.*,jsi.*" contentType="text/html;charset=UTF-8"%>
<% 
	StudentAccount[] sa=jt.getStudentAccountByStuId(studentId);

	if(sa==null)
 
	{ 
		out.println("<br><br><blockquote><div class=es02>目前沒有交易資料</div></blockquote>");	
%>
        <%@ include file="bottom.jsp"%>
<%		
		return;
	}  
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
	
	UserMgr umx=UserMgr.getInstance();
 
	CostpayMgr cpm=CostpayMgr.getInstance(); 
	
	BankAccountMgr bam2=BankAccountMgr.getInstance();
	TradeaccountMgr tam=TradeaccountMgr.getInstance();	 
%>
 
<%
if(studentId!=0)
{
%>
<b>&nbsp;&nbsp;&nbsp;&nbsp;學費帳戶-交易記錄</b> 
<br>
    <centeR>
<%
}else{
%>
    
  <div class=es02><font color=red>不明匯款來源-交易紀錄</font></div>
  <br>
  <center>
<%
}
%>

    <table width="96%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
	
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>登入日期</td>
<td>批號</td><td>帳號</td><td>存入</td><td>支出</td>
<td>小計</td>
<td>登入人</td><td>交易帳戶</td><td>備註</td><td></td>
	</tr>
	<% 
        PayFeeMgr pfm=PayFeeMgr.getInstance();
		int total=0;
		for(int i=0;i<sa.length;i++)	
		{ 
			if(sa[i].getStudentAccountIncomeType()==0)
				total+=sa[i].getStudentAccountMoney();
			else
				total-=sa[i].getStudentAccountMoney();	
        
            PayFee pf=null;
	%>
        <tr bgcolor=#ffffff class=es02>
		
            <td><%=sdf.format(sa[i].getStudentAccountLogDate())%></td>
		    <td>
			<%
				if(sa[i].getStudentAccountRootSAId()!=0)
 
			        out.println("&nbsp;&nbsp;&nbsp;"+sa[i].getStudentAccountRootSAId());
	
                else
                    out.println("<font color=blue>"+sa[i].getId()+"</font>");
            %>
		    </td>
		    <td>
			<%
				switch(sa[i].getStudentAccountSourceType()){
					
					case 1:
						out.println("<img src=\"pic/feeIn.png\">&nbsp;學費收入-虛擬帳號");
                        out.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;存入帳號:"+sa[i].getStudentAccountNumber());
						break;
					case 2:
						out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;學費沖帳<br>");
                        pf=(PayFee)pfm.find(sa[i].getStudentAccountSourceId());
                        if(pf !=null)
                            out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;銷帳流水號: "+pf.getPayFeeFeenumberId());
						else
                            out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;系統發生錯誤");
                        break;				
					case 3:
						out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;帳戶餘額退費");
						break;			
					case 4:
                        out.println("<img src=\"pic/feeIn.png\">&nbsp;學費收款-臨櫃繳款");
                        out.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;存入帳號:"+sa[i].getStudentAccountNumber());
						break;
                    case 5:
                        out.println("<img src=\"pic/feeIn.png\">&nbsp;學費收款-便利商店");
                        out.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;存入帳號:"+sa[i].getStudentAccountNumber());
						break;				
                    case 6:
						out.println("<img src=\"pic/feeIn.png\">&nbsp;學費收款-約定帳號");
                        out.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;存入帳號:"+sa[i].getStudentAccountNumber());
						break;					
				} 
			%>		
            </td>	
            <td align=right><%=(sa[i].getStudentAccountIncomeType()==0)?mnf.format(sa[i].getStudentAccountMoney()):""%></td>
            <td align=right><%=(sa[i].getStudentAccountIncomeType()==1)?mnf.format(sa[i].getStudentAccountMoney()):""%></td>
            <td align=right><b><%=mnf.format(total)%></b></td>
            <td>
            <%
                User u=(User)
 umx.find(sa[i].getStudentAccountLogId());
		
                if(u!=null)	 
                     out.println(u.getUserFullname());
            %>
            </td> 
 
		    <tD>
		
            <% 
			if(sa[i].getStudentAccountRootSAId()==0)
 
			{ 
                
				Costpay[] cp=jt.getCostpayByStudentAccount(sa[i].getId());
			    
                if(cp !=null)
                {
                    if(cp[0].getCostpayAccountType()==1)	
                    {
                        Tradeaccount  td=(Tradeaccount)tam.find(cp[0].getCostpayAccountId()); 
                        out.println("<img src=\"pic/people.png\" border=0> 個人零用金:<br>"+td.getTradeaccountName());

                    }else if(cp[0].getCostpayAccountType()==2){
                            
                        BankAccount ba=(BankAccount)bam2.find(cp[0].getCostpayAccountId()); 
                        out.println("<img src=\"pic/bank.png\" border=0> 銀行帳戶:<br>"+ba.getBankAccountName());
                    }		
                }
			}			
		%>
		</td>
 
        <td>
            <%=(sa[i].getStudentAccountPs()==null)?"":sa[i].getStudentAccountPs()%>
        </td>
		
        <td> 
		<%
			if(sa[i].getStudentAccountSourceType()==2)
 //payfee 
			{ 
		%>
			<a href="#" onClick="javascript:openwindow36('<%=sa[i].getStudentAccountSourceId()%>');return false">詳細資料</a>
		
        <%
			}
		%>		
		</td>
	</tr>	
	
    <%
		}
	%>		
	<tr class=es02> 
		<tD colspan=5 align=middle><b>帳 戶 餘 額</b></td>
		<td align=right><b><font color=blue><%=mnf.format(total)%></font></b></td>
 
		<tD colspan=3>
			<%
				if(total!=0)
 
				{ 
			%>
				[<a href="paybackStudentAccount.jsp?stuId=<%=studentId%>">退費</a>]    
			<%
				}
			%>				
		
        </td>	
	
    </tr>

	</table> 
	
	
	</td>
	</tr>
	</table>

   </center>
    <br>
    <br>
