<%@ page language="java" contentType="text/html;charset=UTF-8"%><%
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney[] cm=ja.getAllClassesMoney(1,category,1);
	//StudentMgr sm=StudentMgr.getInstance();	
	if(cm==null)
	{
		out.println("<br>目前沒有資料!!");
		return;
	} 
	
	boolean runAuto=false;

%>

<center>
<form action="autoClassesMoneyTypePerson2.jsp" method="post">


	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr class=es02>
			<td>開徵名稱</td><td>帳單形式</td><td>本月狀態</td><td>延續狀態-延續區間</td><td>上次延續月份</td>
		</tr>
<%
	ClassesMgr cmx=ClassesMgr.getInstance();
	TalentMgr tmx=TalentMgr.getInstance();
	StudentMgr sm=StudentMgr.getInstance();
	long runLong=runDate.getTime();
	for(int i=0;i<cm.length;i++)
	{
		Date continueDate=cm[i].getClassesMoneyContinueDate();
		long continuelong=continueDate.getTime();

		boolean runContinue=false;
		Date lastDate=new Date();
		if(runLong==continuelong)
		{
			runContinue=true;
		}else{
			lastDate=jt.getContinuedDate(continueDate,cm[i].getClassesMoneyContinue());
			long lastLong=lastDate.getTime();
			
			if(runLong==lastLong)
				runContinue=true;
		}
%>
	<tr <%=(runContinue)?"bgcolor=A9B0F6":"bgcolor=f0f0f0"%> class=es02>

	<td>
		<% if(runContinue){ %>
		<input type=checkbox name="addCmId" value="<%=cm[i].getId()%>" checked>
		<%
		}
		%>
		<a href="#" onClick="javascript:openwindow26('<%=cm[i].getId()%>');return false"><%=cm[i].getClassesMoneyName()%></a>
	</td>
	<td align=left>
		
	<%
		int type=cm[i].getClassesMoneyNewFeenumber();
		
		if(type==0)
		{
			out.println("月帳單");
		}
		else if(type==1)
		{
			out.println("獨立帳單");
			ClassesMoney[] cm3=ja.getClassesMoneyByNewFeenumber(cm[i].getId());
			if(cm3!=null)
			{	
				for(int p=0;p<cm3.length;p++)
				{
					out.println(cm3[p].getClassesMoneyName()+",");
				}
				out.println("為本單的附屬單");
			}
			
		}else if(type==2){
			out.println("帳單附屬-附屬於:");
			int fcmID=cm[i].getClassesMoneyNewFeenumberCMId();
			ClassesMoney cm2=(ClassesMoney)cmm.find(fcmID);
			out.println(cm2.getClassesMoneyName());
		}
	%>
	</td>
	<td>
		<%
				if(runContinue) 
				{
					out.println("本月可登入");
  				}else{
  		%>		
			下次延續月份為:<a href="autoClassesMoney.jsp?category=3&year=<%=lastDate.getYear()+1900%>&month=<%=(lastDate.getMonth()<=8)?"0"+String.valueOf(lastDate.getMonth()+1):String.valueOf(lastDate.getMonth()+1)%>"><font color=red><%=sdf.format(lastDate)%></font></a>
 		<%
 				}
		%>		
	</td>
	
	<td>
	<%
		if(cm[i].getClassesMoneyContinueActive()==0)
		{
			out.println("停用中");
		}else{
			out.println("使用中-");
		
			switch(cm[i].getClassesMoneyContinue())
			{
				case 1:
					out.println("每一個月");
					break;
				case 2:
					out.println("每二個月");
					break;
				case 3:
					out.println("每三個月");
					break;
				case 4:
					out.println("每六個月");
					break;
				case 5:
					out.println("每一年");
					break;
			}
	
		}
		
	%>		
	</td>
	<td align=center>
		<font color=blue><%=sdf.format(continueDate)%></font>
		<%
			if(!runContinue) 
			{
		%>
				<a href="#" onClick="javascript:openwindow26('<%=cm[i].getId()%>');return false"><img src="pic/fix.gif" border=0>[修改]</a>
		<%
			}
		%>
	</td>
	
	</tr>
	
	
<%
if(runContinue){ 

	Date CfDiscountDate=jt.getBackContinueDate(cm[i].getClassesMoneyContinue(),runDate);
		
%>	
	<tr class=es02 bgcolor=ffffff>
			<td></td>
			<td bgcolor=f0f0f0>預設金額</td>
			<td>
			將延續個人的開單金額
			</td>
			<td>
			<%
			
				CfDiscount[] cfs=fa.getContinueCfDiscountTalent(CfDiscountDate,cm[i].getId());
				
				if(cfs!=null)
				{
			%>
			
				是否延續折扣:
				<input type=radio name="d<%=cm[i].getId()%>" value="1" checked>是
				<input type=radio name="d<%=cm[i].getId()%>" value="0">否
				<a href="#" onClick="javascript:openwindow47('<%=cm[i].getId()%>','<%=CfDiscountDate.getYear()+1900%>','<%=(CfDiscountDate.getMonth()<10)?"0":""%><%=CfDiscountDate.getMonth()+1%>');return false">
				<%=sdf.format(CfDiscountDate)%>折扣:<font color=blue><%=(cfs==null)?"0":cfs.length%></font>筆</a>
			<%
				}
			%>
			</td>
			<td></td>
	</tr>
	<tr bgcolor=ffffff class=es02>		
			<td>
			</td>
			<td bgcolor=f0f0f0>名單管理</td>
			<td colspan=3>
<%
		Classes[] cla=ja.getAllClasses();

		for(int k=0;k<cla.length;k++)
		{ 
			ClassesFee[] fe=ja.getClassesFeeBycmIdClassId(CfDiscountDate,cm[i].getId(),cla[k].getId());
			ClassesFee[] fe2=ja.getClassesFeeBycmIdClassId(runDate,cm[i].getId(),cla[k].getId());

%>
			<%=cla[k].getClassesName()%> 
<%
			if(fe2!=null) 
			{ 
				out.println("本月已產生<br>");	
				continue;	
			} 
%>
			合計:<font color=blue><%=(fe==null)?"0":fe.length%></font>筆 
			<%
				if(fe!=null) 
				{ 
					out.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
					for(int k2=0;k2<fe.length;k2++) 
					{   
						int k3=k2+1;
						
						if(k3>4 && k3%4==1)
							out.println("<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");						

						 Student stu=(Student)sm.find(fe[k2].getClassesFeeStudentId());
			
						runAuto =true;
			%>
					<input type=checkbox name="<%=cm[i].getId()%>" value="<%=fe[k2].getId()%>" checked><%=stu.getStudentName()%>(金額:<%=fe[k2].getClassesFeeShouldNumber()%>)
			<%			
					}  
				}	
			%>

			<br>
<%
		}
%>			 
			</td>
		
		</tr>
		
		
<%	
	}		
}
%>

<%
	if(runAuto) 
	{ 
%>	
<tr class=es02><td colspan=5>
	<input type=hidden name="year" value="<%=syear%>">
	<input type=hidden name="month" value="<%=smonth%>">
	<center><input type=submit value="產生帳單" onClick="return(confirm('確認自動產生個人帳單'))"></center>
</td>
</tr>	

<%
	}else{
%> 
<tr bgcolor=ffffff class=es02><td colspan=5>
	<img src="pic/warning.gif" border=0><font color=red>本月沒有可以自動產生的收費項目.</font>
	</td>
	</tr>


<%
	}
%>	
	</table>	

	</td>
	</tr>
	</table>
</center>

<br>
<br>                                                                                                                                                            	