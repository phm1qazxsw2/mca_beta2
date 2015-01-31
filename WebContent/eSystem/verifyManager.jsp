<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
 request.setCharacterEncoding("UTF-8");
 JsfAdmin ja=JsfAdmin.getInstance();
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
int costId=Integer.parseInt(request.getParameter("costId"));

IncomeMgr cm=IncomeMgr.getInstance();
Income c=(Income)cm.find(costId);

c.setIncomeVerify(1);
c.setIncomeVerifyNameId(managerName);
c.setIncomeVerifyDate(new Date());
  
cm.save(c);

String modifyData=request.getParameter("modifyData"); 
InModifyMgr imm=InModifyMgr.getInstance();
InModify im=new InModify();
im.setInModifyIncomeId(costId);
im.setInModifyNotice(modifyData);
im.setInModifyUser(managerName);
imm.createWithIdReturned(im);


response.sendRedirect("verifyIncome.jsp?incomeId="+costId);
%>