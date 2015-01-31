<%@ page language="java"  import="web.*,jsf.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenuAdvanced.jsp"%>
<%@ include file="leftMenu11.jsp"%>

<br>
<%

    if(checkAuth(ud2,authHa,400) && !checkAuth(ud2,authHa,401)){

        response.sendRedirect("myShowCostPay.jsp");
    }
            

    DecimalFormat nf = new DecimalFormat("###,##0.00");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    JsfAdmin ja=JsfAdmin.getInstance();
    SalaryAdmin sa=SalaryAdmin.getInstance();

    JsfPay jp=JsfPay.getInstance();
    Tradeaccount[] tradeA=jp.getAllTradeaccount(_ws.getBunitSpace("bunitId"));
    _ws.setBookmark(ud2, "現金帳戶總覽");
%>
<script>
 
	function showAccount(divName,accountName,web1,web2,web3)
	{ 
		var s="<font color=blue>"+accountName+"</font><br>欄位一:"+web1+"<br>"+"欄位二:"+web2+"<br>"+"欄位三:"+web3;
		
		document.getElementById(divName).innerHTML=s; 
	}
</script>
<div class=es02>
<b>&nbsp;&nbsp;&nbsp;現金帳戶總覽</b>
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>  

<blockquote>
<%
    if(checkAuth(ud2,authHa,402))
    {
%>
<div class=es02>
&nbsp;<a href="addInsideTrade.jsp"><img src="pic/insidetradex.png" border=0>&nbsp;新增內部轉帳</a>
</div>
<%  }   %>
<br>
<table class=es02 border=0 width=88%>
    <!--###### 零用金帳戶 ######## -->
    <tr class=es02 height=20>
        <td align=left valign=middle>
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr width=100%>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                    <td width=90%  bgcolor=#696a6e class=es02>
                        <font color=ffffff>&nbsp;&nbsp;<img src="pic/casex.png" border=0>&nbsp;&nbsp;<b>零用金帳戶</b></font>
                    </td>
                    <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                    </td>
                    <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                </tr>
            </table>
        </tD>
        </tr>
        <tr class=es02  height=10>
        <td align=left valign=middle>
        </tD>
    </tr>
    <tr>
       <tD width=95%>

        <table width=100% border=0>
        <tr>
        <td width=25% align=middle>

