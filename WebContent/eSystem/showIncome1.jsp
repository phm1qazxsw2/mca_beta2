<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=3;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<jsp:useBean id='form' scope='request' class='web.Cost1Form'/>
<jsp:setProperty name='form' property='*'/>
 <link rel="stylesheet" href="style.css" type="text/css">
<%

JsfTool jt=JsfTool.getInstance();
//Date studentBirth2=jt.ChangeToDate(studentBirth);
//jt.ChangeDateToString() 
 
 String sDate=request.getParameter("sDate");
 String eDate=request.getParameter("eDate");
 String pageNum=request.getParameter("pageNum");
 String detail=request.getParameter("detail");
 form.setSDate(sDate);
 form.setEDate(eDate);
 
 String[] stringBi3=form.getBigItem();
 String stringBi2="1";
 if(stringBi3!=null && stringBi3.length>0)
 	stringBi2=stringBi3[0];
 
 
 int bi2=0;
 if(stringBi2 !=null)
 	bi2=Integer.parseInt(stringBi2);

 //日期排序 
 String orderB=request.getParameter("orderString");
 int orderNum=1;
  if(orderB !=null)
  	orderNum=Integer.parseInt(orderB);

 Date now=new Date();
 long nowLong=now.getTime();
 long beforeLong=nowLong-(long)1000*60*60*24*31;
 
 Date beforeDate=new Date(beforeLong);
 
 
 String nowString=jt.ChangeDateToString(now);	
 String beforeString=jt.ChangeDateToString(beforeDate);
 
 if(form.getSDate().equals(""))
 	form.setSDate(beforeString);
  if(form.getEDate().equals(""))
 	form.setEDate(nowString);

 JsfAdmin js=JsfAdmin.getInstance();
 IncomeBigItem[] bi=js.getAllIncomeActiveBigItem2();
 
 ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
 UserMgr umx=UserMgr.getInstance();
	
%>
<head>
<script language="JavaScript" src="js/calendar.js"></script>
<script language="JavaScript" src="js/overlib_mini.js"></script>
<script language="JavaScript" src="js/in.js"></script>
</head>

<body>
<script type="text/javascript" src="openWindow.js"></script>
<div id="overDiv" style="position:absolute; visibility:hidden; z-index:1000;"></div>
<table>
	<tr>
	<form action="showIncome1.jsp" method=get name="xs">
	<td>
	查詢日期:
	</td>
	<td>
		<input type=text name=sDate size=10 value="<%=form.getSDate()%>">
		<a href="javascript:show_calendar('xs.sDate');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
		
		-<input type=text name=eDate size=10 value="<%=form.getEDate()%>">
		<a href="javascript:show_calendar('xs.eDate');" onMouseOver="window.status='選擇日曆上的日期.'; overlib('選擇日曆上的日期.'); return true;" onMouseOut="window.status=''; nd(); return true;"><img src="images/show-calendar.gif" width=24 height=22 border=0></a>
	</td>
	<td width=40></td>
	<td>項目:</td>
	<td>
		<select size=1 name=bigItem>
			<option value="0" <%=form.getBigItemSelectionAttr("0")%>>全部</option>
			<option value="1" <%=form.getBigItemSelectionAttr("1")%>>學生收入</option>
	
		<%
		if(bi!=null)
		{
		   for(int i=0;i<bi.length;i++)
		   {
		   
		   	
		%>
			<option value="<%=bi[i].getId()%>" <%=form.getBigItemSelectionAttr(String.valueOf(bi[i].getId()))%>><%=bi[i].getIncomeBigItemName()%></option>			
		<%
		   }
		}
		%>	
		</select>
	</td>
	<td>
	<input type=submit onClick="checkYear10()" value="查詢">
  	</form>
  	</td>
  	</tr>
  	
 </table>
 
 
 -------------------------------------------------------------------------------------------
 <br>
 
 
<%
	int pageNumber=1;
	if(sDate==null || sDate.equals(""))
	{
		out.println("開始查詢!!<br><br>");
		
		return;
	}
	
	 Date startDate=jt.ChangeToDate(sDate);
	 Date endDate=jt.ChangeToDate(eDate);
	 
	 long oneDayAgo=1000*60*60*24;
	 long oneda=endDate.getTime()+oneDayAgo;
	 Date endDate2=new Date(oneda);
	 Income[] co=js.getIncomeByDate(startDate,endDate2,bi2,orderNum);
	
	if(co==null)
	{
		out.println("沒有資料!!<br><br>");
		
		return;
	
	}
	String bi5="";
	if(bi2==0)
	{
		bi5="全部";
	}
	else
	{
		IncomeBigItem bi4=(IncomeBigItem)js.getIncomeBigItemById(bi2);
		bi5=bi4.getIncomeBigItemName();
	}
	int incomeLengh=co.length;
	
%>

