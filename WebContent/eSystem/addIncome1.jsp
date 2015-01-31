<%@ page language="java"  import="web.*,jsf.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=7;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<link rel="stylesheet" href="style.css" type="text/css">
<%

JsfAdmin ja=JsfAdmin.getInstance();

IncomeBigItem[] bi=ja.getAllIncomeActiveBigItem();

if(bi==null)
{
	out.println("尚未設定主項目!!");
	return;
}
%>

<h3>收入登入</h3>


  選擇主項目:
  <form action=addIncome2.jsp method=post>
  
  <%
  	for(int i=0;i<bi.length;i++)
  	{
  %>
  	<input type=radio name=bigItem value=<%=bi[i].getId()%>><%=bi[i].getIncomeBigItemName()%> <br>  
  <%
  	}
  %>	
  <br>
  <input type=submit value="下一步">
  </form>
  
   <br>
  
 <br>
 <a href="ListIncomeBigItem.jsp" target="_blank">管理雜費收入項目</a>