<%
    int startChar=96;
    int[] charHeight=new int[61];

    for(int i=0;i<26;i++)
        charHeight[i]=65+i;

    for(int i=26;i<52;i++)
        charHeight[i]=71+i;

    for(int i=52;i<61;i++)
        charHeight[i]=i-4;

    int tradeNum[]=null;
    int[][] tradeSum=null;
    int totalAccount=0;
		boolean showTotal=true;
    Costpay[] cp=jp.getAccountType1Costpay();
    Esystem esys=(Esystem) ObjectService.find("jsf.Esystem", "id=1");

    if(tradeA==null)
    {
%>
    <div class=es02>目前沒有零用金帳戶.
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   

    <%    if(AuthAdmin.authPage(ud2,3)){ %>
    <a href="javascript:openwindow_phm('addTradeaccount.jsp','新增零用金帳號',350,400,true);"><img src="pic/add.gif" width=15 border=0>&nbsp;新增零用金帳號</a> 

    <%  }   %>
    </div>
    <br>        
<%
    }else{ 

        String chlStringa="";
        String tStringa="";
        tradeSum=new int[tradeA.length][3];
        for(int j=0;j<tradeA.length;j++)
        {
            IncomeCost ic = jp.getIncomeCost(1, tradeA[j].getId(), 99, 99, null);
            tradeSum[j][0] = ic.getCost();
            tradeSum[j][1] = ic.getIncome();
            tradeSum[j][2] = ic.getIncome() - ic.getCost();
            totalAccount += tradeSum[j][2];
        }

        // ###### 畫餅圖的東東 ######
        String[] perCent=new String[tradeA.length];
        for(int j=0;j<tradeA.length;j++){
            
            startChar++;
            if(startChar !=97){
                chlStringa+="|";
            }
            chlStringa+=(char)startChar; 
            
            float fPercent=((float)tradeSum[j][2]/(float)totalAccount);

            //tStringa+=String.valueOf((char)charHeight[(int)fPercent]);     
            perCent[j]=nf.format(fPercent*100);

            int iPer=0;
            if(fPercent>0) {
                iPer=(int)(fPercent*(float)60);            
                if (iPer>=60)
                    iPer = 59;
            }
            tStringa+=String.valueOf((char)charHeight[iPer]);                       
        }
        // #########################

        if (esys.getEsystemShowCash()==1) {
%>
             <img src="http://chart.apis.google.com/chart?cht=bvs&chd=s:<%=tStringa%>&chco=4A7DBD&chs=180x100&chts=000000,15&chbh=22,4&chl=<%=chlStringa%>" border=0>
<%      } %>
        </td>
        <td width=75%>

            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#ffffff align=left valign=middle>
                        <td bgcolor=#f0f0f0 class=es02 width=150 align=middle>帳戶名稱</tD>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>支出</td>
                        <td bgcolor=#f0f0f0 class=es02  width=80 align=middle>存入</td>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>餘額小計</td>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>比例</td>
                        <td bgcolor=#f0f0f0 class=es02></tD> 
                    </tr>
                    <%           
                        startChar=96;
                        for(int j=0;j<tradeA.length;j++)
                        {
                            startChar++;
                    %>
                        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
                            <td class=es02 nowrap>
                                <%=(char)startChar%>. 
                                <a href="show_costpay_detail.jsp?bankType=1&baid=<%=tradeA[j].getId()%>"><%=tradeA[j].getTradeaccountName()%></a>
                            </td class=es02>
                            <td class=es02 align=right>
                                <%=mnf.format(tradeSum[j][0])%>
                            </td>
                            <td class=es02 align=right>
                                <%=mnf.format(tradeSum[j][1])%>
                            </tD>
                            <td class=es02  align=right>
                                <%=mnf.format(tradeSum[j][2])%>
                            </tD>	
                            <td class=es02 align=right>
                                <%=perCent[j]%>%
                            </td>
                            <td class=es02 nowrap>
                                <a href="show_costpay_detail.jsp?bankType=1&baid=<%=tradeA[j].getId()%>">詳細資料</a>
                            </td>
                        </tr>
                    <%
                        }
                    %>
                        <tr class=es02>
                            <td align=middle colspan=3>
                                零用金帳戶餘額小計
                            </td> 
                            <tD align=right class=es02><b><%=mnf.format(totalAccount)%></b></td> 
                            <td></td>
                        </tr>
                    </table>
                    
                    </td>
                    </tr>
                </table>
<%  }   %>           
                </td>
                </tr>
            </table>
            </td>
        </tr>

    <!--###### 銀行帳戶 ######## -->
    <tr class=es02 height=20>
        <td align=left valign=middle>
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<img src="pic/bank.png" border=0>&nbsp;&nbsp;<b>銀行帳戶</b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
            </table>
            </tD>
        </tr>
        <tr class=es02  height=10>
            <td align=left valign=middle>
            </tD>
        </tr>
        <tr>
            <tD width=95%>

            <table width=100% border=0>
            <tr>
                <td width=25% align=middle>
