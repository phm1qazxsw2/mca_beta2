<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,jsi.*" contentType="text/html;charset=UTF-8"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%
    int topMenu=11;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu11.jsp"%>
<br>
<br>
<blockquote>
<%
    if(!AuthAdmin.authPage(ud2,4))
    {
        response.sendRedirect("authIndex.jsp?page=8&info=1");
    }

    DecimalFormat nf = new DecimalFormat("###,##0.00");
  	DecimalFormat mnf = new DecimalFormat("###,###,##0");

    JsfAdmin ja=JsfAdmin.getInstance();
    SalaryAdmin sa=SalaryAdmin.getInstance();

    JsfPay jp=JsfPay.getInstance();
    Tradeaccount[] tradeA=jp.getAllTradeaccount(_ws.getBunitSpace("bunitId"));


    int total2=0;	
    int costTotal=0;
    int  incomeTotal=0;
    int totalAccountNum=0;  
    
    
    int tradeNum[]=null;
    
    if(tradeA==null)
    {
        out.println("<br><br><blockquote>沒有個人零用金帳戶</blockquote>");

    }else{ 

            //SalarybankAuth[] sa1=jp.getSalarybankAuthByUserId(ud2); 

            int totalTrade=tradeA.length;
        
            
            Costpay[] cp=jp.getAccountType1Costpay();
      	
            
            if(cp==null)
            {
                out.println("沒有交易資料");
                return;
            }
            
            Hashtable allTrade=jp.getTradeAcccountNum(cp);		
            Hashtable incomeHa=(Hashtable)allTrade.get("in"); 
            Hashtable costHa=(Hashtable)allTrade.get("co"); 

%>

<b><img src="pic/people.png" border=0>個人零用金 - 帳戶現狀</b>
   

<table width="68%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 width=150>帳戶名稱</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80>支出</td>
		<td bgcolor=#f0f0f0 class=es02  width=80>存入</td>
		<td bgcolor=#f0f0f0 class=es02 width=80>餘額</td>
		<td bgcolor=#f0f0f0 class=es02 nowrap>現金總比例</tD> 
		<td bgcolor=#f0f0f0 class=es02></tD> 
	</tr>

	<% 
		tradeNum=new int[tradeA.length]; 
		for(int tI=0;tI<tradeA.length;tI++)
		{
			tradeNum[tI]=0; 
		}	
		
		
		for(int j=0;j<tradeA.length;j++)
		{
	%>
		<tr bgcolor=#ffffff align=left valign=middle>
				<td class=es02 nowrap>
					<%=tradeA[j].getTradeaccountName()%>
				</td>
				<td class=es02 align=right>
				<%
					int cost=0; 
					if(costHa.get(String.valueOf(tradeA[j].getId()))==null)
					{
						cost=0;
						//out.println(income);
					}else{
						String costS=(String)costHa.get(String.valueOf(tradeA[j].getId()));
						
						cost=Integer.parseInt(costS);
					}
						
					out.println(mnf.format(cost));
 
					costTotal += cost;

					

				%>
				</td>

				
				<td class=es02 align=right>
				<%
					int income=0; 
					
					if(incomeHa.get(String.valueOf(tradeA[j].getId()))==null)
					{
						income=0;
						//out.println(income);
					}else{
						String incomeS=(String)incomeHa.get(String.valueOf(tradeA[j].getId()));
						
						income=Integer.parseInt(incomeS);
					}
						
					out.println(mnf.format(income));
 
					incomeTotal +=income; 
  
 	 	 	 	 	 tradeNum[j]=income-cost;
				%>
				</tD>
				
				<td class=es02  align=right>
					<%=mnf.format(income-cost)%>	
				</tD>	
				<td class=es02 align=right> 
				
					<div id="trade<%=j%>"></div> 
				</tD>		
				<td class=es02 nowrap>
					<a href="show_costpay_detail.jsp?bankType=1&baid=<%=tradeA[j].getId()%>">詳細資料</a>
 				</td>
			</tr>
		
	<%
		}
	%>
 
		<tr>
		<td></td>
		<tD align=right><%=mnf.format(costTotal)%></td> 
		<tD align=right>
			<%=mnf.format(incomeTotal)%>
		</td> 
		<tD align=right><b><%=mnf.format(incomeTotal-costTotal)%></b></td> 
 
 	 	 <% 
  			total2=incomeTotal-costTotal;
  			
  		%>
		<td></td>
	</tr>
	</table>
	
	</td>
	</tr>
	</table>

  </blockquote> 
  
<% 
}	
		BankAccount[] ba=sa.getAllBankAccount(_ws.getBunitSpace("bunitId"));

		if(ba==null)
		{
			out.println("<br><br><blockquote>沒有銀行帳戶</blockquote>");
		%>
		<%@ include file="bottom.jsp"%>	
		<%	
			return;
		}

		Costpay[] bcp=jp.getAccountType2Costpay();
 
		
		if(bcp==null)
  		{
  			out.println("沒有資料");
  			return;
  		}
 		
 		Hashtable allBankTrade=jp.getBankNum(bcp);		
		Hashtable bincomeHa=(Hashtable)allBankTrade.get("in"); 
		Hashtable bcostHa=(Hashtable)allBankTrade.get("co"); 
		
		int baNum[] =null;
