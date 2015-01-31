<%@ page language="java" contentType="text/html;charset=UTF-8"%><%
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney[] cm=ja.getAllClassesMoney(1,category,1);
	
	if(cm==null)
	{
		out.println("<br>目前沒有資料!!");
		return;
	} 
	
	boolean runAuto=false;
%>

<center>
<form action="autoClassesMoneyTypeTalent2.jsp" method="post">


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
		CmxLog[] cl=ja.getCmxLogByCMid(cm[i].getId());
		int talentId=cl[0].getCmxLogXId();
		ClassesCharge cc=ja.getClassesChargeByClass(runDate,cm[i].getId(),talentId,0,2);
	
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
		<% if(runContinue && cc==null){ %>
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
			if(cc==null)
			{
				out.println("尚未登入"); 
				
				if(runContinue) 
				{
					out.println("-<img src=pic/yes.gif border=0>本月可登入");
  				}else{
  		%>		
				-<img src=pic/no.gif border=0>下次延續月份為:<a href="autoClassesMoney.jsp?category=2&year=<%=lastDate.getYear()+1900%>&month=<%=(lastDate.getMonth()<=8)?"0"+String.valueOf(lastDate.getMonth()+1):String.valueOf(lastDate.getMonth()+1)%>"><font color=red><%=sdf.format(lastDate)%></font></a>
 		<%
 				}
			}else{
				out.println("已登入");
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
	<td align=middle>
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
//if(runContinue){ 

	Date CfDiscountDate=jt.getBackContinueDate(cm[i].getClassesMoneyContinue(),runDate);
		if(cc ==null)
		{
			Tadent[] td=ja.getXactiveTadentByTalentId(cl[0].getCmxLogXId(),99);
		
%>	
	<tr class=es02 bgcolor=ffffff>
			<td></td>
			<td bgcolor=f0f0f0>預設金額</td>
			<td>
			<input type=text name="n<%=cm[i].getId()%>" value="<%=cm[i].getClassesMoneyNumber()%>" size=10>
			</td>
			<td>
			<%
			
				CfDiscount[] cfs=fa.getContinueCfDiscountTalent(CfDiscountDate,cm[i].getId());
				
				if(cfs!=null)
				{
			%>
			
				是否使用延續減免:
				
				<input type=radio name="d<%=cm[i].getId()%>" value="1" checked>使用
				<input type=radio name="d<%=cm[i].getId()%>" value="0">停用
				
					<a href="#" onClick="javascript:openwindow47('<%=cm[i].getId()%>','<%=CfDiscountDate.getYear()+1900%>','<%=(CfDiscountDate.getMonth()<10)?"0":""%><%=CfDiscountDate.getMonth()+1%>');return false">(<%=sdf.format(CfDiscountDate)%>延續折扣:</font><font color=blue><%=(cfs==null)?"0":cfs.length%></font>筆)</a>
			<%
				}else{
			%>	
				(<%=sdf.format(CfDiscountDate)%>折扣:<font color=red><%=(cfs==null)?"0":cfs.length%></font>筆&nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:openwindow47('<%=cm[i].getId()%>','<%=CfDiscountDate.getYear()+1900%>','<%=(CfDiscountDate.getMonth()<10)?"0":""%><%=CfDiscountDate.getMonth()+1%>');return false">編輯</a>)
			<%
				}
			%>
			</td>
			<td></td>
	</tr>
	<tr bgcolor=ffffff class=es02>		
			<td>
			</td>
			<td bgcolor=f0f0f0>
			
				學生名單 <br><br>
			
				<a href="#" Onclick="javascript:openwindow23('<%=cl[0].getCmxLogXId()%>');return false"><img src="pic/fix.gif" border=0>編輯</a>
			</td>
			<td colspan=3>
			預計產生:<font color=blue><%=(td==null)?"0":td.length%></font>筆<br>      
			<%	
			if(td ==null)
			{
				out.println("沒有學生");
			}else{
			
				for(int k=0;k<td.length;k++)
				{
					int tdActive=td[k].getTadentActive();
					Student stu=(Student)sm.find(td[k].getTadentStudentId());
					int classId=stu.getStudentClassId();
					
					runAuto=true;
			%>
	<input type=checkbox name="stu<%=cm[i].getId()%>" value="<%=td[k].getTadentStudentId()%>" <%=(tdActive==99)?"checked":""%>>
					<a href="#" onClick="javascript:openwindow15('<%=td[k].getTadentStudentId()%>');return false"><%=stu.getStudentName()%></a>
			<%		
				
					int xk=k+1;
					if(xk%8==0)
						out.println("<br>");
				}
			}
			%>
			</td>
		
		</tr>
		
		
			
<%		
		}else{
			CfDiscount[] cfs=fa.getCfDiscountTalent(runDate,cm[i].getId());
			ClassesFee[] fe=ja.getClassesFeeByClassChargeId(cc.getId());
%>			
			<tr bgcolor=ffffff>
				<td></td>
				<td></td>
				<td colspan=2>
				<a href="#" onClick="javascript:openwindow48('<%=cm[i].getId()%>','<%=runDate.getYear()+1900%>','<%=(runDate.getMonth()<10)?"0":""%><%=runDate.getMonth()+1%>','<%=sdf.format(runDate)%>','1','<%=cc.getId()%>');return false">本月已產生帳單:<font color=blue><%=(fe==null)?"0":fe.length%></font>筆</a><br>
				
				
				
				<%
				if(cfs !=null)
				{
				%>
				<a href="#" onClick="javascript:openwindow47('<%=cm[i].getId()%>','<%=runDate.getYear()+1900%>','<%=(runDate.getMonth()<10)?"0":""%><%=runDate.getMonth()+1%>');return false">
				<%
				}
				%>
				
				本月已登入折扣:<font color=blue><%=(cfs==null)?"0":cfs.length%></font>筆<%=(cfs!=null)?"</a>":""%>
			
				</td>
				<td></td>
			</tr>

<%		
		}
	}		
//}
%>
<tr><td colspan=4>
<%
	if(runAuto) 
	{ 
%>
	<input type=hidden name="year" value="<%=syear%>">
	<input type=hidden name="month" value="<%=smonth%>">
	<center><input type=submit value="產生帳單" onClick="return(confirm('確認自動產生才藝班帳單'))"></center>
<%
	} else{
%>
	<img src="pic/warning.gif" border=0><font color=red>本月沒有可以自動產生的收費項目</font>
<%
	}
%>	

	</td>
	</tr>
	</table>	

	</td>
	</tr>
	</table>

</center>
                                                                                                                                                            	