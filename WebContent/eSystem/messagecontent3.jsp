<%@ page language="java" contentType="text/html;charset=UTF-8"%><%
	MessageMgr mm=MessageMgr.getInstance();
	Message me=(Message)mm.find(meId);

	if(me.getMessageToStatus()==0)
	{ 
	    me.setMessageToStatus(1);	
    	mm.save(me);
	}

	if(me.getMessagePersonType()!=2) 
	{ 
		if(ud2.getId()!=me.getMessageTo())
		{
%>
			<br>
			<br>
			<blockquote>
				此非學生家長訊息,閱讀權限不足!
				
			</blockquote>				
			<%@ include file="bottom.jsp"%>		
<%
			return;		
		}
	
 	} 


	UserMgr um=UserMgr.getInstance();
	User us=(User)um.find(me.getMessageFrom()); 
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");

%>
<table width="60%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>寄件人</td>
		<td class=es02>
		<%=us.getUserFullname()%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[<a href="addMessage.jsp?meId=<%=meId%>">回覆</a>]
		</select> 
		
	</tr> 
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>寄件時間</td>
		<td class=es02>
			<%=sdf.format(me.getMessageFromDate())%>

		</td>
	</tr>					
	
  	<%
		int meType=me.getMessagePersonType();
		int  xId=me.getMessagePersonId();
  		if(meType!=0)
		{
	%>		 
 	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>關係人</td>
		<td class=es02>
			<%
				if(meType==1)	
				{ 
					out.println("教職員-");
					if(xId==0)	
					{
						out.println("全部");
					}else{
						TeacherMgr tm=TeacherMgr.getInstance();
						Teacher tea=(Teacher)tm.find(xId);  
						out.println(tea.getTeacherFirstName()+tea.getTeacherLastName());						
					}
					
				}else if(meType==2){  
					 
					out.println("學生家長-");

					if(xId==0)	
					{
						out.println("全部");
					}else{
						StudentMgr sm=StudentMgr.getInstance();
						Student stu=(Student)sm.find(xId);					
						out.println(stu.getStudentName());
					}
	 	 	 	 } 
			%>

		</td>
	</tr>
	<%
		}
	%>		
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>重要性</td>
		<td class=es02> 
		
		<%
				switch(me.getMessageFromStatus()){
					case 1:
						out.println("<font color=red><b>急迫</b></font>");
						break;
					case 2:
						out.println("<font color=blue>重要</font>");
						break;		
					case 3:
						out.println("普通");
						break;
				}
		%>
			
		</td>
	
	</tr>

	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>主旨</td>
		<td class=es02>
		
<%  
		MessageTypeMgr  mtm=MessageTypeMgr.getInstance();
		
		MessageType  mt=(MessageType)mtm.find(me.getMessageType());
  
   		if(mt!=null)
			out.println(mt.getMessageTypeName());
		else
			out.println("未定");		
%>		
		
- <%=me.getMessageTitle()%>
		
		
		</td>
	</tr>
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 height=250>內容</td>
		<td class=es02 valign=top>
					
		<%=me.getMessageText().replace("\n","<br>")%>
		
		</td>
	</tr>
  	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>
			訊息處理		
		</td>
		<td> 
			<a href="addMessage.jsp?meId=<%=meId%>">回覆此訊息</a>  |  
			<%
			if(me.getMessageActive()==0)
 
			{ 
			%> 
			<a href="deleteMessage.jsp?meid=<%=meId%>&active=1" onClick="return(confirm('確定封存?'))">封存此訊息</a> |
			<%
			}else{
			%> 
			<a href="deleteMessage.jsp?meid=<%=meId%>&active=0" onClick="return(confirm('解除封存?'))">解除封存</a> |
			<%
				}
			%>		
			<a href="listMessage.jsp">回收件匣<img src="pic/message.png" border=0></a>
		</td>
	</tr>		

<form action="modifyMessageStatus.jsp" method="post">	
	<tr align=left valign=middle>
		<td class=es02 colspan=2 align=middle> 
  					處理狀態
  		</td>
	</tr>	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02> 
			處理狀態
		</td>
		<td class=es02>  
			<input type=radio name="status" value="1" <%=(me.getMessageToStatus()==1)?"checked":""%>>已讀取
			<input type=radio name="status" value="2" <%=(me.getMessageToStatus()==2)?"checked":""%>>處理中 
			<input type=radio name="status" value="3" <%=(me.getMessageToStatus()==3)?"checked":""%>>已處理 
			<input type=radio name="status" value="4" <%=(me.getMessageToStatus()==4)?"checked":""%>>重要
		</td>
	</tr> 
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>
			處理紀錄
		</td>
		<td class=es02>
			<textarea name="messageHandleContent" rows=3 cols=40><%=me.getMessageHandleContent()%></textarea>   		
   		</td>
   	</tr>	
   	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#ffffff class=es02 colspan=3 align=middle>
			<input type=hidden name="meid" value="<%=me.getId()%>">
			<input type=submit value="修改處理狀態">
		</td>
   	</tr>	
</form>	

</table>
		
		</td>
	</tr>
</table>

