<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
 request.setCharacterEncoding("UTF-8");
 
 EsystemMgr em=EsystemMgr.getInstance();
 Esystem esys=(Esystem)em.find(1);
 
 int incomeV=esys.getEsystemIncomeVerufy();
 
 int bigItem=Integer.parseInt(request.getParameter("b"));
 if(bigItem==0)
 {
 %>
 	<font color=red>登入失敗:</font> 請選擇主項目!!
 	
 	<br><br>
 <%
	return;
 }
 
 String seString=request.getParameter("smallItem");
 
 if(seString==null)
 {
 %>
 	<font color=red>登入失敗:</font> 請選擇次項目!!
 	
 	<br><br>
 <%
	return;
 }

  
 int smallItem=Integer.parseInt(seString); 
  
 String se2String=request.getParameter("costMoney");
 
 if(se2String ==null || se2String.equals(""))
 {
 %>
 <font color=red>登入失敗:</font> 請輸入金額!!
 	
 	<br><br>
 <%
	return;

  }
  int costMoney;
  try
  {
  	costMoney=Integer.parseInt(se2String);
  }
  catch(Exception e)
  {
  %>
  	<font color=red>登入失敗:</font> 請輸入金額為整數!!
 	
 	<br><br>
  
 <% 	
 	return;
  }
 
 	
 
 String costDate=request.getParameter("costDate"); 
 String costSum=request.getParameter("costSum");
 String costTo=request.getParameter("costTo");
 
 int costLog=Integer.parseInt(request.getParameter("costLog"));


 int payWay=Integer.parseInt(request.getParameter("payWay")); 
 
 
 JsfTool jt=JsfTool.getInstance();
 Date payDate=jt.ChangeToDate(costDate);

int incomeStatus=1;

if(costMoney<=incomeV)
{
	incomeStatus=97;
}else{
	incomeStatus=1;
}

Income c=new Income();
c.setIncomeName   	(costSum);
c.setIncomeMoney      	(costMoney);
c.setIncomePayWay   	(payWay);
c.setIncomeDate   	(payDate);
c.setIncomeFrom   	(costTo);
c.setIncomeLog   	(costLog);
c.setIncomeBigItem   	(bigItem);
c.setIncomeSmallItem(smallItem);
c.setIncomeVerify(incomeStatus);   

IncomeMgr cm=IncomeMgr.getInstance();
int costId=cm.createWithIdReturned(c);


response.sendRedirect("addIncome2.jsp?fi=1");
%>


