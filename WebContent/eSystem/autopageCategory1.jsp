<%@ page language="java" contentType="text/html;charset=UTF-8"%><%
	ClassesMoneyMgr cmm=ClassesMoneyMgr.getInstance();
	ClassesMoney[] cm=ja.getAllClassesMoney(1,category,1);
	
	if(cm==null)
	{
		out.println("<br>目前沒有延續的收費項目!!");
		return;
	} 
	
	boolean runAuto=false;
%>
<center>
<form action="autoClassesMoney2.jsp" method="post">
 

	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr class=es02>
			<td>開徵名稱</td><td>帳單形式</td><td>本月狀態</td><td>延續狀態-延續區間</td><td>上次延續月份</td>
		</tr>
<%
	ClassesMgr cmx=ClassesMgr.getInstance();
	ClsGroupMgr gmx = ClsGroupMgr.getInstance();
	TalentMgr tmx=TalentMgr.getInstance();
	
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

		CmxLog[] cl=ja.getCmxLogByCMid(cm[i].getId());
%>
	<tr <%=(runContinue)?"bgcolor=A9B0F6":"bgcolor=f0f0f0"%> class=es02>

	<td class=es02>
		<% if(runContinue){ %>
			<input type=checkbox name="addCmId" value="<%=cm[i].getId()%>" checked>
		<%}%>
		<a href="#" onClick="javascript:openwindow26('<%=cm[i].getId()%>');return false"><%=cm[i].getClassesMoneyName()%></a>
	</td>
	<td align=left class=es02>
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
		<%=(runContinue)?"<img src=pic/yes.gif border=0><font color=blue>可自動產生</font>":"<img src=pic/no.gif border=0>"%>
		<%
			if(!runContinue) 
			{ 
		%>
			下次延續月份為:<a href="autoClassesMoney.jsp?category=1&year=<%=lastDate.getYear()+1900%>&month=<%=(lastDate.getMonth()<=8)?"0"+String.valueOf(lastDate.getMonth()+1):String.valueOf(lastDate.getMonth()+1)%>"><font color=red><%=sdf.format(lastDate)%></font></a>
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
	Date CfDiscountDate=jt.getBackContinueDate(cm[i].getClassesMoneyContinue(),runDate);

	//if(runContinue)
	//{
		for(int k=0;cl!=null && k<cl.length;k++)
		{
			if(cl[k].getCmxLogCategory()==1)
			{ 
				if(cl[k].getCmxLogXId()==0)
 
					 continue;
	%>
		<tr bgcolor=ffffff class=es02>
		<td></td>
		<td>
 
		<%
				
			Classes cla=(Classes)cmx.find(cl[k].getCmxLogXId());
			int groupId = cl[k].getCmxLogYId();
			ClsGroup grp = (groupId>0)?(ClsGroup)gmx.find(groupId):null;
			
			CfDiscount[] cfds2=fa.getCfDiscountByClassesId(cla.getId(),runDate,cm[i].getId()); 
			
			if(cla !=null){
				Student[] st=ja.getStudyStudents(cla.getId(), groupId, 999,999,7);
 
				ClassesCharge cc=ja.getClassesChargeByClass(runDate,cm[i].getId(),cla.getId(),groupId,1);

				ClassesCharge cc2=ja.getClassesChargeByClass(CfDiscountDate,cm[i].getId(),cla.getId(),groupId,1);
		
				if(cc ==null)
				{
		%>		
		<table border=0  width=100% cellpadding="0" cellspacing="0" class=es02> 
			<tr class=es02>
				<tD width=5>
					<% 
                        if(st!=null && runContinue){ %>
						<input type=checkbox name="<%=cm[i].getId()%>" value="<%=cla.getId()+((groupId>0)?("#"+groupId):"")%>" checked>
					<% 
							runAuto=true; 
							
						} 
					%>
				</td>
				<td nowrap>
					<%=cla.getClassesName() + ((grp!=null)?("-"+grp.getName()):"")%>						
	                 <% if(runContinue){  %>   					
                            <a href="#" onClick="javascript:openwindow42('<%=cm[i].getId()%>','<%=runDate.getYear()+1900%>','<%=((runDate.getMonth()+1)<10)?"0":""%><%=runDate.getMonth()+1%>');return false">預計產生:<font color=blue><%=(st==null)?"0":st.length%></font>筆</a>			
					 <%  }else{  %>
                            (尚未產生)
                     <%  }  %>
      
                    </td>
				</tr>
			</table>			 

			<%
			ClassesFee[] cfs=fa.getClassesFeeByCmid(cm[i].getId(),CfDiscountDate,cla.getId());				 		
	
				}else{
					ClassesFee[] cfs=fa.getClassesFeeByCmid(cm[i].getId(),runDate,cla.getId());
					
		%>
 
			<table border=0 height=35 width=100% cellpadding="0" cellspacing="0"> 
				<tr class=es02>
					<tD>
					</td> 
					<td>	
					&nbsp;<%=cla.getClassesName() + ((grp!=null)?("-"+grp.getName()):"")%>

					&nbsp;&nbsp;<a href="#" onClick="javascript:openwindow41('<%=cm[i].getId()%>','<%=runDate.getYear()+1900%>','<%=((runDate.getMonth()+1)<10)?"0":""%><%=runDate.getMonth()+1%>','<%=sdf.format(runDate)%>','<%=cla.getId()%>','<%=cc.getId()%>');return false">已產生帳單:<font color=blue><%=(cfs==null)?"0":cfs.length%></font>筆</a>
					</td> 
				</tr>
			
			</table>		
		<%
		}
		%>

			</td>
			<td>
 
				 預設金額:
				<%
				if(cc ==null)
				{
				%>
					<% if(st!=null && runContinue){ %>
						<input type=text name="n<%=cm[i].getId()%>" value="<%=cm[i].getClassesMoneyNumber()%>" size=6>
					<% } else { out.print(cm[i].getClassesMoneyNumber()); }%>
					元
				<%
				}else{
				%>
					<%=cc.getClassesChargeMoneyNumber()%> 元
				<%
				}
				%>
			</td>
			<td>
			<%
			if(cc ==null)
			{
				if(st!=null){ 
					CfDiscount[] cfs=fa.getContinueCfDiscountByClassesId(cla.getId(),groupId,CfDiscountDate,cm[i].getId());
			%> 
				<table border=0  width=100% cellpadding="0" cellspacing="0" class=es02> 
					<% if(cfs !=null){  %>
						<tr>
							<tD width=15>
								<input type=checkbox name="d<%=cm[i].getId()%>" value="<%=cla.getId()%>" checked>
							</tD>
							<td>		
								使用延續折扣?
							</tD>
						</tr>
						<tr>
							<td></td>
							<td>
								<a href="#" onClick="javascript:openwindow44('<%=cla.getId()%>','<%=cm[i].getId()%>','<%=CfDiscountDate.getYear()+1900%>','<%=((CfDiscountDate.getMonth()+1)<10)?"0":""%><%=CfDiscountDate.getMonth()+1%>');return false">延續折扣:<font color=blue><%=(cfs==null)?"0":cfs.length%></font>筆</a>
							</td>	
						</tr> 
				
					<% }else{ %>
 
						<tr>
							<td></td>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;上期沒有折扣資料 
							</td>	
						</tr> 
					<%	}  %>
					
				</table>
			<%
				}
					}else{
			%>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" onClick="javascript:openwindow44('<%=cla.getId()%>','<%=cm[i].getId()%>','<%=runDate.getYear()+1900%>','<%=((runDate.getMonth()+1)<10)?"0":""%><%=runDate.getMonth()+1%>');return false">已產生折扣:<font color=blue><%=(cfds2==null)?"0":cfds2.length%></font>筆</a>
			<%
			} 
			%>
			</td>
			<td>
			</td>
		<%	
				}	
		%>	
	</tr>
<%
			}
		}
	}
 //}
%>	
<tr>
	<td colspan=4> 
		 <% 
		if(runAuto)
  		{
  		%>		
 		<input type=hidden name="year" value="<%=syear%>">
		<input type=hidden name="month" value="<%=smonth%>">
		<center>
			<input type=submit value="產生帳單" onClick="return(confirm('確認自動產生帳單?'))">
		</center>
		<%
		}else{
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

<!--- end 主內容 --->
<br>
<br>
