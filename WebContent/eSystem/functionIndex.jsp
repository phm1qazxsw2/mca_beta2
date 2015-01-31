<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*,java.io.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<link rel="stylesheet" href="style.css" type="text/css">
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<br> 
<%
	String  showTypeS=request.getParameter("showType");
	
	int showType=1;
	
	if(showTypeS !=null) 
		 showType=Integer.parseInt(showTypeS);
%>


<B>&nbsp;&nbsp;&nbsp;使用手冊</B> 
<blockquote> 
	<a href="functionIndex.jsp?showType=1">學費</a>  | 
	<a href="functionIndex.jsp?showType=2">雜費管理</a>  | 
	<a href="functionIndex.jsp?showType=3">學生教師管理</a>  |  
	<a href="functionIndex.jsp?showType=4">校務系統</a> |
	<%
		if(ud2.getUserRole()<=2)
		{		 
	%>
	<a href="functionIndex.jsp?showType=5">帳戶設定</a> | 
	<%
		}
	%>
	<a href="functionIndex.jsp?showType=6">系統</a> |
	<a href="functionIndex.jsp?showType=7">財務報表</a> |  
</blockquote>

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<blockquote>  

	<table border=0 width=90%>
  		<tr>
  			<td width=120 valign=top>  
 		
	<%
		switch(showType) 
		{ 
			 case 1:
	%>
				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>學費</b></font></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>開單</b>-<a href="listClassesMoney.jsp">依開徵項目</a></td>
				</tr>
			  	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listNetFeeticekt.jsp">依學生名單</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listAllStudent.jsp">自動產生</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>管理</b>-<a href="listFeeNumber.jsp">報表中心</a></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listFeeNumberByClass.jsp">列印中心</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listAtmPay.jsp">收款查詢</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>繳款</b>-<a href="addPayFeeType4x.jsp">依流水號</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listStudentType2.jsp">依學生名單</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="storePayIndex.jsp">便利商店</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="atmPayIndex.jsp">虛擬帳號</a></td>
				</tr>
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>設定</b>-<a href="listStuIncomeItem.jsp">入帳項目</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listDiscountType.jsp">折扣項目</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addClassesMoney.jsp">開徵項目</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="modifyPaySystem.jsp">繳費期限</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>帳單設定</b>-<a href="addPayFeeType4x.jsp"></a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="modifyPaySystem.jsp">銀行交易</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="modifyPaySystem.jsp">生日祝福</a></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="modifyPaySystem.jsp">確認簡訊</a></td>
				</tr>
				</table>	
		<%
					break;
				case 2:
		%>
				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>雜費管理</b></font></td>
				</tr>
 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>登入</b>-<a href="addCostbook.jsp?type=1">支出傳票</a></td>
				</tr>
			  	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addCostbook.jsp?type=0">收入傳票</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addInsideTrade.jsp">內部交易</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>查詢</b>-<a href="listMyCostbook.jsp">我的傳票</a></td>
				</tr>
			  	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listCostbook.jsp">進階傳票查詢</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listAllStudent.jsp">依傳票號碼</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="searchCostbookTradeId.jsp">內部轉帳</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>設定</b>-<a href="listCosttrade.jsp">廠商登入</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="ListBigItem.jsp">帳務項目</a></td>
				</tr>
				
				</table>			
			<%
			 	break;
			 case  7:
			 %>
				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>財務報表</b></font></td>
				</tr>
 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>統計</b>-<a href="CostbookReport.jsp">雜費報表</a></td>
				</tr>
			  	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="myShowCostPay.jsp">我的零用金</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="showCostPay.jsp">現金帳戶</a></td>
				</tr> 
		<%
			if(ud2.getUserRole()<=2)
			{		
		%>		
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="showBalance.jsp">損益試算</a></td>
				</tr>	
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>結帳</b>-<a href="showClose.jsp">結帳流程</a></td>
				</tr>
			  	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="showFinance.jsp">財務報表</a></td>
				</tr>
		<%
			}
		%>	
				</table>			
		<%
			break;
		case 3:
		%>
  				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>學生教師管理</b></font></td>
				</tr>
 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>登入</b>-<a href="addStudent.jsp">新生入學</a></td>
				</tr>
			  	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listTalent.jsp">才藝班入學</a></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addTeacher.jsp">新增教師</a></td>
				</tr> 
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>管理</b>-<a href="listStudent.jsp">就讀生名單</a></td>
				</tr>
			 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listTalent.jsp">才藝班名單</a></td>
				</tr>
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listTeacher.jsp">在職教師</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>萬用表單</b>-<a href="exlStudent.jsp">學生</a></td>
				</tr>
			  	<tr height=21> 
			  	
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="exlTeacher.jsp">教師</a></td>
				</tr> 
			  	</table>
   		<%
			break;
		case 5:

			if(ud2.getUserRole()<=2)
			{		
		%>		
   				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>帳戶設定</b></font></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>設定</b></td>
				</tr>

  				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listTradeaccount.jsp">個人零用金帳戶</a></td>
				</tr> 
				 <tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="salaryBankAccount.jsp">銀行帳戶</a></td>
				</tr> 
					
				</table>
    	<%
    		}
 
  			break;
  		case 4:
    	%>
				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>校務系統</b></font></td>
				</tr>
 
			
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>設定</b>-<a href="addCostbook.jsp?type=1">班級設定</a></td>
				</tr>
			 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listDepart.jsp">部門設定</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listClass.jsp">年級設定</a></td>
				</tr> 		
							 	<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listLevel.jsp">職位列表</a></td>
				</tr>
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>才藝班</b></td>
				</tr>
				
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addTalentClass.jsp">新開才藝班</a></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listPlace.jsp">新增教室</a></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>聯絡人</b></td>
				</tr>

				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listRelation.jsp">親屬關係</a></td>
				</tr> 

				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="listDegree.jsp">學歷</a></td>
				</tr> 
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>全校簡訊</b>-<a href="#" onClick="javascript:openwindow64('3','0','1');return false">發送</a></td>
				</tr>
			  	</table>
		<%
			break;
		case 6:
		%>		
				<table width=116  border="0" cellpadding="0" cellspacing="0" height=22>
				<tr height=22> 
					<td  height=22 width=116 background="pic/test_01.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;<font color=white><b>系統</b></font></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>備份</b>-<a href="backupIndex.jsp">新增</a></td>
				</tr>
			   	 <tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="backupLog.jsp">備份紀錄</a></td>
				</tr>
				<tr height=21> 
					<td  height=21 width=116 background="pic/test_02.gif" class=es02 valign=bottom>&nbsp;&nbsp;<b>系統相關</b>-<a href="modifySystem.jsp">設定</a></td>
				</tr> 
				</table>
		<%
			break; 
			} 
			
		%> 
		
		</tD>
		<td valign=top>
			<table width="100%" height="" border="0" cellpadding="0" cellspacing="0">
			<tr align=left valign=top> 
			<td bgcolor="#e9e3de">
				
				<table width="100%" border=0 cellpadding=4 cellspacing=1>
					<tr class=es02>
					<td colspan=2>
						<b>開單-依開徵項目 說明文件</b>
					</td> 
					</tr>
					<tr bgcolor=#ffffff align=left valign=middle>
						<td colspan=2> 
						<img src="doc/pic/feeItem.gif" border=0>
						</td>
					</tR>	
					<tr bgcolor=#ffffff align=left valign=middle>
						<td  bgcolor=#f0f0f0  class=es02 width=50> 
							功能說明
						</td>
						<td  bgcolor=#ffffff  class=es02>
							...........................blablalbla 
						</td>
					</tR>	
					<tr bgcolor=#ffffff align=left valign=middle>
						<td  bgcolor=#f0f0f0  class=es02> 
							<img src="doc/pic/d1.gif" border=0>
						</td>
						<td  bgcolor=#ffffff  class=es02>
							...........................blablalbla 
						</td>
					</tR>	
					<tr bgcolor=#ffffff align=left valign=middle>
						<td  bgcolor=#f0f0f0  class=es02>
 
							<img src="doc/pic/d2.gif" border=0>
						</td>
						<td  bgcolor=#ffffff  class=es02>
							...........................blablalbla 
						</td>
					</tR>	
					<tr bgcolor=#ffffff align=left valign=middle>
						<td  bgcolor=#f0f0f0  class=es02>
 
							<img src="doc/pic/d3.gif" border=0>
						</td>
						<td  bgcolor=#ffffff  class=es02>
							...........................blablalbla 
						</td>
					</tR>	
					<tr bgcolor=#ffffff align=left valign=middle>
						<td  bgcolor=#f0f0f0  class=es02>
 
							<img src="doc/pic/d4.gif" border=0>
						</td>
						<td  bgcolor=#ffffff  class=es02>
							...........................blablalbla 
						</td>
					</tR>	
					
				</table>
			</td>
			</tr>
			</table>
		</tD>
		</tr>
		</table>
		
</blockquote>		

<%@ include file="bottom.jsp"%>