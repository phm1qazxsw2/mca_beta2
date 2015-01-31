<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%

JsfTool jt=JsfTool.getInstance();
JsfAdmin ja=JsfAdmin.getInstance();
//Date studentBirth2=jt.ChangeToDate(studentBirth);
//jt.ChangeDateToString() 

int costId=Integer.parseInt(request.getParameter("incomeId"));
IncomeBigItem[] bi=ja.getAllIncomeActiveBigItem();
IncomeMgr cm=IncomeMgr.getInstance();
Income co=(Income)cm.find(costId);
User[] u=ja.getLogUsers();

%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
詳細資料  
<a href="modifyIncomeData1.jsp?incomeId=<%=costId%>">修改編輯</a>  
<a href="verifyIncome.jsp?incomeId=<%=costId%>">主管審核 </a>

<br>
<br>
---------------------------------------------------------------------------
<br>

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
		Date cd=co.getIncomeDate();
		
		%>
		<%=jt.ChangeDateToString(cd)%>
		
		</td>
	</tr>
	<tr>
	
	<%
		int cbi=co.getIncomeBigItem();
		int csi=co.getIncomeSmallItem();

		
		IncomeBigItem bi2=(IncomeBigItem)ja.getIncomeBigItemById(cbi);
    		IncomeSmallItem si2=(IncomeSmallItem)ja.getIncomeSmallItemById(csi);
%>
		<td bgcolor="lightgrey">項目
		
		</td>
		<td>
	
		<%=bi2.getIncomeBigItemName()%>-<%=si2.getIncomeSmallItemName()%></option>


	
		
		</td>
		  
	</tr>
	
	
	
	<tr>
		<td bgcolor="lightgrey">繳款人</td>
		<td>
		<%=co.getIncomeFrom()%>
	</tr>
	<tr>
		<td bgcolor="lightgrey">摘要</td>
		<td>
		<%=co.getIncomeName()%>
		</td>
	
	<tr>
		<td bgcolor="lightgrey">金額</td>
		<td>
		<font color=blue><%=co.getIncomeMoney()%></font>
		
		</td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">付款方式</td>
		<td>
		<%
		switch(co.getIncomePayWay())
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
		<td bgcolor="lightgrey">記帳人</td>
		<td>
		<%
			UserMgr um=UserMgr.getInstance();
			User ux=(User)um.find(co.getIncomeLog());	
			out.println(ux.getUserFullname());
		%>
		   
		</td>
		
		
		   
		</td>
		
	</tr>
	
	
	<tr>
		<td bgcolor="lightgrey">狀態</td>
		<td>
		<%
	
		int costV=co.getIncomeVerify();
		
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
		
		
		   
		</td>
		
	</tr>
	
</table>	

<br>
<br>
------------------修改紀錄-------------------
<%
InModify[] inm=ja.getAllInmodify(costId);

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
		if(inm[k].getInModifyUser()!=0)
		{
			User ur=(User)umx.find(inm[k].getInModifyUser());
			uName=ur.getUserFullname();
		}
	
	
%>
	<tr>
	<td><%=jt.ChangeDateToString(inm[k].getCreated())%></td><td><%=inm[k].getInModifyNotice()%></td><td><%=uName%></td>
</tr>	
<%
	}
%>
</table>
<%
}
%>



