<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%
    int topMenu=8;
    int leftMenu=1;
%>
<%@ include file="topMenu.jsp"%>
<%@ include file="leftMenu8.jsp"%>
<%
 JsfAdmin ja=JsfAdmin.getInstance();
 
 int active=0;
 String activeS=request.getParameter("active");
 
 if(activeS !=null)
 	active=Integer.parseInt(activeS);  
    
 Message[] me=ja.getAllMessage(ud2,999,999,999,999,999,active, _ws.getBunitSpace("bunitId"));
%>
 
<br>
&nbsp;&nbsp;&nbsp;<img src="pic/message2.gif" border=0 alt="收件匣"> <%=(active==0)?"<b>收件匣</b>":"<b>封存的訊息</b>"%> 

<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br>

<%
	
	MessageType[] mt=ja.getActiveMessageType(_ws.getBunitSpace("bunitId")); 
	Hashtable ha=new Hashtable();
	
	if(mt ==null) 
	{ 
		out.println("<blockquote>尚未設定訊息類別<br><br><a href=\"modifyMessageType.jsp\">編輯訊息類別</a></blockquote>");
		return;
	}
		for(int ix=0;ix<mt.length;ix++)
		 ha.put(String.valueOf(mt[ix].getId()),mt[ix].getMessageTypeName());
	
	User[] u2=ja.getAllUsers(_ws.getBunitSpace("userBunitAccounting"));
	Hashtable haU=new Hashtable();
	for(int ix2=0;ix2<u2.length;ix2++)
		 haU.put(String.valueOf(u2[ix2].getId()),u2[ix2]);
	
	 
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
%> 

    <div class=es02>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="addMessage.jsp" border=0><img src="pic/add.gif"  width=15 border=0 alt="新增訊息">&nbsp;新增訊息</a> | 
	
	<%
		if(active==0)	
		{
	%>
			<a href="listMessage.jsp?active=1"
>封存的訊息</a>
			
	<%
		}else{
	%>
			<a href="listMessage.jsp?active=0"><img src="pic/message.png" border=0 alt="收件匣">回收件匣</a>
	<%
		}
	%>				
    </div>
<center>
<%
	if(me==null)
	{		
%> 
		目前沒有訊息! ! 
		<%@ include file="bottom.jsp"%>	
		
<%
		return;
	}
%> 
<script>
	function goRead(meId) 
	{ 
		window.location="detailMessage.jsp?meId="+meId;	
	} 

</script>
<div align=right class=es02>共計:<font color=red><%=me.length%></font> 筆訊息&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>

	<table width="90%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>

	<tr bgcolor=#f0f0f0 class=es02>
		<td align=middle>處理狀態</td>
		<td align=middle>
		寄件時間
		</td>
		<td align=middle>急迫性</td>
		<td align=middle>類別</td>
		<td  align=middle width=250>主旨</td>
		<td  align=middle>寄件人</td>
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
		<td align=left class=es02><%=sdf.format(me[i].getMessageFromDate())%></td>
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
				out.println((String)ha.get(typeString));
			
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

	</tr>
<%
	}
%>
	</table>  
 	</td></tr></table>
	</center>
<%@ include file="bottom.jsp"%>