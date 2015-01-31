<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
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

CostMgr cm=CostMgr.getInstance();
Cost c=(Cost)cm.find(costId);

c.setCostVerify(1);
c.setCostVerifyNameId(managerName);
c.setCostVerifyDate(new Date());  
cm.save(c);

String modifyData=request.getParameter("modifyData"); 
CoModifyMgr imm=CoModifyMgr.getInstance();
CoModify im=new CoModify();
im.setCoModifyIncomeId(costId);
im.setCoModifyNotice(modifyData);
im.setCoModifyUser(managerName);
imm.createWithIdReturned(im);

response.sendRedirect("verifyCost.jsp?costId="+costId);
%>