<%
if(detail !=null)
{
%>
<h3><br><font color=blue><%=sDate%></font>~<font color=blue><%=eDate%></font> <font color=red><%=bi5%></font> 收入詳細報告</h3>
<div align=right>
<a href=showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=<%=orderNum%>>回收入清單</a>
</div>
<div align=left>共計: <font color=blue><b><%=incomeLengh%></b></font> 筆資料</div>
<center>
<table>

	<tr  align="center" bgcolor="lightgrey" cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
	<td>名稱</td><td>金額</td><td>比重</td></tr>
	<tr>
				<td colspan=3>
				------------------狀態分類------------------
				</td>
				
			</tr>	
	
	
	
	
	<%
	
		int Ytotal=0;
		int Ntotal=0;
		int total=0;
		Hashtable ha=new Hashtable();
		for(int i=0;i<co.length;i++)
		{
			if(co[i].getIncomeVerify()>=90)
			{
				Ytotal +=co[i].getIncomeMoney();
			}else{
				Ntotal +=co[i].getIncomeMoney();
			}
			int bigitem=co[i].getIncomeBigItem();
			
			String sbigitem=String.valueOf(bigitem);
			
			if(ha.get(sbigitem)==null)
			{
				ha.put(sbigitem,String.valueOf(co[i].getIncomeMoney()));
			}else{
				int tempTotal=0;
				
				String tempString=(String)ha.get(sbigitem);	
				int bix=Integer.parseInt(tempString);
				tempTotal=bix+co[i].getIncomeMoney();
				ha.put(sbigitem,String.valueOf(tempTotal));
			}
		}
		
		total=Ytotal+Ntotal;
%>		
		
		<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">
		<td>已審核金額</td><td align=right><%=Ytotal%></td>
		<td align=right><%=jt.numberPercent(Ytotal,total)%></td></tr>
		<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">
		<td>未審核金額</td><td align=right><%=Ntotal%></td>
		<td align=right><%=jt.numberPercent(Ntotal,total)%></td></tr>
		<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">
		<td>總金額</td><td align=right><%=total%></td>
		<td align=right><%=jt.numberPercent(total,total)%></td></tr>				
<%		
		Enumeration keys=ha.keys();
		Enumeration elements=ha.elements();
%>		
		<tr>
				<td colspan=3>
				---------------主項目類別分析--------------
				</td>
				
			</tr>			
<%		
		IncomeBigItemMgr ibim=IncomeBigItemMgr.getInstance();
		
		int bigItemTotal=0;
		while(elements.hasMoreElements())
		{
			String key=(String)keys.nextElement();
			String element=(String)elements.nextElement();
			
			int ielement=Integer.parseInt(element);
			
			IncomeBigItem ibi=(IncomeBigItem)ibim.find(Integer.parseInt(key));
%>

			<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">
				<td><%=ibi.getIncomeBigItemName()%></td>
				<td align=right><%=ielement%></td>
				<td align=right><%=jt.numberPercent(ielement,total)%></td>
			</tr>	
	<%		
		}
	%>
					



</table>
</center>

<%
	return;
}
%>
<h3><br><font color=blue><%=sDate%></font>~<font color=blue><%=eDate%></font> <font color=red><%=bi5%></font> 收入清單</h3>
<center>共計: <font color=blue><b><%=incomeLengh%></b></font> 筆資料</center>

<%
	EsystemMgr em=EsystemMgr.getInstance();
	Esystem e=(Esystem)em.find(1);
	int pageContent=e.getEsystemIncomePage();
	
	
	
	if(pageNum!=null)
		pageNumber=Integer.parseInt(pageNum);
	
	int pageTotal=1;
	pageTotal=incomeLengh/pageContent;
	
	if(incomeLengh%pageContent!=0)
		pageTotal+=1;

	if(pageNumber !=1)
	{
		int lastPage=pageNumber-1;
		
	%>
	<a href=showIncome1.jsp?pageNum=<%=lastPage%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=<%=orderNum%>>上一頁</a>
	<%
	}
	for(int j=0;j<pageTotal;j++)
	{
		int jx=j+1;
		
		if(pageNumber==jx)
		{
			out.println("<b>"+jx+"</b>");
		
		}
		else
		{
		%>
		<a href=showIncome1.jsp?pageNum=<%=jx%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=<%=orderNum%>><%=jx%></a>
		<%
		}
	}
	if(pageNumber !=pageTotal)
	{
		int lastPage=pageNumber+1;
	%>
		
<a href=showIncome1.jsp?pageNum=<%=lastPage%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=<%=orderNum%>>下一頁</a>	
	<%
	}

	
%>
<div align=right>
<a href=showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=<%=orderNum%>&detail=1>詳細報告</a>
</div>