<%
		int bcostTotal=0;
		int  bincomeTotal=0;

        int totalbank=0;
        BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId"));

		if(ba==null)
		{
%>
        <div class=es02>
            目前沒有銀行帳戶.
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   
    <%    if(AuthAdmin.authPage(ud2,3)){ %>     
            <a href="javascript:openwindow_phm('addBankAccount.jsp','新增銀行帳戶',500,550,true);"><img src="pic/add.gif" width=15 border=0>&nbsp;新增銀行帳戶</a> 
    <%      }   %>        
        </div><br>
<%
		}else{

            Costpay[] bcp=jp.getAccountType2Costpay();

            String chlStringa="";
            String tStringa="";
            int[][] bankSum=new int[ba.length][3];
            for(int j=0;j<ba.length;j++)
            {
                IncomeCost ic = jp.getIncomeCost(2, ba[j].getId(), 99, 99, null);
                bankSum[j][0] = ic.getCost();
                bankSum[j][1] = ic.getIncome();
                bankSum[j][2] = ic.getIncome() - ic.getCost();
                totalbank += bankSum[j][2];
            }

            int startChar2=64;
            //String chlStringa="";
            //String tStringa="";
            String[] perCent=new String[ba.length];
            for(int j=0;j<ba.length;j++){
                startChar2++;
                if(startChar2 !=65){
                    chlStringa+="|";
                }
                chlStringa+=(char)startChar2; 
                float fPercent=((float)bankSum[j][2]/(float)totalbank);
                int iPer=0;
                if(fPercent>0) {
                    iPer=(int)(fPercent*(float)60);
                    if (iPer>=60)
                        iPer = 59;
                }
                perCent[j]=nf.format(fPercent*100);
                tStringa+=String.valueOf((char)charHeight[iPer]);                       
            }     
    if (esys.getEsystemShowCash()==1) {

        if(ud2.getUserRole()<=3){
%>
             <img src="http://chart.apis.google.com/chart?cht=bvs&chd=s:<%=tStringa%>&chco=F77510&chs=180x100&chts=000000,15&chbh=22,4&chl=<%=chlStringa%>" border=0>
<%  } 
        }
%>
                </td>
                <td width=75%>

                <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">


                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#ffffff align=left valign=middle>
                        <td bgcolor=#f0f0f0 class=es02 width=150 align=middle>帳戶名稱</tD>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>支出</td>
                        <td bgcolor=#f0f0f0 class=es02  width=80 align=middle>存入</td>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>餘額小計</td>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>比例</td>
                        <td bgcolor=#f0f0f0 class=es02></tD> 
                    </tr>
<%		

        startChar2=64;
		for(int j=0;j<ba.length;j++)
		{
            startChar2++;

            boolean runOk=(ud2.getUserRole()>3 && !ja.isAuthBank(ba[j].getId(),ud2.getId()));

            if(runOk){
                showTotal=false;
                continue;
            }
	%>
        <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>

				<td class=es02 nowrap>
					<%=(char)startChar2%>. 
                    <%  if(!runOk){ %>
    					<a href="show_costpay_detail.jsp?bankType=2&baid=<%=ba[j].getId()%>">
                            <%=ba[j].getBankAccountName()%>
                        </a>
                    <%  }else{  %>
                            <%=ba[j].getBankAccountName()%>
                    <%  }   %>
                    <%
                    if(!runOk){
                        if(ba[j].getBankAccountWebAddress() !=null && ba[j].getBankAccountWebAddress().length()>0){
                    %>
						<a href="<%=ba[j].getBankAccountWebAddress()%>" onMouseOver="javascript:showAccount('showWeb','<%=ba[j].getBankAccountName()%>','<%=ba[j].getBankAccountWeb1()%>','<%=ba[j].getBankAccountWeb2()%>','<%=ba[j].getBankAccountWeb3()%>')" target="_blank">[網銀]</a>
                    
                    <%  }else{  %>
                    [<a href="#" onClick="javascript:openwindow551('<%=ba[j].getId()%>');return false"><img src="pic/fix.gif" border=0 width=10>設定</a>]
                    <%  }   
                    }
                    %>

				</td>
				<td class=es02 align=right>
				    <%=(!runOk)?mnf.format(bankSum[j][0]):"***"%>
				</td>
				<td class=es02 align=right>
                    <%=(!runOk)?mnf.format(bankSum[j][1]):"***"%>
				</tD>
				<td class=es02  align=right>
                    <%=(!runOk)?mnf.format(bankSum[j][2]):"***"%>	
				</tD>
                <td class=es02  align=right nowrap>
                <%=(showTotal)?perCent[j]+" %":"***"%> 
                </td>		
				<td class=es02 nowrap>
                <%  if(!runOk){  %>
					<a href="show_costpay_detail.jsp?bankType=2&baid=<%=ba[j].getId()%>">詳細資料</a>
                <%  }   %>
 				</td>
			</tr>
	<%
		}
	%>
	<tr class=es02>
		<td colspan=3 align=middle>
            銀行帳戶餘額小計
        </td>
		<tD align=right><b><%=(showTotal)?mnf.format(totalbank):"***"%></b></td>  
	</tr>
	</table>
	
	</td>
	</tr>
	</table>            
<%    

            }
