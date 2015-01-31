<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
 request.setCharacterEncoding("UTF-8");
 
 EsystemMgr em=EsystemMgr.getInstance();
 Esystem esys=(Esystem)em.find(1);
 
 int incomeV=esys.getEsystemCostVerufy();
 
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

Cost c=new Cost();
c.setCostName   	(costSum);
c.setCostMoney      	(costMoney);
c.setCostPayWay   	(payWay);
c.setCostDate   	(payDate);
c.setCostTo   	(costTo);
c.setCostLog   	(costLog);
c.setCostBigItem   	(bigItem);
c.setCostSmallItem(smallItem);
c.setCostVerify(incomeStatus);   

CostMgr cm=CostMgr.getInstance();
int costId=cm.createWithIdReturned(c);


response.sendRedirect("addCost2.jsp?fi=1");
 
 /*
 String costDate=request.getParameter("costDate"); 
 String costSum=request.getParameter("costSum");
 String costTo=request.getParameter("costTo");
 
 int costLog=Integer.parseInt(request.getParameter("costLog"));
 int costMoney=Integer.parseInt(request.getParameter("costMoney"));
 int bigItem=Integer.parseInt(request.getParameter("bigItem"));
 int smallItem=Integer.parseInt(request.getParameter("smallItem")); 
 int payWay=Integer.parseInt(request.getParameter("payWay")); 
 
 

Date payDate=sdf1.parse(costDate);


Cost c=new Cost();
c.setCostName   	(costSum);
c.setCostMoney   	(costMoney);
c.setCostPayWay   	(payWay);
c.setCostDate   	(payDate);
c.setCostTo   	(costTo);
c.setCostLog   	(costLog);
c.setCostBigItem   	(bigItem);
c.setCostSmallItem(smallItem);   

CostMgr cm=CostMgr.getInstance();
int costId=cm.createWithIdReturned(c);

Cost co=(Cost)cm.find(costId);

*/
%>
