<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=2;
    int leftMenu=2;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu2.jsp"%> 
<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<%


if(!checkAuth(ud2,authHa,205))
{
    response.sendRedirect("authIndex.jsp?code=205");
}    	

JsfPay jp=JsfPay.getInstance();
		
Owner[] ow=jp.getActiveOwner();


if(ow==null)
{
	out.println("<br><br><blockquote>沒有可交易的股東</blockquote>");
%>
	<%@ include file="bottom.jsp"%>	
<%
	return;
}

Tradeaccount[] tradeB=jp.getAllTradeaccount(_ws.getBunitSpace("bunitId"));
BankAccount[] sa2=jp.getAllBankAccount(_ws.getBunitSpace("bunitId"));

java.text.SimpleDateFormat df = new java.text.SimpleDateFormat("yyyy/MM/dd"); 


%>

<script>
		
		function  typeChange2(typevalue)
		{
 
			if(typevalue=='1')
 
			{  
				this.payform.TobankName.disabled=true;
				this.payform.TotradeaccountId.disabled=false;
			}else if(typevalue=='2'){
				this.payform.TobankName.disabled=false;
				this.payform.TotradeaccountId.disabled=true;
			} 
		} 

  	</script>


<br>
<br>

<b>&nbsp;&nbsp;&nbsp;股東提取</b>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>
<blockquote>
<form action="addCostOwner.jsp"  name="payform" id="payform"  method="post">
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>入帳日期</td>
	<td bgcolor=#ffffff class=es02><input type=text name="tradeDate" value="<%=df.format(new Date())%>"></td>
</tr>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>金額</td>
	<td bgcolor=#ffffff class=es02><input type=text name="number" value="0"></td>
</tr>
 

<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
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


<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td>登入註記</td>
	<td bgcolor=#ffffff class=es02><textarea name="ps" rows=2 cols=20></textarea></td>
</tr>
<tr bgcolor=#f0f0f0 class=es02 align=left valign=middle>
	<td colspan=2>

	<table class=es02>
		<tr>
		<td>交易帳戶</tD>
		<td> -> </td>
		<td>交易股東</td>
		</tr> 
		
	<tr bgcolor=ffffff>
		<td>
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
		
		</tD>
		<td rowspan=2><img src="pic/intrade.png" border=0></td>
		<td rowspan=2>
			<select name="ownerId">
			<% for(int i=0;i<ow.length;i++){  %>
				<option value="<%=ow[i].getId()%>"><%=ow[i].getOwnerName()%></option>		
			<%  }  %>
			</select>
		</td>
		
		<tr>
		<td bgcolor=#ffffff class=es02>
	<table border=0> 
	
			<tr>
				<td>
			<%
					if(tradeB!=null)
 					{ 
			%>			
					<input type=radio name="Totype" value="1" checked onFocus="typeChange2('1')">個人零用金帳戶  
				</td>	
				<td>	 
					<select size=1 name="TotradeaccountId"  onClick="showPicFrom('1',this.form.TotradeaccountId.value,'toPic')">
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
    			<td>		
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
							<select size=1 name=TobankName  onClick="showPicFrom('2',this.form.TobankName.value,'toPic')">	
								<%
 
									for(int j=0;j<sa2.length;j++){ 
									
										//BankAccount ba=(BankAccount)bam.find(sa1[j].getSalarybankAuthId());
 								%>
									<option value="<%=sa2[j].getId()%>"><%=sa2[j].getBankAccountName()%></option>
								<%
									}
								%>		
							</select>
 
						<script>							
							this.payform.TobankName.disabled=true;
						</script>							
					<%			
						}
					%>
					</td>
				</tr>	
				</table>
		</td>
		</tr>
		</table>
	
	
	</td>
</tr>		
<tr bgcolor=#ffffff class=es02 align=left valign=middle>
	<td colspan=2>
		<center>
			<input type=submit value="新增"  onClick="return(confirm('確認新增此筆股東挹注'))">
		</center>
	</td>
</tr>
</table> 
	
	</td>
	</tr>
	</table>
</blockquote>
 

</form>
<%@ include file="bottom.jsp"%>

