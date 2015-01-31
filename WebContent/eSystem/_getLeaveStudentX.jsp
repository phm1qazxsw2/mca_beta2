<%@ page language="java" import="web.*,jsf.*,java.util.*,java.text.*" contentType="text/html;charset=UTF-8"%><%

	String lsIdS=request.getParameter("lsId");
	int lsId=Integer.parseInt(lsIdS);

	StudentMgr sm=StudentMgr.getInstance();
	
	LeaveStudentMgr lsm=LeaveStudentMgr.getInstance();
	LeaveReasonMgr lrm=LeaveReasonMgr.getInstance();
	LeaveStudent ls=(LeaveStudent)lsm.find(lsId);
	UserMgr um=UserMgr.getInstance();
	if(ls ==null) 
	{ 
		out.println("沒有資料");
		return; 
	}  
	
	Student stu=(Student)sm.find(ls.getLeaveStudentStudentId());
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");	
%>
<b><%=stu.getStudentName()%>-離校紀錄</b>
<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
				<tD>
					登入時間
				</td> 
				<td bgcolor=ffffff> 
					<%=sdf.format(ls.getCreated())%>
				</tD>
		</tr>	
		<tr bgcolor=#f0f0f0 class=es02>
				<td> 
					離校原因 
				</tD>
				<td bgcolor=ffffff>
				<%
					LeaveReason lr=(LeaveReason)lrm.find(ls.getLeaveStudentReasonId());  
					out.println(lr.getLeaveReasonName());
				%>
				</tD>
		</tr>
		<tr bgcolor=#f0f0f0 class=es02>
				<td>備註</tD>
				<td bgcolor=ffffff>
					<%=ls.getLeaveStudentPs()%>
				</tD>
		</tr>		
		<tr bgcolor=#f0f0f0 class=es02>
				<tD>登入人</tD>
				<td bgcolor=ffffff>
				<%
					User u=(User)um.find(ls.getLeaveStudentLogId());
					
					if(u !=null)
						out.println(u.getUserFullname());
				%>

				</tD>
		</tR>
	</table>
	</td>
	</tr>
	</table>