%> 
<script>
 
	function showAccount(divName,accountName,web1,web2,web3)
	{ 
		var s="<font color=blue>"+accountName+"</font><br>欄位一:"+web1+"<br>"+"欄位二:"+web2+"<br>"+"欄位三:"+web3;
		
		document.getElementById(divName).innerHTML=s; 
	}
</script>


<blockquote>
<b><img src="pic/bank.png" border=0>銀行帳戶 - 帳戶現狀</b>
<table width="68%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 width=150>帳戶名稱</tD>
		<td bgcolor=#f0f0f0 class=es02 width=80>支出</td>
		<td bgcolor=#f0f0f0 class=es02  width=80>存入</td>
		<td bgcolor=#f0f0f0 class=es02 width=80>餘額</td>
		<td bgcolor=#f0f0f0 class=es02 nowrap>現金總比例</tD> 	
		<td bgcolor=#f0f0f0 class=es02></tD> 
	</tr>

	<%
 
		int bcostTotal=0;
		int  bincomeTotal=0;

		baNum=new int[ba.length]; 
		for(int bI=0;bI<ba.length;bI++)
		{
			baNum[bI]=0; 
		}	
		
		
		boolean showTotal=true;
		for(int j=0;j<ba.length;j++)
		{ 
			if(ud2.getUserRole()>3 && !ja.isAuthBank(ba[j].getId(),ud2.getId()))
			{	
				showTotal =false;
				continue;
			}	
		
	%>
		<tr bgcolor=#ffffff align=left valign=middle>
				<td class=es02 nowrap>
					<%=ba[j].getBankAccountName()%> 
						<a href="<%=ba[j].getBankAccountWebAddress()%>" onMouseOver="javascript:showAccount('showWeb','<%=ba[j].getBankAccountName()%>','<%=ba[j].getBankAccountWeb1()%>','<%=ba[j].getBankAccountWeb2()%>','<%=ba[j].getBankAccountWeb3()%>')" target="_blank">[網銀]</a>
				</td> 
				<td class=es02 align=right>
				<%
					int cost=0; 
					if(bcostHa.get(String.valueOf(ba[j].getId()))==null)
					{
						cost=0;
						//out.println(income);
					}else{
						String costS=(String)bcostHa.get(String.valueOf(ba[j].getId()));
						
						cost=Integer.parseInt(costS);
					}
						
					out.println(mnf.format(cost));
 
					bcostTotal += cost; 
				%>
				</td>
				<td class=es02 align=right>
				<%
					int income=0; 
					
					if(bincomeHa.get(String.valueOf(ba[j].getId()))==null)
					{
						income=0;
						//out.println(income);
					}else{
						String incomeS=(String)bincomeHa.get(String.valueOf(ba[j].getId()));
						
						income=Integer.parseInt(incomeS);
					}
						
					out.println(mnf.format(income));
 
					bincomeTotal +=income;
					
					baNum[j]=income-cost;			
				%>
				</tD>
				
				<td class=es02  align=right>
					<%=mnf.format(income-cost)%>	
				</tD>	
				<td class=es02 align=right> 

						<div id="bank<%=j%>"></div> 
				</tD>
							
				<td class=es02 nowrap>
					<a href="show_costpay_detail.jsp?bankType=2&baid=<%=ba[j].getId()%>">詳細資料</a>
 				</td>
			</tr>
		
	<%
		}
	%>
 
	
	<tr>
		<td></td>
		<tD align=right><%=mnf.format(bcostTotal)%></td> 

		<tD align=right>
			<%=mnf.format(bincomeTotal)%></td> 
		
		<tD align=right><b><%=mnf.format(bincomeTotal-bcostTotal)%></b></td> 
 
 	  	<tD align=right>	
   		 <% 
  			total2+=bincomeTotal-bcostTotal;
  		%>
   			
   		</td>
		<td></td>
	</tr>
	</table>
	
	</td>
	</tr>
	</table>