%>
                </td>
            </tr>
            </table>
        </td>
        </tr>


    <!--######  支票 ######## -->
<%
    if(ud2.getUserRole()>=4){
%>

<div class=es02>
    <b>***由於權限不足,部分帳戶無法顯示.</b>
</div>	

</td>
</tr>
</table>

</tD>
</tr>
</table>

	
    <br>
    <br>
    
    <%@ include file="bottom.jsp"%>
<%
        return;
    }

    VoucherService vsvc = new VoucherService(0, _ws.getSessionBunitId());
    VchrItemSum sum_in = vsvc.getAccountBalance(VoucherService.CHEQUE_RECEIVABLE, null);
    VchrItemSum sum_out = vsvc.getAccountBalance(VoucherService.CHEQUE_PAYABLE, null);
    int totalCheque = (int) (sum_in.getDebit()-sum_in.getCredit()-(sum_out.getCredit()-sum_out.getDebit()));
%>
    <tr class=es02 height=20>
        <td align=left valign=middle>
            <table width="100%" border=0 cellpadding=0 cellspacing=0>
                <tr width=100%>
                    <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                    <td width=90%  bgcolor=#696a6e class=es02>
                        <font color=ffffff>&nbsp;&nbsp;<img src="pic/cheque.png" border=0>&nbsp;&nbsp;<b>支票帳戶</b></font>
                    </td>
                    <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                    </td>
                    <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                </tr>
            </table>
        </tD>
    </tr>
    <tr class=es02  height=10>
        <td align=left valign=middle>
        </tD>
    </tr>

    <tr>
       <tD width=95%>

        <table width=100% border=0>
        <tr>
        <td width=25% align=middle>


        </td>
        <td width=75%>

            <table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
                <tr align=left valign=top>
                <td bgcolor="#e9e3de">
                <table width="100%" border=0 cellpadding=4 cellspacing=1>
                    <tr bgcolor=#ffffff align=left valign=middle>
                        <td bgcolor=#f0f0f0 class=es02 width=150 align=middle>帳戶名稱</tD>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>存入</td>
                        <td bgcolor=#f0f0f0 class=es02  width=80 align=middle>兌現</td>
                        <td bgcolor=#f0f0f0 class=es02 width=80 align=middle>小計</td>
                        <td bgcolor=#f0f0f0 class=es02></tD> 
                    </tr>
                    
                    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
                        <td class=es02 nowrap>
                            a. 
                            <a href="query_cheque.jsp">應收票據</a>
                        </td class=es02>
                        <td class=es02 align=right>
                            <%=mnf.format(sum_in.getDebit())%>
                        </td>
                        <td class=es02 align=right>
                            <%=mnf.format(sum_in.getCredit())%>
                        </tD>
                        <td class=es02  align=right>
                            <%=mnf.format(sum_in.getDebit()-sum_in.getCredit())%>
                        </tD>	
                        <td class=es02 align=right nowrap>
                            <a href="query_cheque.jsp">詳細資料</a>
                        </td>
                    </tr>

                    <tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
                        <td class=es02 nowrap>
                            b. 
                            <a href="query_cheque.jsp">應付票據</a>
                        </td class=es02>
                        <td class=es02 align=right>
                            <%=mnf.format(sum_out.getCredit())%>
                        </td>
                        <td class=es02 align=right>
                            <%=mnf.format(sum_out.getDebit())%>
                        </tD>
                        <td class=es02  align=right>
                            <%=mnf.format(sum_out.getCredit()-sum_out.getDebit())%>
                        </tD>	
                        <td class=es02 align=right nowrap>
                            <a href="query_cheque.jsp">詳細資料</a>
                        </td>
                    </tr>
                    
                    <tr class=es02>
                        <td align=middle colspan=3>
                            支票現金餘額小計
                        </td> 
                        <tD align=right class=es02><b><%=mnf.format(totalCheque)%></b></td> 
                        <td></td>

                    </tr>
                </table>
                
                </td>
                </tr>
            </table>
           
            </td>
            </tr>
        </table>
        </td>
    </tr>    

    <!--######  總計 ######## -->

