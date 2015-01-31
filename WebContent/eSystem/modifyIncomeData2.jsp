<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>


<%
 request.setCharacterEncoding("UTF-8");
	
 EsystemMgr em=EsystemMgr.getInstance();
 Esystem esys=(Esystem)em.find(1);
 int incomeV=esys.getEsystemIncomeVerufy();

 JsfTool jt=JsfTool.getInstance();	
  boolean changeSmallItem=false;
  
  int costId=Integer.parseInt(request.getParameter("costId")); 
  IncomeMgr cm=IncomeMgr.getInstance();
  Income c=(Income)cm.find(costId);
  	
  String seString=request.getParameter("smallItem");
  if(seString !=null)
  {
  	int bigItem=Integer.parseInt(request.getParameter("b"));
  	if(bigItem==0)
	 {
	 %>
	 	<font color=red>登入失敗:</font> 請選擇主項目!!
	 	
	 	<br><br>
	 <%
		return;
	 }
  	
  	c.setIncomeBigItem   	(bigItem);
	c.setIncomeSmallItem(Integer.parseInt(seString));
  }
	
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
 
 


String modifyData=request.getParameter("modifyData"); 
InModifyMgr imm=InModifyMgr.getInstance();
InModify im=new InModify();
im.setInModifyIncomeId(costId);
im.setInModifyNotice(modifyData);
//im.setInModifyUser(ux.getId());
imm.createWithIdReturned(im);

Date payDate=jt.ChangeToDate(costDate, c.getIncomeDate());

int incomeStatus=1;

if(costMoney<=incomeV)
{
	incomeStatus=97;
}else{
	incomeStatus=1;
}


c.setIncomeName   	(costSum);
c.setIncomeMoney   	(costMoney);
c.setIncomePayWay   	(payWay);
c.setIncomeDate   	(payDate);
c.setIncomeFrom  	(costTo);
c.setIncomeLog   	(costLog);
c.setIncomeVerify(incomeStatus);
  
cm.save(c);

response.sendRedirect("modifyIncome.jsp?incomeId="+costId);
%>



