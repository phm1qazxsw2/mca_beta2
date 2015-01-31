<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%
 // 這是被 include 的 file, _ws is defined
 JsfAdmin ja=JsfAdmin.getInstance();
 User[] u2=ja.getAllRunUsers(_ws.getBunitSpace("userBunitAccounting")); 
 if (u2==null) {
    out.println("請先<a href='addUser.jsp'>新增使用者</a>");
    return;
 }
 MessageType[] mt=ja.getActiveMessageType(_ws.getBunitSpace("bunitId"));

 if(mt==null) 
 { 
%>
		<font color=red><b>注意: </b></font> 
		<br>
		<br>
		<blockquote>

		
		尚未加入信件類別!!
		
		<a href="modifyMessageType.jsp">編輯</a> 
		</blockquote>

		<%@ include file="bottom.jsp"%>
<%  	
		return;
	}
%>
<table width="66%" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">

<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>收件人</td>
		<td class=es02> 
		 
			<select name="toUser" size=1 onchange="getEmail(this.options[this.selectedIndex].value)"> 
				 <option value="0">請選擇</option>
 			<%
				for(int i=0;i<u2.length;i++)
				{
			%>	
					<option value="<%=u2[i].getId()%>" <%=(me!=null && me.getMessageFrom()==u2[i].getId())?"selected":""%>><%=u2[i].getUserFullname()%></option>
			<%
				}
			%>
			</select> 
				
		</td>
	</tr>   
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>其他通知方式</td>
		<td class=es02>
			<div id="showEmail" name="showEmail">
		</td>
	</tr>		
	
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>重要性</td>
		<td class=es02>
			<input type=radio name="toStatus" value=1> 急迫
			<input type=radio name="toStatus" value=2> 重要
			<input type=radio name="toStatus" value=3 checked> 普通
			
		</td>
	</tr> 

		<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>關係人</td>
		<td class=es02>
			<%
			if(me==null) 
			{
			%>
						
			 <table border=0>
  				<tr>
  				<td>
  				
 				<select name="personType" size=1 onChange="javascript:getXlist(this.value)">	
				<option value="0">無</option>
				<option value="9999">教職員</option>
 
				<%
				Classes[] cl=ja.getAllActiveClasses();
				
				if(cl !=null)
 
				{ 
 
					for(int i=0;i<cl.length;i++)
  					{
 				%>
					<option value="<%=cl[i].getId()%>"><%=cl[i].getClassesName()%>家長</option>
				<% 
					}
				}
				%>
				</select>					
			</td>
			<td>
				<div name="showXX" id="showXX"></div> 
			</td>
			</tr>
			</table>		
			<%
			}else{ 
				int meType=me.getMessagePersonType();
				int  xId=me.getMessagePersonId();
				
				if(meType==1)	
				{ 
					out.println("教職員-");
					if(xId==0)	
					{
						out.println("全部");
					}else{
						TeacherMgr tm=TeacherMgr.getInstance();
						Teacher tea=(Teacher)tm.find(xId); 
 
						out.println(tea.getTeacherFirstName()+tea.getTeacherLastName());						
					}
					
				}else if(meType==2){ 
 
					 
					out.println("學生家長-");

					if(xId==0)	
					{
						out.println("全部");
					}else{
						StudentMgr sm=StudentMgr.getInstance();
						Student stu=(Student)sm.find(xId);					
						out.println(stu.getStudentName());
					}
	 	 	 	 }else if(meType ==0){
	 	 	 	   	
	 	 	 	   	out.println("未定");		
	 	 	 	 }
	 	 %> 
	 	 	<input type=hidden name=personType  value="<%=meType%>">
	 	 	<input type=hidden name=xId value="<%=xId%>"> 	  	 
	 	   <%
			}
			%>
		</td>
	</tr>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02>主旨</td>
		<td class=es02>
		類別: 
		<select name="messageType" size=1>
 
		<%
			for(int i=0;i<mt.length;i++)
			{
		%>	
				<option value="<%=mt[i].getId()%>" <%=(me!=null && me.getMessageType()==mt[i].getId())?"selected":""%>><%=mt[i].getMessageTypeName()%></option>
		<%
			}
		%> 
		</select>
		<input type="text" name="title" size=35	value="<%=(me!=null)?"Re:"+me.getMessageTitle():""%>">
		
		
		</td>
	</tr>
		
	<tr bgcolor=#ffffff align=left valign=middle>
		<td bgcolor=#f0f0f0 class=es02 height=200>內容</td>
		<td class=es02>
			<textarea rows=10 cols=45 name="content"><%if(me !=null){%> 
<%="\n\n\n\n\n"%>-----------------------------------------<%="\n"%><%=">>>"+me.getMessageText()%>
			<%}%></textarea>
		
		
		</td>
	</tr> 
	<tr align=left valign=middle>
		<td class=es02 colspan=2> 
			<center>
			<input type=submit value="發送訊息">
			</center>		
		</td>
	</tr>
</table>
		
		</td>
	</tr>
</table>
<%
	if(me !=null) 
	{ 
%>
	<script>
			getEmail('<%=me.getMessageFrom()%>');
	</script>
<%
	}
%>		
