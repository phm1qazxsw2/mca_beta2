<%@ page language="java" buffer="32kb" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%
 request.setCharacterEncoding("UTF-8");
 String costDate=request.getParameter("costDate"); 
 String costSum=request.getParameter("costSum");
 String costTo=request.getParameter("costTo");
 String costLog=request.getParameter("costLog");
 int costMoney=Integer.parseInt(request.getParameter("costMoney"));
 int payWay=Integer.parseInt(request.getParameter("payWay")); 
 
 int costId=Integer.parseInt(request.getParameter("costId")); 

IncomeMgr cm=IncomeMgr.getInstance();
Income c=(Income)cm.find(costId);

SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
Date payDate=sdf1.parse(costDate);

c.setIncomeName   	(costSum);
c.setIncomeMoney   	(costMoney);
c.setIncomePayWay   	(payWay);
c.setIncomeDate   	(payDate);
c.setIncomeFrom  	(costTo);
c.setIncomeLog   	(costLog);
  
cm.save(c);

Income co=(Income)cm.find(costId);

%>


<h3>你所修改的資料如下:</h3>

<table>
	<tr>
		<td></td><td></td>
	</tr>
	<tr>
		<td>日期</td>
		<td>
		<%
		Date cd=co.getIncomeDate();
		out.println(sdf1.format(cd));
		%></td>
	</tr>
	
	<tr>
		<td>次項目</td>
		<td>
<%
		int cbi=co.getIncomeBigItem();
		int csi=co.getIncomeSmallItem();

		JsfAdmin ja=JsfAdmin.getInstance();
		BigItem bi2=(BigItem)ja.getBigItemById(cbi);
    		SmallItem si2=(SmallItem)ja.getSmallItemById(csi);
%>
		<%=bi2.getBigItemName()%>-><%=si2.getSmallItemName()%>		
		</td>
	</tr>
	<tr>
		<td>繳款人</td>
		<td><%=co.getIncomeFrom()%></td>
	</tr>
	<tr>
		<td>摘要</td>
		<td>
			<%=co.getIncomeName()%>
		</td>
	
	<tr>
		<td>金額</td>
		<td>
		<font color=blue><%=co.getIncomeMoney()%></font>	
		</td>
	</tr>
	<tr>
		<td>付款方式</td>
		<td>
		<%=co.getIncomePayWay()==1?"現金":"其他"%>	
		</td>
	</tr>
	
	<tr>
		<td>記帳人</td>
		<td>
		   <%=co.getIncomeLog()%>
		</td>
		
	</tr>
	<tr>
		<td>對帳</td>
		<td>
		<%
		int costV=co.getIncomeVerify();
		
		if(costV==0)
			out.println("尚未查帳");
		else
			out.println("已查帳");
		%>
		</td>
	</tr>
	
	
	
</table>	
<br>
<br>
<a href="index.jsp">回首頁</a> 

