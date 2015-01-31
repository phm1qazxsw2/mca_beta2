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
    
	LeaveReason[] lr=ja.getAllLeaveReason(_ws2.getStudentBunitSpace("bunitId"));
	LeaveStudentMgr lsm=LeaveStudentMgr.getInstance();
	LeaveStudent[] ls=ja.getLeaveStudentByStuId(studentId);
	
	UserMgr um=UserMgr.getInstance();
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");	
%>

<b>&nbsp;&nbsp;&nbsp;<%=stu.getStudentName()%>-離校資訊</b>


<%
	if(ls==null)  
	{
		 out.println("<blockquote>沒有登入</blockquote>");
		
         return;
	}
%>
<center>
	<table width="95%" height="" border="0" cellpadding="0" cellspacing="0">
	<tr align=left valign=top>
	<td bgcolor="#e9e3de">

	<table width="100%" border=0 cellpadding=4 cellspacing=1>
		<tr bgcolor=#f0f0f0 class=es02>
				<tD>
					登入時間
				</td>
				<td> 
					離校原因 
				</tD>
				<td>備註</tD>
				<tD>登入人</tD> 
				<td></tD>
		</tR>
		<%
			for(int j=0;j<ls.length;j++)
			{
		%>		
		<form action="modifyLeaveStudent2.jsp" method="post">	
		<tr bgcolor=ffffff class=es02>
			<tD>
			<%=sdf.format(ls[j].getCreated())%>
			</tD>
			<tD>
				<select name="lrId" size==1>
						<%
							for(int i=0;lr!=null&&i<lr.length;i++)
  							{
  						%>
  							<option value="<%=lr[i].getId()%>" <%=(lr[i].getId()==ls[j].getLeaveStudentReasonId())?"selected":""%>><%=lr[i].getLeaveReasonName()%></option>	
  						<%
  							}
  						%>
 					</select>
 				
			</tD>
			<td>
				<textarea name="ps" cols=20 rows=4><%=ls[j].getLeaveStudentPs()%></textarea>
			</tD>
			<tD>
				<%
					User u=(User)um.find(ls[j].getLeaveStudentLogId());
					
					if(u !=null)
						out.println(u.getUserFullname());
				%>
			</tD> 
			<tD> 
				 
				<input type=hidden name="studentId" value="<%=studentId%>"> 
				<input type=hidden name="leaveStudentId" value="<%=ls[j].getId()%>"> 
				<input type=submit value="修改" onClick="return(confirm('確認修改?'))">
			
			</tD>
		</tr> 
		</form>		
		<%
			}
		%>
		</table>
		</td>
		</tr>
		</table>
</center>		