<%
    if(ba!=null || tradeA!=null){
%>


       <tr class=es02 height=20>
            <td align=left valign=middle>
                <table width="100%" border=0 cellpadding=0 cellspacing=0>
                    <tr width=100%>
                        <td width=8 align=top><img src='img/a3_left1.gif' border=0 height=25></td>              
                        <td width=90%  bgcolor=#696a6e class=es02>
                            <font color=ffffff>&nbsp;&nbsp;<b>帳戶金額合計</b></font>
                        </td>
                        <td width=10% align=right class=es02 bgcolor=#696a6e nowrap>
                        </td>
                        <td width=8 align=top><img src='pic/a3_left12.gif' border=0 height=25></td>              
                    </tr>
                </table>
            </tD>
        </tr>

        <tr class=es02  height=10>
            <td align=left valign=middle>
            </tD>
        </tr>
        <tr>
            <tD width=95%>
<%
    int total=totalAccount+totalbank + totalCheque;
    float perT=(float)totalAccount/(float)total*(float)100;
    float perB=(float)totalbank/(float)total*(float)100;
    float perC=(float)totalCheque/(float)total*(float)100;

    String accountP=nf.format(perT);
    String bankP=nf.format(perB);
    String chequeP =nf.format(perC);
%>

            <table width=100% border=0>
            <tr>
                <td width=25% align=middle>
<%
    if(showTotal){
        if (esys.getEsystemShowCash()==1) {
%>
 <img src="http://chart.apis.google.com/chart?cht=p3&chd=t:<%=accountP%>,<%=bankP%>,<%=chequeP%>&chs=180x70&chl=Cash|Bank|Check&chco=4A7DBD,F77510,F0F0F0" border=0>
<%      }
    }   %>
                </td>
                <td width=75%>

<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td width=20% align=middle>零用金小計</tD>
        <td rowspan=2 bgcolor=ffffff valign=middle class=es02> +</td>
		<td width=20% align=middle>銀行帳戶小計</td>
        <td rowspan=2 bgcolor=ffffff valign=middle class=es02> +</td>
		<td width=20% align=middle>支票小計</td>
        <td rowspan=2 bgcolor=ffffff valign=middle class=es02> =</td>
		<td width=20% align=middle>合計</td>

        <%  if(!showTotal){ %>
    		<tD width=20% align=middle bgcolor=ffffff>
            說 明
        <%  }else{   

                SimpleDateFormat sdfC=new SimpleDateFormat("yyyy/MM");
				Date aDate=new Date();
        %>
    		<tD width=20% rowspan=2 align=middle bgcolor=ffffff>

			<a href="makeFinancePDF.jsp?fId=4&runDate=<%=sdfC.format(aDate)%>" target="_blank"><img src="pic/pdf.gif" border=0>輸出報表</a>
        <%  }   %>
        </tD>
	</tr>
	<tr bgcolor=#ffffff align=right valign=middle>
		<td class=es02 valign=top><%=mnf.format(totalAccount)%><br><%=(showTotal)?accountP+" %":"***"%></tD>
		<tD class=es02 valign=top><%=(showTotal)?mnf.format(totalbank):"***"%><br><%=(showTotal)?bankP+" %":"***"%></tD>
		<td class=es02 valign=top><%=(showTotal)?mnf.format(totalCheque):"***"%><br><%=(showTotal)?chequeP+" %":"***"%></tD>
		<td class=es02 valign=top><b><%=(showTotal)?mnf.format(totalAccount+totalbank+totalCheque):"***"%></b></tD> 
			<%

                if(!showTotal){
            %>
        		<tD  class=es02 align=middle nowrap>
                ***為權限不足,無法顯示.
		        </tD>
            <%  }   %>	

	</tr>
	</table>

	</tD>
	</tr>
	</table>		


                </td>
            </tr>
            </table>
        </tr>

<%  }   %>

    </table>            
</blockquote>
</ul>
<br>
<br>
<br>

<%@ include file="bottom.jsp"%>