<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=2;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%

JsfAdmin ja=JsfAdmin.getInstance();
JsfTool jt=JsfTool.getInstance();
int incomeId=Integer.parseInt(request.getParameter("incomeId"));

IncomeMgr cm=IncomeMgr.getInstance();
Income co=(Income)cm.find(incomeId);



ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();

User[] u=ja.getManagerUsers();
%>
<a href="modifyIncome.jsp?incomeId=<%=incomeId%>">詳細資料</a>
<a href="modifyIncomeData1.jsp?incomeId=<%=incomeId%>">修改編輯</a>  
主管審核

<br>
<br>
---------------------------------------------------------------------------
<br>

<%
	int inV=co.getIncomeVerify();

	if(inV >=90)
	{
%>	
	<table>
		<tr>
			<td bgcolor="lightgrey">狀態</td>
			<td>
			<font color=blue>
			<%
			switch(inV)
			{
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
			</font>
			</td>
		</tr>
		<%
			if(inV >=98)
			{
		%>
		<tr>
			<td bgcolor="lightgrey">審核日期</td>
			<td><%=jt.ChangeDateToString(co.getIncomeVerifyDate())%></td>
		</tr>
		<tr>
			<td bgcolor="lightgrey">主管名稱</td>
			<td>
			<%
			int userIdx=co.getIncomeVerifyNameId();
			UserMgr ub=UserMgr.getInstance();
			User iu=(User)ub.find(userIdx);
			out.println(iu.getUserFullname());
			%>
			</td>
		</tr>
		<%
			}
		%>
		
	</table>	
	<br>
------------------<font color=red>還原修改狀態</font>-------------------
	<br>
	
	<form action="verifyManager.jsp" method="post">
	<table>
	<tr>
	<td bgcolor="lightgrey">主管姓名</td>
	<td>
	
	<%
	if(u==null)
	{
		out.println("<font color=red>尚未登入主管資料!!</font></td></tr>");
		return;
	}	
	%>
	
		<select name="managerName" size=1>
	<%
		for(int i=0;i<u.length;i++)
		{
	%>	
			<option value="<%=u[i].getId()%>"><%=u[i].getUserFullname()%></option>
	<%
		}
	%>
	
		</select>
	</td>
	
</tr>


<tr>
	<td bgcolor="lightgrey">
		驗證密碼
	</td>
	<td>
		<input type=password name="managerPass" size=15>
	</td>
</tr>
<tr>
		<td bgcolor="lightgrey">修改事由</td>
		<td>
		<textarea name=modifyData rows=3 cols=30></textarea>
		
		</td>
	</tr>	
<tr>
	<td colspan=2>
		<input type=hidden name=costId value=<%=incomeId%>>
		<center><input type=submit onClick="return(confirm('確認修改?'))" value="修改"></center>
	</td>
</tr>
<table>
	</form>
	
<%	
	return;
	}
	
%>

<form action="verifyIncome2.jsp" method="post">
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
		<input type=text name="vMoney" value="<%=co.getIncomeMoney()%>" size=10>
		
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
------------------<font color=red>主管審核</font>-------------------
<br>
<table>


<tr>
	<td bgcolor="lightgrey">主管姓名</td>
	<td>
	
	<%
	if(u==null)
	{
		out.println("<font color=red>尚未登入主管資料!!</font></td></tr>");
		return;
	}	
	%>
	
		<select name="managerName" size=1>
	<%
		for(int i=0;i<u.length;i++)
		{
	%>	
			<option value="<%=u[i].getId()%>"><%=u[i].getUserFullname()%></option>
	<%
		}
	%>
	
		</select>
	</td>
</tr>
<tr>
	<td bgcolor="lightgrey">
		驗證密碼
	</td>
	<td>
		<input type=password name="managerPass" size=15>
	</td>
</tr>
	
	<tr>
		<td colspan=2>
		<center>
		
			<input type=hidden name=incomeId value=<%=incomeId%>>	
			<input type=submit value="確認修改">
		
		</center>
		</td>
	</tr>
	
	
	
</table>	
</form>
<br>
<br>
