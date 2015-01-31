<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>

<%
 request.setCharacterEncoding("UTF-8");
 
 JsfAdmin ja=JsfAdmin.getInstance();
 
 String se2String=request.getParameter("vMoney");
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
 	
 
 
 String managerPass=request.getParameter("managerPass");
 int managerName=Integer.parseInt(request.getParameter("managerName"));
 
	if(managerPass.equals(""))
	{
		out.println("<font color=red><center>請輸入密碼!!</center></font>");
		return;
	}
	
	
	if(!ja.vefiryUser(managerName,managerPass))
	{
	out.println("<font color=red><center>主管密碼錯誤!!</center></font>");
	return;
	}	
 
int incomeId=Integer.parseInt(request.getParameter("incomeId")); 

CostMgr cm=CostMgr.getInstance();
Cost c=(Cost)cm.find(incomeId);

int status=99;


if(c.getCostMoney()!=costMoney)
	status=98;


c.setCostMoney   	(costMoney);
c.setCostVerify(status);
c.setCostVerifyNameId(managerName);
c.setCostVerifyDate(new Date());
  
cm.save(c);
response.sendRedirect("verifyCost.jsp?costId="+incomeId);

%>