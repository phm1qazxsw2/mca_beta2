<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
 
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
  
	if(costMoney <=0)
	{
	out.println("<font color=red>登入失敗:</font> 金額請輸入大於0的整數!!");
	return;
	} 
	
	String costSum=request.getParameter("costSum");
	
	JsfTool jt=JsfTool.getInstance();
	
	String cidString=request.getParameter("cid");
	
	if(cidString==null)
	{
		out.println("尚未輸入ID");
		return;
	}
	
	
	int type=Integer.parseInt(request.getParameter("typeX"));
	
	String costName=request.getParameter("costName");

	int cid=Integer.parseInt(cidString);
	
	CostbookMgr cmx=CostbookMgr.getInstance();
	Costbook cb=(Costbook)cmx.find(cid);

	JsfPay jp=JsfPay.getInstance();
	Cost c=new Cost();	
	c.setCostAccountDate(cb.getCostbookAccountDate()); 
	c.setCostOutIn (type);
    c.setCostName   	(costName);
    c.setCostMoney   	(costMoney);
    c.setCostLogId   	(ud2.getId());
    c.setCostBigItem   	(bigItem);
    c.setCostSmallItem   	(smallItem);
    c.setCostCostbookId   	(cb.getId());
    c.setCostCostCheckId   	(cb.getCostbookCostcheckId());
    c.setCostPs   	(costSum);
	int returnValue=jp.saveCost(c,cb);


	response.sendRedirect("modifyCostbook.jsp?cid="+cid+"&showType=0&addItem="+returnValue);
 
%>
