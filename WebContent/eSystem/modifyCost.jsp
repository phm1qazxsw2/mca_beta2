<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%

JsfTool jt=JsfTool.getInstance();
int costId=Integer.parseInt(request.getParameter("costId"));

CostMgr cm=CostMgr.getInstance();
Cost co=(Cost)cm.find(costId);

%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
詳細資料  
<a href="modifyCostData1.jsp?costId=<%=costId%>">修改編輯</a>  
<a href="verifyCost.jsp?costId=<%=costId%>">主管審核 </a>
<br>
<br>
---------------------------------------------------------------------------
<br>
<form action="modifyCost2.jsp" method="post">
<table>
	<tr>
		<td bgcolor="lightgrey">登入日期</td>
		<td>
		<%
		Date cdx=co.getCreated();
		
		%>
		<%=jt.ChangeDateToString(cdx)%>
		</td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">入帳日期</td>
		<td>
		<%
		Date cd=co.getCostDate();
		
		%>
		<%=jt.ChangeDateToString(cd)%>
		
		</td>
	</tr>
	
	<tr>
		<td>項目別</td>
		<td>
<%
		int cbi=co.getCostBigItem();
		int csi=co.getCostSmallItem();

		JsfAdmin ja=JsfAdmin.getInstance();
		BigItem bi2=(BigItem)ja.getBigItemById(cbi);
    		SmallItem si2=(SmallItem)ja.getSmallItemById(csi);
%>
		<%=bi2.getBigItemName()%>-><%=si2.getSmallItemName()%>		
		</td>
	</tr>
	<tr>
		<td>受款人</td>
		<td><%=co.getCostTo()%></td>
	</tr>
	<tr>
		<td>摘要</td>
		<td>
		<%=co.getCostName()%>
		</td>
	
	<tr>
		<td>金額</td>
		<td>
		<font color=blue><%=co.getCostMoney()%></font>
		
		</td>
	</tr>
	<tr>
		<td>付款方式</td>
		<td>
		<%
		switch(co.getCostPayWay())
		{
			case 1:
				out.println("現金");
				break;
			case 2:
				out.println("匯款");
				break;
			case 3:
				out.println("支票");
				break;
			case 4:
				out.println("其他");
				break;
		}
		%>
		</td>
	</tr>
	
	<tr>
		<td>記帳人</td>
		<td>
		  <%
			UserMgr um=UserMgr.getInstance();
			User ux=(User)um.find(co.getCostLog());	
			out.println(ux.getUserFullname());
		%>
		</td>
		
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">狀態</td>
		<td>
		<%
	
		int costV=co.getCostVerify();
		
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
		

		
	</tr>
	
	
</table>	

<br>
<br>

<br>
<br>
------------------修改紀錄-------------------
<%
CoModify[] inm=ja.getAllComodify(costId);

if(inm==null)
{
	out.println("<br><br>沒有修改紀錄!!");
}
else
{
%>

<table>
<tr>
	<td bgcolor="lightgrey">修改時間</td><td bgcolor="lightgrey" width=200>事由</td><td bgcolor="lightgrey">修改人</td>
</tr>
<%
	UserMgr umx=UserMgr.getInstance();
	
	

	for(int k=0;k<inm.length;k++)
	{
		String uName="無";
		if(inm[k].getCoModifyUser()!=0)
		{
			User ur=(User)umx.find(inm[k].getCoModifyUser());
			uName=ur.getUserFullname();
		}
	
	
%>
	<tr>
	<td><%=jt.ChangeDateToString(inm[k].getCreated())%></td><td><%=inm[k].getCoModifyNotice()%></td><td><%=uName%></td>
</tr>	
<%
	}
%>
</table>
<%
}
%>

