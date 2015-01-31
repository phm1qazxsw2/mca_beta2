<%@ page language="java" import="web.*,jsf.*,java.util.*" contentType="text/html;charset=UTF-8"%><%
    try
    {
        String sz=request.getParameter("z");
    	int ibi=Integer.parseInt(sz);
    	
    	String statusx=request.getParameter("status");
    	int status=Integer.parseInt(statusx);
    	
    	String r=request.getParameter("r"); 
    	
    	JsfAdmin js=JsfAdmin.getInstance();
		JsfTool jt=JsfTool.getInstance();
		
		StudentMgr sm=StudentMgr.getInstance();
		
		TadentMgr tm=TadentMgr.getInstance();
		Tadent ta=(Tadent)tm.find(ibi);
		
	 	Date rightNow=new Date();
		Talentdate[] td=js.getTalentdateByTalentIdAfterNow(ta.getTadentTalentId(),rightNow);

	 	
	 	Student stu=(Student)sm.find(ta.getTadentStudentId());
	 	
	 	int taActive=ta.getTadentActive();
 %>	
	 <b><%=stu.getStudentName()%></b>-狀態修改
 	<form action="modifyTadent2.jsp" method="post" name="ax">
<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>報名日期</td>
	<td bgcolor=#ffffff>
	<%=jt.ChangeDateToString(ta.getCreated())%>
	
	</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
	<td>加入日期</td>
	<td bgcolor=#ffffff>
	<%
	Date comeDate=ta.getTadentComeDate();
	
	if(comeDate!=null)
	{
		out.println(jt.ChangeDateToString(comeDate));
	}
	%>
	
	</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>狀態</td>
		<td bgcolor=#ffffff>
		
		<table cellpadding="1" cellspacing="1">
		<tr bgcolor="lightgrey"><td>入學中</td><td>非入學中</td></tr>
	<%
		if(status==1)
		{
	%>
		<tr>
		<td>
		
		
		<input type=radio name="tdActive" value=99 <%=(taActive==99)?"checked":""%>>入學中<br>
		</td>
		<td>
		<input type=radio name="tdActive" value=1 <%=(taActive==1)?"checked":""%>>已報名;等待入學<br>
		<input type=radio name="tdActive" value=2 <%=(taActive==2)?"checked":""%>>已報名;拒絕入學<br>
		</td>
		</tr>
		
	<%
		}else{
	%>
		<tr><td>
		<input type=radio name="tdActive" value=99 <%=(taActive==99)?"checked":""%>>入學中<br>
		</td><td>
		<input type=radio name="tdActive" value=1 <%=(taActive==1)?"checked":""%>>已報名;等待入學<br>
		<input type=radio name="tdActive" value=2 <%=(taActive==2)?"checked":""%>>已報名;拒絕入學<br>
		<input type=radio name="tdActive" value=3 <%=(taActive==3)?"checked":""%>>中途退出<br>
		<input type=radio name="tdActive" value=4 <%=(taActive==4)?"checked":""%>>結業<br>
		</td>
		</tr>
	
	<%
		}
	%>
			</table>
		</td>
	</tr>
	<tr bgcolor=#f0f0f0 class=es02>
		<td>狀態說明</td>
		<td bgcolor=#ffffff>
		<textarea rows=3 cols=30 name="activePs"><%=ta.getTadentPs()%></textarea>	
		</td>
	</tr>
	
	<tr bgcolor=#f0f0f0 class=es02>
		<td>最後登入人</tD>
		<td  bgcolor=#ffffff>
	<%
	UserMgr umn=UserMgr.getInstance();
	User u=(User)umn.find(ta.getTalentLog());
	
	if(u==null)
	{
		out.println("無");
	}else{
		out.println(u.getUserFullname());
	}	
	%>-<%=jt.ChangeDateToString(ta.getTalentLogDate())%>	
		
		</td>
	</tr>	
	<tr>
		<td colspan=2>
		
		<input type=hidden name="tadentId" value=<%=ibi%>>
		<center><input type="submit" value="修改"></center>
		</td>
	</tr>
	
	</form>
	</table> 
	</td>
	</tr>
	</table>
	
<%
	TalentFile[] tf=js.getTalentFileByStuIdWithtaId(stu.getId(),ta.getTadentTalentId());
	
	Hashtable haHave=new Hashtable();

	if(tf !=null) 
	{  
		 TalentdateMgr tm2=TalentdateMgr.getInstance(); 
		
%>	
	<br>
	<br>  
	<b>上課概況</b> 
	<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
			<td>時間</tD>
			<tD>出席狀況</tD> 
			<tD>備註</tD>	
			<tD>登入人</tD>	
			<td></tD>
		</tR> 
<%  
	int status90=0;
	int status1=0; 
	int status2=0;
	UserMgr um=UserMgr.getInstance();
	
	
	for(int k2=0;k2<tf.length;k2++)	
	{ 
		Talentdate  tda=(Talentdate)tm2.find(tf[k2].getTalentFileTalentdateId()); 
		 
		if(tda !=null)
  		{

			haHave.put((String)String.valueOf(tf[k2].getTalentFileTalentdateId()),(String)"1");
 %>
		<tr bgcolor=#ffffff class=es02>
			<td><%=jt.ChangeDateToString2(tda.getTalentdateStartDate())%></tD>
			<tD>
			<%
				switch(tf[k2].getTalentFilePresent()) 
				{ 
					case 90:
						out.println("<img src=pic/yes.gif border=0>出席");		
						status90++;							
						break;
					case 1:
						out.println("<img src=pic/no.gif border=0>缺課");									
						status1++;
						break;
					case 2:
						out.println("<img src=pic/no.gif border=0>請假");									
						status2++;
						break;	
					case 4:
						out.println("<img src=pic/no.gif border=0>試聽");									
						break;		
				} 
			%>
			</tD>
			<tD><%=tf[k2].getTalentFileContent()%></tD>	
			<tD><%
			
				User nowU=(User)um.find(tf[k2].getTalentFileUserId()); 
				if(nowU!=null)
  				{
 				out.println(nowU.getUserFullname());
				}
				%></tD> 
			<td>修改</tD>
		</tR>
<% 
		}
	}
%>	
	<tr>
		<td colspan=5 class=es02 align=center> 
			<img src=pic/yes.gif border=0>出席 合計:<%=status90%>,
			<img src=pic/no.gif border=0>缺課 合計:<%=status1%> ,
			<img src=pic/no.gif border=0>請假 合計:<%=status2%>
		</tD>		
	</tr>

		
	</table> 
	</tD>
	</tR>
	</table>
<%
	}
%>
	<br>
	<br> 
<% 
	
	if(td !=null)	
	{
		
%>	

<form action="addtalentFile4.jsp" method="post" target="_blank">	
<b>請假手續</b> 

<table width="85%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
		<tD>請選擇課程</tD>
		<tD  bgcolor=#ffffff> 
		<select name="dateId" size=1>		
		<% 
			boolean showSelect=true;
			for(int li=0;li<td.length;li++)
			{  
				 if(haHave.get(String.valueOf(td[li].getId()))==null)
				 {
		%>		
			<option value="<%=td[li].getId()%>" <%=(li==0)?"selected":""%>><%=jt.ChangeDateToString2(td[li].getTalentdateStartDate())%></option>
		<%  
					showSelect=false;
					
				}
			} 
			
			if(showSelect) 
				out.println("<option selected>沒有可選擇的課程</select>");
		%>
		</select>
		</tD>	
	</tR> 
	<tr bgcolor=#f0f0f0 class=es02>
		<tD>原因</tD>
		<tD  bgcolor=#ffffff>
			<textarea rows=3 cols=20 name="ps"></textarea>  
		</tD>
	</tr> 
	<tr>
		<td colspan=2 align=center> 
			<input type=hidden name="tdfPresent" value="2">  
			<input type=hidden name="taId" value="<%=ta.getTadentTalentId()%>">
			<input type=hidden name="stuId" value="<%=stu.getId()%>">
			<%
				if(!showSelect) 
				{
			%>		
			<input type=submit value="確認">
			<%
				}
			%>	
		</td>
	</tr>
</table> 
	</tD>
	</tr>
	</table>

</form>

<%
	}
%>
		
	
	
<%
    }
    catch(Exception e)
    {
        e.printStackTrace();
        //out.print("bad");
    }
%>