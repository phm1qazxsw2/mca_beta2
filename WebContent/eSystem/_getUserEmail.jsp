<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

	String idS=request.getParameter("id");

	String ran=request.getParameter("ran");

	int userId=Integer.parseInt(idS);
 
	JsfAdmin ja=JsfAdmin.getInstance();
	 
	UserMgr ux=UserMgr.getInstance();
	
	User u2=(User)ux.find(userId);

	JsfPay jp=JsfPay.getInstance(); 
	
	if(u2==null)
  	{
  		out.println(""); 
  				
  	}else{
%>
	<table border=0 class=es02> 
		 <tr>
		  	<td><img src="pic/email.png" border=0>email</td>
<%  	
 	if(jp.checkEmail(u2.getUserEmail())) 
	{ 
%>
			<td><%=u2.getUserEmail()%></td>
			<td>
			<input type=radio name="sendEmail" value=1 checked>同步發送 <input type=radio name="sendEmail" value=0>不發送
			</td>
			
<%	
	}else{
%> 
		<td>
		<font color=blue>無效Email</font> 
		<input type=hidden name="sendEmail" value=0>
		</td>
		<td></tD>
<%			
	}
%> 
	</tR> 
	<tr>
		<td colspan=3>
			<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
		</td>
	</tr>
	<tr>
		<tD><img src="pic/mobile2.gif" border=0> 手機</td>
<%
		if(jp.checkMobile(u2.getUserPhone()))
		{ 
%> 
			<td><%=u2.getUserPhone()%></td> 
			<td>
			<input type=radio name="sendMobile" value=1 checked>同步發送 <input type=radio name="sendMobile" value=0>不發送
			</td>
<%		
		}else{ 
%>
			<td><font color=blue>無效號碼</font></td><td></td>
<%
		}			
%>			
	</tr>				
	</table>
<%	
	} 
%>