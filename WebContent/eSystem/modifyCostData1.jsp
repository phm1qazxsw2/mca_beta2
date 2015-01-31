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

int costId=Integer.parseInt(request.getParameter("costId"));
BigItem[] bi=ja.getAllActiveBigItem();
CostMgr cm=CostMgr.getInstance();
Cost co=(Cost)cm.find(costId);
User[] u=ja.getLogUsers();

%>

<script type="text/javascript" src="js/xmlhttprequest.js"></script>
<script type="text/javascript" src="js/check.js"></script>
<a href="modifyCost.jsp?costId=<%=costId%>">詳細資料</a>
 修改編輯
<a href="verifyCost.jsp?costId=<%=costId%>">主管審核 </a>
<br>

---------------------------------------------------------------------------
<br>
<%
	int inV=co.getCostVerify();

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
			<td><%=jt.ChangeDateToString(co.getCostVerifyDate())%></td>
		</tr>
		<tr>
			<td bgcolor="lightgrey">主管名稱</td>
			<td>
			<%
			int userIdx=co.getCostVerifyNameId();
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
		
	
<%	
	return;
	}
	
%>
<form action="modifyCostData2.jsp" method="post" name="ax">
<table>
	
	
	<tr>
		<td bgcolor="lightgrey">修改事由</td>
		<td>
		<textarea name=modifyData rows=3 cols=30></textarea>
		
		</td>
	</tr>
	<tr>
		<td colspan=2>-------------------------------------</td>
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">入帳日期</td>
		<td>
		<%
		Date cd=co.getCostDate();
		
		%>
		<input type=text name=costDate value="<%=jt.ChangeDateToString(cd)%>" size=10>
		
		</td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">項目
		<a href="#" onClick="javascript:openwindow19();return false">修改</a>
		</td>
		<td>
	<select name="b" size=1 onChange="getIncomeSmallItem2(this.form.b.value)">
	<option value="0">無</option>
	<%
		int cbi=co.getCostBigItem();
		int csi=co.getCostSmallItem();

		
		BigItem bi2=(BigItem)ja.getBigItemById(cbi);
    		SmallItem si2=(SmallItem)ja.getSmallItemById(csi);
    		
	
	  	for(int i=0;i<bi.length;i++)
	  	{
	  %>
	  	<option value=<%=bi[i].getId()%> <%=(bi[i].getId()==cbi)?"selected":""%>><%=bi[i].getBigItemName()%></option>
	
	  <%
	  	}
	  %>
	</select>
		</td>
		  
	</tr>
	
	<tr>
		<td bgcolor="lightgrey">次項目</td>
		<td>
		<div class="right_content3" id="realtime"><%=si2.getSmallItemName()%></div>
		</td>
	</tr>
	
	
	<tr>
		<td bgcolor="lightgrey">繳款人</td>
		<td>
		<input type=text name="costTo" value="<%=co.getCostTo()%>"  size=10></td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">摘要</td>
		<td>
		<textarea name=costSum cols="40" rows="5"><%=co.getCostName()%></textarea>
		</td>
	
	<tr>
		<td bgcolor="lightgrey">金額</td>
		<td>
		<input type=text name=costMoney value="<%=co.getCostMoney()%>" size=10>
		
		</td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">付款方式</td>
		<td>
		<input type=radio name=payWay value=1 <%=co.getCostPayWay()==1?"checked":""%>>現金<br>
		<input type=radio name=payWay value=2 <%=co.getCostPayWay()==2?"checked":""%>>匯款<br>
		<input type=radio name=payWay value=3 <%=co.getCostPayWay()==3?"checked":""%>>支票<br>
		<input type=radio name=payWay value=4 <%=co.getCostPayWay()==4?"checked":""%>>其他
		
		</td>
	</tr>
	<tr>
		<td bgcolor="lightgrey">記帳人</td>
		<td>
		    <select name="costLog" size=1>
		    <%
		    	for(int i =0;i<u.length ;i++)
		    	{
		    %>	
		    	<option value="<%=u[i].getId()%>" <%=(u[i].getId()==co.getCostLog())?"selected":""%>><%=u[i].getUserFullname()%></option>
		   <%
		   	}
		   %>
		    </select>	
		</td>
		
		
		   
		</td>
		
	</tr>
	
	<tr>
		<td colspan=2>
		<center>
		
			<input type=hidden name=costId value=<%=costId%>>	
			<input type=submit value="確認修改">
		
		</center>
		</td>
	</tr>
	</form>
</table>
<br>

<a href="deleteCost.jsp?costId=<%=costId%>" onClick="return(confirm('確認刪除此筆資料?'))">刪除此筆資料</a>	