<br> 
<% 
	if(!showTotal)
	{
%>
		<div class=es02><font color=blue>由於權限問題,本頁僅顯示部分銀行帳戶!</font></div>
<%
	}

 if(ud2.getUserRole()<=3) 
 { 
%> 
<b>合計現金: </b>
<table width="68%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">


<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
		<td width=25%>個人零用金</tD>
		<td width=25%>銀行帳戶</td>
		<td width=25%>合計</td> 
		<tD width=25%></tD>
	</tr>

	<tr bgcolor=#ffffff align=right valign=middle>
		<td><%=mnf.format(incomeTotal-costTotal)%></tD>
		<tD><%=mnf.format(bincomeTotal-bcostTotal)%></tD>
		<td><b><%=mnf.format(incomeTotal-costTotal+bincomeTotal-bcostTotal)%></b></tD>
		<tD> 
			<%
				SimpleDateFormat sdfC=new SimpleDateFormat("yyyy/MM"); 
				Date aDate=new Date();
			%>	
		
			<a href="makeFinancePDF.jsp?fId=4&runDate=<%=sdfC.format(aDate)%>" target="_blank"><img src="pic/pdf.gif" border=0>輸出電子報表</a>		
		</tD>
	</tr> 
	</table>

	</tD>
	</tr>
	</table>		

<br> 
<script>
<%  
	totalAccountNum = tradeA.length + ba.length ;

 	int[] mFeeX=new int[totalAccountNum];
	String[] mFeeNameX=new String[totalAccountNum];
	String[] mFeeUrlX=new String[totalAccountNum];

	

	for(int xx=0;xx<tradeA.length;xx++)
	{ 
		float ftrade=((float)tradeNum[xx]/(float)total2)*100;
 
		mFeeX[xx]=tradeNum[xx];
		mFeeNameX[xx]= tradeA[xx].getTradeaccountName();
		mFeeUrlX[xx]="";
	%>	
		trade<%=xx%>.innerHTML="<%=nf.format(ftrade)%> %";
<%
	}	

	int startCount=tradeA.length;		
	
	for(int xx=0;xx<ba.length;xx++)
	{  
		float fbank=((float)baNum[xx]/(float)total2)*100;
 
		
		int arrayNum=xx+startCount;
		mFeeX[arrayNum]=baNum[xx];
		mFeeNameX[arrayNum]= ba[xx].getBankAccountName();
		mFeeUrlX[arrayNum]="";

%>	
		bank<%=xx%>.innerHTML="<%=nf.format(fbank)%> %";
<%
	}	
%>
	</script>
<%
	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
 
	if(e.getEsystemShowCash()==0) 
	{ 
%> 
		<%@ include file="bottom.jsp"%>
<%
		return;
	}
/*

	int[] itemNum =null;
	String[] item =null;
	String[] itemUrl=null;
	String titleName="";
	String itemName="";
	String preUnit="";
	String segmentStyle[]=new String[6];
	segmentStyle[0]="155,202,164"; 
	segmentStyle[1]="159,159,255";
	segmentStyle[2]="235,53,8";
	segmentStyle[3]="255,230,155";
	segmentStyle[4]="16,148,70";
	segmentStyle[5]="17,97,158";
	
	Utility u=Utility.getInstance();

	Hashtable reHa2=u.get6num(mFeeX,mFeeNameX,mFeeUrlX);
	titleName="現金帳戶統計";
	itemName="帳戶名稱";
	preUnit="$";
 
	itemNum =(int[])reHa2.get("a");
   	item =(String[])reHa2.get("b");
	itemUrl =(String[])reHa2.get("c");
%> 
<br>
	<%//include file="henrypie.jsp"%>		
<%
    */

	}
%>	

</blockquote>

<%@ include file="bottom.jsp"%>