<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="justHeader.jsp"%>
<%
	Message[] me=ja.getNotHandleMessage(ud2);
	SimpleDateFormat sdfMessage=new SimpleDateFormat("yyyy-MM-dd HH:mm"); 
	
	MessageType[] mt=ja.getActiveMessageType(_ws2.getBunitSpace("bunitId")); 
	
	User[] u2=ja.getAllUsers(_ws2.getBunitSpace("userBunitAccounting"));
	Hashtable haU=new Hashtable();
	for(int ix2=0;ix2<u2.length;ix2++)
		 haU.put(String.valueOf(u2[ix2].getId()),u2[ix2]);

	
	
	Hashtable haMessage=new Hashtable();
	
	for(int ix=0;ix<mt.length;ix++)
		 haMessage.put(String.valueOf(mt[ix].getId()),mt[ix].getMessageTypeName());

	if(u2!=null && mt!=null && me !=null)
	{
%> 
<script>
	function goRead(meId)
 
	{ 
		window.location="detailMessage.jsp?meId="+meId;	
	} 

</script>

	<b>尚未處理的訊息:</b>
	 <br>
	<table width="80%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">
		<table width="100%" border=0 cellpadding=4 cellspacing=1>
			<tr bgcolor=#f0f0f0  class=es02 align=left valign=middle>
				<td>處理狀態</td>
				<td align=middle>急迫性</td>
				<td align=middle>類別</td>
				<td  align=middle width=250>主旨</td>
				<td  align=middle>寄件人</td>
				<td align=middle>
				寄件時間
				</td>
			</tr>
	<%
		for(int i=0;i<me.length;i++)
		{
	%>
		<tr bgcolor=#ffffff align=left onClick="javascript:goRead('<%=me[i].getId()%>')" onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td align=left class=es02><%
			switch(me[i].getMessageToStatus())
			{
				case 0:
					out.println("<font color=blue>New</font>");
  					break;
 				case 1:
					out.println("");
  					break;		
 				case 2:
					out.println("<font color=red>處理中</font>");
  					break;		
				case 3:
					out.println("已處理");
  					break;		 			
  				case 4:
					out.println("<font color=red>*重要</font>");
  					break;				  
 			    } 
			%></td>
		<td align=left class=es02><%
				switch(me[i].getMessageFromStatus()){
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
			
			%></td>
		<td align=left class=es02><%
				String typeString=String.valueOf(me[i].getMessageType());
				out.println((String)haMessage.get(typeString));
			
			%></td>
		<td align=left class=es02><a href="detailMessage.jsp?meId=<%=me[i].getId()%>"><%=me[i].getMessageTitle()%></a></td>
		<td align=left class=es02>
		<%
			String userString=String.valueOf(me[i].getMessageFrom());
			
			User u3=(User)haU.get(userString);
 
			
			if(u3==null)
  				out.println("no data");
 			else
 				out.println(u3.getUserFullname());		
 		%> 
		</td>
		<td align=left class=es02><%=sdfMessage.format(me[i].getMessageFromDate())%></td>
	</tr>
	<%
		}
	%>				
	</table>
	</td>
	</tr>
	</table>			
	<br>
<%
	}
%>	