<table>
	<tr  align="center" bgcolor="lightgrey" cellpadding="1" cellspacing="0" width="98%" border="1" bordercolordark="#ffffff" bordercolorlight="#000000" bordercolor="#a8a8a8">
		<td>
		<%
		 if(orderNum==14)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=13">登入日期 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=14">登入日期 >>></a>
		<%
		}
		%>
		</td>
		<td>
		<%
		 if(orderNum==2)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=1">入帳日期 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=2">入帳日期 >>></a>
		<%
		}
		%>
		</td>
		
		<td>
		<%
		 if(orderNum==4)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=3">項目 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=4">項目 >>></a>
		<%
		}
		%>
		</td>
	
		<td><b>繳款人</b></td><td width=120><b>摘要</b></td>
		<td>
		<%
		 if(orderNum==6)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=5">金額 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=6">金額 >>></a>
		<%
		}
		%>
		</td>
		<td>
		<%
		 if(orderNum==8)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=7">付款方式 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=8">付款方式 >>></a>
		<%
		}
		%>
		</td>
		<td>
		<%
		 if(orderNum==10)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=9">記帳人 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=10">記帳人 >>></a>
		<%
		}
		%>
		</td>
		<td>
		<%
		 if(orderNum==12)
		 {
		 %>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=11">對帳狀態 <<<</a>
		<%
		}else{
		%>
		<a href="showIncome1.jsp?pageNum=<%=pageNumber%>&sDate=<%=sDate%>&eDate=<%=eDate%>&bigItem=<%=stringBi2%>&orderString=12">對帳狀態 >>></a>
		<%
		}
		%>
		</td>
		
		
		
		
		<td COLSPAN=3></td>
	</tr>
	
<%
int Ytotal=0;
int Ntotal=0;		 
	//for(int j=0;j<co.length;j++)
	//{
	//	total+=co[j].getIncomeMoney();


int startRow=(pageNumber-1)*pageContent;
int endRow=startRow+pageContent;
if(endRow > incomeLengh)
	endRow=incomeLengh;
for(int j=startRow;j<endRow;j++)
{

	if(co[j].getIncomeVerify()>=90)
	{
		Ytotal +=co[j].getIncomeMoney();
	}else{
		Ntotal +=co[j].getIncomeMoney();
	}
%>	

<tr class="normal" onmouseover="this.className='highlight'" onmouseout="this.className='normal'">
	<td>
	<%
		Date create=co[j].getCreated();
		out.println(jt.ChangeDateToString(create));
		%>
	</td>
		
	<td>
		<%
		Date cd=co[j].getIncomeDate();
		out.println(jt.ChangeDateToString(cd));
		%>
	</td>
	<%
		int cbi=co[j].getIncomeBigItem();
		int csi=co[j].getIncomeSmallItem();
		
		IncomeBigItem bi3=new IncomeBigItem();
		IncomeSmallItem si3=new IncomeSmallItem();
		if(cbi !=99)
		{
			bi3=(IncomeBigItem)js.getIncomeBigItemById(cbi);
    			si3=(IncomeSmallItem)js.getIncomeSmallItemById(csi);
		}
	%>
	<td>
		<%
			if(cbi!=99)
			{
		%>
		
		<%=bi3.getIncomeBigItemName()%>-><%=si3.getIncomeSmallItemName()%>	
	
		<%	
		}else{
		
			ClassesMoney cmx=(ClassesMoney)cmm.find(csi);
			String cmxName="";
			if(cmx!=null)
				cmxName=cmx.getClassesMoneyName();
		%>
		學費收入-><%=cmxName%>
		<%
		}
		%>
	</td>
	<td><%=co[j].getIncomeFrom()%></td>
	<td><%=jt.formatString(co[j].getIncomeName())%></td>
	<td align=right><font color=blue><%=co[j].getIncomeMoney()%></font></td>
	<td align=right>
	
	
	<%=co[j].getIncomePayWay()==1?"現金":""%>
	<%=co[j].getIncomePayWay()==2?"匯款":""%>
	<%=co[j].getIncomePayWay()==3?"支票":""%>
	<%=co[j].getIncomePayWay()==4?"其他":""%>
	
	</td>
	<td><% int il=co[j].getIncomeLog();
		User ux=(User)umx.find(il);
		out.println(ux.getUserFullname());
	
	%></td>
	<td>
	<%
	
		int costV=co[j].getIncomeVerify();
		
		switch(costV)
		{
			case 1:
				out.println("<font color=red>尚未審核</font>");
				break;
			case 10:
				out.println("<font color=red>審核未通過</font>");
				break;
			case 97:
				out.println("不需審核");
				break;
			case 98:
				out.println("修改&已審核");
				break;
			case 99:
				out.println("已審核");
				break;
		}
		
	
	%>
	
	</td>
	
	<td colspan=3>
	
		
		<a href="#" onClick="javascript:openwindow18('<%=co[j].getId()%>');return false">詳細資料</a>
		
	
	
	
	
	
	</td>
	
	
</tr>
		
<%	
		

	} 

%>

<tr class="normal">
		<td colspan=8><center>本頁已審核金額</center></td>
		<td colspan=4 align=right><font color=blue><b><%=Ytotal%></b></font></td>
</tr>	
<tr class="normal">
		<td colspan=8><center>本頁未審核金額</center></td>
		<td colspan=4 align=right><font color=blue><b><%=Ntotal%></b></font></td>
</tr>	
	
<tr bgcolor="#c9c9c9">
		<td colspan=8><center><b> 本頁總收入金額</b></center></td>
		<td colspan=4 align=right><font color=blue><b><%=Ntotal+Ytotal%></b></font></td>
	</tr>	
</table>	

<br>
<br>
</body> 