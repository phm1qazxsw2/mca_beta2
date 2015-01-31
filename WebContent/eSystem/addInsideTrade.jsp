<%@ page language="java"  import="web.*,jsf.*,java.io.*,phm.ezcounting.*,phm.accounting.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%
    if(!checkAuth(ud2,authHa,402))
    {
        response.sendRedirect("authIndex.jsp?code=402");
    }
%>
<%@ include file="leftMenu11.jsp"%> 
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<script type="text/javascript" src="js/string.js"></script>
<script type="text/javascript" src="js/formcheck.js"></script>

<% 
try{

    JsfAdmin ja=JsfAdmin.getInstance();
    JsfPay jp=JsfPay.getInstance();

	Tradeaccount[] tradeA=jp.getActiveTradeaccount(ud2.getId());
    SalarybankAuth[] sa1=jp.getSalarybankAuthByUserId(ud2); 
    
    Tradeaccount[] tradeB=jp.getAllTradeaccount(_ws.getBunitSpace("bunitId"));
    BankAccount[] sa2=jp.getAllBankAccount(_ws.getBunitSpace("bunitId"));
    
    if(tradeA==null && sa1==null)
    { 
        out.println("<br><br><blockquote><div class=es02><font color=red>Error</font>:沒有可用帳戶</div></blockquote>");	
%>
		<%@ include file="bottom.jsp"%>	
<%			
			return;		
    }  
		
    java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 
    VoucherService vsvc = new VoucherService(0, _ws.getSessionBunitId());
    VchrItemSum sum = vsvc.getAccountBalance(VoucherService.CHEQUE_RECEIVABLE, null);
    int ck_in = (int) ((sum==null)?0:(sum.getDebit()-sum.getCredit()));
    sum = vsvc.getAccountBalance(VoucherService.CHEQUE_PAYABLE, null);
    int ck_out = (int) ((sum==null)?0:(sum.getCredit()-sum.getDebit()));

%>

<br>
<div class=es02>
&nbsp;&nbsp;&nbsp;<img src="pic/insidetradex.png" border=0 alt="新增內部轉帳">&nbsp;<b>新增內部轉帳</b> 
</div>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>

<script>
        var ck_in = <%=ck_in%>;
        var ck_out = <%=ck_out%>;

		function  typeChange(typevalue)
		{
			if(typevalue=='1')
 
			{  
				document.payform.bankName.disabled=true;
				document.payform.tradeaccountId.disabled=false;
			}else if(typevalue=='2'){
				document.payform.bankName.disabled=false;
				document.payform.tradeaccountId.disabled=true;
			}  
		}  
		
		function  typeChange2(typevalue)
		{
 
			if(typevalue=='1')
			{  
				document.payform.TobankName.disabled=true;
				document.payform.TotradeaccountId.disabled=false;
			}else if(typevalue=='2'){
				document.payform.TobankName.disabled=false;
				document.payform.TotradeaccountId.disabled=true;
			} 
		}
        
        function dosubmit(f)
        {
            f.moneyNum.value = trim(f.moneyNum.value);
            if (!IsPositive(f.moneyNum.value)) {
                alert("請輸入大於零正確的金額");
                f.moneyNum.focus();
                return false;
            }

            if (f.type[2].checked) {
                if (!f.Totype[1].checked) {
                    alert("支票兌入轉入帳戶一定要選擇銀行");
                    return false;
                }
                else if (eval(f.moneyNum.value)>ck_in) {
                    alert("轉入金額不可超過應收票數據餘額");
                    return false;
                }
            }

            if (f.Totype[2].checked) {
                if (!f.type[1].checked) {
                    alert("支票兌出轉出帳戶一定要選擇銀行");
                    return false;
                }
                else if (eval(f.moneyNum.value)>ck_out) {
                    alert("轉出金額不可超過應付票數據餘額");
                    return false;
                }
            }

            if (!confirm('確認新增此筆內部轉帳?'))
                return false;
            return true;
        }

  	</script>


<link type="text/css" rel="stylesheet" href="css/dhtmlgoodies_calendar.css?random=20051112" media="screen"></LINK>
<SCRIPT type="text/javascript" src="js/dhtmlgoodies_calendar.js?random=20060118"></script>


<blockquote>
<form action="addInsideTrade2.jsp" method="post" name="payform" id="payform" onsubmit="return dosubmit(this)">


<table width="600" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 class=es02>
		<tD nowrap>交易日期</td> 
		<td bgcolor=#ffffff class=es02><input type=text name="tradeDate" value="<%=df.format(new Date())%>" size=10>

            &nbsp;<a href="#" onclick="displayCalendar(document.payform.tradeDate,'yyyy/mm/dd',this);return false"><img src="pic/blog4.gif" border=0></a>
</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>交易人</td>
		<td bgcolor=#ffffff class=es02><%=ud2.getUserFullname()%></td>
	</tr>	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>金額</td>
		<td bgcolor=#ffffff class=es02><input type=text name="moneyNum" value=0 size=10> <a href="showCostPay.jsp">餘額查詢</a></td>
	</tr>	
    <input type=hidden name="paywayX" value=0>
<!--
    <tr bgcolor=#f0f0f0 class=es02>
		<td>交易方式</td>
		<td bgcolor=#ffffff class=es02>
			<select size=1 name="paywayX">
							<option value=1 selectd>現金</option> 
                            <option value=2>支票</option> 	
							<option value=3>匯款</option> 	
							<option value=3>其他</option> 		
            </select>
		</td>
	</tr>
2009/1/14 by peter, 造成宗玫誤會可直接將支票存入銀行, 暫時拿掉 
-->
	<tr bgcolor=#f0f0f0 class=es02>
		<td colspan=2>
			<table>
				<tr>
					<td width=290 class=es02><b>轉出帳戶</b></td>
					<td width=20></td>
					<td width=290 class=es02><b>轉入帳戶</b></td>
				</tr>
				<tr bgcolor="ffffff">
					<tD bgcolor="ffffff">
	
			<table border=0>  
			<tr>
				<td> 
				</tD>
				<tD  width=210>
					<div id="fromPic">
						<%
						if(tradeA !=null)	
						{

							String filePath2 = request.getRealPath("./")+"accountAlbum/"+tradeA[0].getId();
							File FileDic2 = new File(filePath2);
							File files2[]=FileDic2.listFiles();
			
							File xF2=null; 
							
							if(files2 !=null)
							{ 
								for(int j2=0;j2<files2.length;j2++)
								{ 
									if(!files2[j2].isHidden())
										xF2 =files2[j2] ;
								} 
							}
							
							if(xF2 !=null && xF2.exists())
							{			
					%>
								<img src="accountAlbum/<%=tradeA[0].getId()%>/<%=xF2.getName()%>" width=150 border=0>
					<%	
							}
						}
					%>					
					</div>	
				</td> 
			</tr>	
			
            <tr>
				<td nowrap class=es02> 

            <%
					if(tradeA!=null)
 					{ 

			%>			
					<input type=radio name="type" value="1" checked onFocus="typeChange('1')">個人零用金帳戶　
				</td>	
				<td class=es02>	  
					<select size=1 name="tradeaccountId" onChange="showPicFrom('1',this.form.tradeaccountId.value,'fromPic')">
						<%
							for(int p=0;p<tradeA.length;p++)
							{
                                if(tradeA[p]!=null){
						%>
							<option value="<%=tradeA[p].getId()%>">
							<%=tradeA[p].getTradeaccountName()%>
							</option> 
						<%
                                }
							}
						%>		
					</select> 
					
					</td>
				<%
					}else{
						out.println("沒有可用之個人零用金戶頭"); 
				%> 
				</td>
				<td>
						<input type=hidden name="tradeaccountId" value="0">
				</td>
				<%
					}
				%>				

    		</tr>
    		<tr>
    			<td class=es02>		
					<%
						if(sa1==null)
						{ 
							out.println("");		
					%> 
						</td>
						<td>
							<input type=hidden name="bankName" value="0">
						
						
					<%						

						}else{
							BankAccountMgr bam=BankAccountMgr.getInstance();
 
						
						%>	
							<input type=radio name="type" value="2"  onFocus="typeChange('2')">銀行帳戶			
						</td>
						<td>
							<select size=1 name=bankName onChange="showPicFrom('2',this.form.bankName.value,'fromPic')">	
								<%
 
									for(int j=0;j<sa1.length;j++){ 
									
										BankAccount ba=(BankAccount)bam.find(sa1[j].getSalarybankAuthId());

                                        if(ba !=null){
 								%>
									<option value="<%=ba.getId()%>"><%=ba.getBankAccountName()%></option>
								<%
                                        }
									}
								%>		
							</select>
 
						<script>							
							document.payform.bankName.disabled=true;
						</script>							
					<%			
						}
					%>
                </td>
            </tr>	
            <tr>
				<td nowrap colspan=2 class=es02> 
                    <input type=radio name="type" value="3">支票(兌入應收票據 餘額: <%=ck_in%>)
                </td>
    		</tr>
            </table>

					
					</tD>
					<td> 
						 <font color=red><img src="pic/intrade.png" border=0></font>    
                    </tD>
					<td>
				
			<table border=0> 
			<tr>
				<td width=250> 
				</tD>
				<tD  width=210>
					<div id="toPic">
					<%

						if(tradeB !=null)	
						{
							String filePath2 = request.getRealPath("./")+"accountAlbum/"+tradeB[0].getId();
							File FileDic2 = new File(filePath2);
							File files2[]=FileDic2.listFiles();
			
							File xF2=null; 
							
							if(files2 !=null)
							{ 
								for(int j2=0;j2<files2.length;j2++)
								{ 
									if(!files2[j2].isHidden())
										xF2 =files2[j2] ;
								} 
							}
							
							if(xF2 !=null && xF2.exists())
							{			
					%>
								<img src="accountAlbum/<%=tradeB[0].getId()%>/<%=xF2.getName()%>" width=150 border=0>
					<%	
							}
						}
					%>
					</div>	
				</td> 
			</tr>	
			<tr>
				<td nowrap class=es02>
			<%

					if(tradeB!=null)
 					{ 
			%>			
					<input type=radio name="Totype" value="1" checked onFocus="typeChange2('1')">個人零用金帳戶　  
				</td>	
				<td>	 
					<select size=1 name="TotradeaccountId" onClick="showPicFrom('1',this.form.TotradeaccountId.value,'toPic')">
						<%
							for(int p=0;p<tradeB.length;p++)
							{
						%>
							<option value="<%=tradeB[p].getId()%>">
							<%=tradeB[p].getTradeaccountName()%>
							</option> 
						<%
							}
						%>		
					</select> 
					
					</td>
				<%
					}else{
						out.println("沒有個人零用金戶頭"); 
				%> 
				</td>
				<td>
						<input type=hidden name="TotradeaccountId" value="0">
				</td>
				<%
					}
				%>				

    		</tr>
    		<tr>
    			<td class=es02>		
					<%
						if(sa2==null)
						{ 
							out.println("沒有可用銀行帳戶");		
					%> 
						</td>
						<td>
							<input type=hidden name="TobankName" value="0">
					<%						
						}else{
					%>	
							<input type=radio name="Totype" value="2"  onFocus="typeChange2('2')">銀行帳戶			
						</td>
						<td>
							<select size=1 name=TobankName onClick="showPicFrom('2',this.form.TobankName.value,'toPic')">	
								<%
 
									for(int j=0;j<sa2.length;j++){ 
									
										//BankAccount ba=(BankAccount)bam.find(sa1[j].getSalarybankAuthId());

                                        if(sa2[j] !=null){
 								%>
									<option value="<%=sa2[j].getId()%>"><%=sa2[j].getBankAccountName()%></option>
								<%
                                        }
									}
								%>		
							</select>
 
						<script>							
							document.payform.TobankName.disabled=true;
						</script>							
					<%			
						}
					%>
                </td>
            </tr>	
            <tr>
				<td nowrap colspan=2 class=es02> 
                    <input type=radio name="Totype" value="3">支票(兌出應付票據 餘額: <%=ck_out%>)
                </td>
    		</tr>
            </table> 
			
			</td>
			</tr>
			</table>
				
				

					</td>
				</tr>
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>交易註記</td>
		<td bgcolor=#ffffff class=es02><textarea name="ps" cols=50 rows=3></textarea> </td>
	</tr>
	<tr>
        <td colspan=3 bgcolor="#ffffff">
            <center>
                <input type=submit value="執行內部轉帳">
            </center>
        </td>    
    </tr>
</table>
</td>
</tr>
</table> 
<%
    }catch(Exception e){

        e.printStackTrace();
    }

%>

</blockquote>

<script>
showPicFrom('1',document.payform.tradeaccountId.value,'fromPic');
showPicFrom('1',document.payform.TotradeaccountId.value,'toPic');
</script>

<%@ include file="bottom.jsp"%>	
