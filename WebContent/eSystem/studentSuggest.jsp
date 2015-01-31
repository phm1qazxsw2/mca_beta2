<%@ page language="java"  import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%>
<%@ include file="jumpTop.jsp"%>
<%
	SimpleDateFormat sdf1=new SimpleDateFormat("yyyy-MM-dd");
	JsfAdmin ja=JsfAdmin.getInstance();
	
	JsfTool jt=JsfTool.getInstance();
 	int studentId=Integer.parseInt(request.getParameter("studentId"));
 	
	StudentMgr sm=StudentMgr.getInstance();
	Student stu=(Student)sm.findX(studentId, _ws2.getStudentBunitSpace("bunitId")); 
	
    if (stu==null) {
        %><script>alert("資料不存在");history.go(-1)</script><%
        return;
    }

	Classes[] cl=ja.getAllActiveClasses();	
%>	
<script type="text/javascript" src="js/in.js"></script>
<SCRIPT type="text/javascript" language="JavaScript" src="js/area3.js"> </SCRIPT>
<script type="text/javascript" src="openWindow.js"></script> 
<script>

	function goPagex(pageX) 
	{ 
		var opener=window.opener;
		
		opener.location=pageX;		
	} 

</script>

&nbsp;&nbsp;&nbsp;學生:<font color=blue><%=stu.getStudentName()%></font> -<img src="pic/fix.gif" border=0>就學狀態<br><br>
&nbsp;&nbsp;&nbsp;<a href="modifyStudent.jsp?studentId=<%=stu.getId()%>">基本資料 |   
<a href="studentContact.jsp?studentId=<%=stu.getId()%>">聯絡資訊</a> | 
<a href="studentStatus.jsp?studentId=<%=stu.getId()%>">就學狀態</a>  |
<a href="studentStuff.jsp?studentId=<%=stu.getId()%>">學用品規格</a> |
<!-- <a href="studentTadent.jsp?studentId=<%=stu.getId()%>">才藝班紀錄</a> | -->
電訪/反應事項 |
<a href="studentVisit.jsp?studentId=<%=stu.getId()%>">入學資訊</a>
  <br>
<table width="100%" border=0 cellpadding=0 cellspacing=0><tr align=left valign=top><td background=pic/h01.gif><img src="pic/h01.gif" height=1 border=0 alt=""></td></tr></table>
<br> 
<%
	Message[] me=ja.getStudentMessage(2,studentId);

	if(me==null) 
	{ 
		out.println("<br><br><blockquote><div class=es02>沒有相關紀錄!</div></blockquote>");		
		return;	
	} 
	
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm"); 
	
	UserMgr umm=UserMgr.getInstance();
	
%>  
<div class=es02 align=left>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;共計: <font color=blue><%=me.length%></font>筆</div>
<center>
<table width="" height="" border="0" cellpadding="0" cellspacing="0">
<tr align=left valign=top>
<td bgcolor="#e9e3de">
	<table width="100%" border=0 cellpadding=4 cellspacing=1>
	<tr bgcolor=#ffffff align=left valign=middle>
		<td  bgcolor=#f0f0f0  class=es02>事件時間</td>
		<td  bgcolor=#f0f0f0  class=es02>處理狀態</td>
		<td  bgcolor=#f0f0f0  class=es02>重要性</td>
		<td  bgcolor=#f0f0f0  class=es02>記錄人</td>
		<td  bgcolor=#f0f0f0  class=es02>主旨</td>
		<td  bgcolor=#f0f0f0  class=es02>內容</td>
		<td  bgcolor=#f0f0f0  class=es02>處理人</td>
		<td  bgcolor=#f0f0f0  class=es02>處理內容</td>
		<td  bgcolor=#f0f0f0  class=es02>處理時間</td>
		<td  bgcolor=#f0f0f0  class=es02></td>
	</tr>		
	<%
		for(int i=0;i<me.length;i++) 
		{ 
	%> 
	<tr bgcolor=#ffffff align=left  onmouseover="this.className='highlight'"  onmouseout="this.className='normal2'" valign=middle>
		<td class=es02><%=sdf.format(me[i].getMessageFromDate())%></td>
		<td class=es02>
		<%
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
		%>
		</td>
		<td class=es02>
			<%
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
			%>
		
		</td>
		<td class=es02>
		<%
			User ufrom=(User)umm.find(me[i].getMessageFrom());
			out.println(ufrom.getUserFullname());
		%>
		</td>
		<td class=es02><%=me[i].getMessageTitle()%></td>
		<td class=es02><%=me[i].getMessageHandleContent()%></td>
		<td class=es02>
		<% 	
			User uto=(User)umm.find(me[i].getMessageHandleId()); 
			
			if(uto !=null)
				out.println(uto.getUserFullname());
			else
				out.println("未登入");	
		%>
		
		</td>
		<td class=es02>
		<%=me[i].getMessageHandleContent()%>
		</td>
		<td class=es02><%=(me[i].getMessageHandleDate()!=null)?sdf.format(me[i].getMessageHandleDate()):""%></td> 
		<td class=es02>
			<a href="#" onClick="javascript:goPagex('detailMessage.jsp?meId=<%=me[i].getId()%>')">詳細資料</a>
 	 	</td> 	 		
		
	</tr>			 	 	
	<%
		}
	%>		
	</table>
	</td>
	</tr>
	</table>
	
	</centeR>
<script>
    top.nowpage=5;
</script>